#!/bin/bash
#
# Determine all the network devices, i.e those devices that start with
# 'en' (ethernet) or wl (wifi) and then populate /etc/network/interfaces
# with those devices set up as DHCP hot plug. We then monitor the link
# state (whether the ethernet cable is connected).
#
version=1.2-251205-0017
#
# Forcefully shutdown all network interfaces if any are up
ifdown -f -a

# Bring up loopback device
ifup lo

# ------------------------------------------------------------
# Option: completely disable networking
# Kernel cmdline flags: "nonet" or "shredos_nonet"
# ------------------------------------------------------------
if grep -Eq '(^| )nonet(=| |$)|(^| )shredos_nonet(=| |$)' /proc/cmdline 2>/dev/null; then
    echo "[INFO] Network disabled via kernel cmdline (nonet/shredos_nonet)."
    exit 0
fi

# delete the existing non populated interfaces file
rm /etc/network/interfaces

# Re-create the interfaces file starting with the loopback device
echo "auto lo" > /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

# Create a list of all network devices
net_devices=$(ls -1 /sys/class/net)

active_device="none"

# Populate /etc/network/interfaces with each network device if ethernet or wifi
for device in $net_devices
do
	# We are only interested in ethernet enxxxx or ethxx devices
	if [[ "$device" == en* ]] || [[ "$device" == et* ]]
	then
		echo "auto $device" >> /etc/network/interfaces
		echo "iface $device inet dhcp" >> /etc/network/interfaces
	fi
done

# Check for existing active ethernet devices and set active_device variable
for device in $net_devices
do
	# We're only interested in ethernet enxxxx or ethxx devices
	if [[ "$device" == en* ]] || [[ "$device" == et* ]]
	then
		# initial creation of device operstate and status variables for
		# each network device, indirectly referenced so you won't see
		# those variable names in this code, but even so they are there.
		# Variable such as enp6s0_operstate, enp6s0_carrier, enp6s0_status
		# are created for each device.

		device_operstate="$device"_operstate
		device_status="$device"_status
		device_carrier="$device"_carrier
		device_carrier_up_count="$device"_carrier_up_count
		device_carrier_down_count="$device"_carrier_down_count

 		# Keep a record of the previous carrier up and down counts so
		# we know if anything has changed and can take the appropriate action
		device_carrier_up_count="$device"_carrier_up_count
		eval "$device_carrier_up_count"=$(more /sys/class/net/$device/carrier_up_count)
		eval device_carrier_up_count_previous_result="\${$device_carrier_up_count}"

		device_carrier_down_count="$device"_carrier_down_count
		eval "$device_carrier_down_count"=$(more /sys/class/net/$device/carrier_down_count)
		eval device_carrier_down_count_previous_result="\${$device_carrier_down_count}"

		# no need to check the return status, whether it works or not we need
		# to initialise the device statuses.

		# Obtain network device link status
		eval "$device_operstate"=$(more /sys/class/net/$device/operstate)
		eval device_operstate_result="\${$device_operstate}"

		# If the device link status is up record the current state
		if [ $device_operstate_result == "up" ];
		then
			eval "$device_status"="up"
			echo "[OK] $device is up"
			active_device="$device"
		else
			eval "$device_status"="down"
			echo "[OK] $device is down"
			if [ "$active_device" == "$device" ];
			then
				active_device="none"
			fi
			ifup $device
			if [ $? == 0 ];
			then
				eval "$device_status"="up"
				echo "[OK] $device is up"
				active_device="$device"
			else
				eval "$device_status"="down"
				echo "[FAIL] $device ifup failed"
				if [ "$active_device" == "$device" ];
				then
					active_device="none"
				fi
			fi
		fi
	fi
done

# Now Monitor the carrier up down values of each network device
# If carrier up or down changes, i.e. the network lead is unplugged
# then we bring down that network device. It's association with an
# IPv4/IPv6 address is removed. We then bring the interface back up,
# even though no network lead may not be plugged in.
#
# When the link status is 'up' then we issue an ifup to makesure
# its up. As it most likely is, it will say device already configured.
# An IP address is requested via the DHCP protocol. This is therefore
# acting as a hotplug for ethernet. We only need one active ethernet
# connection, so on a system with multiple ethernet points as soon
# as one is active and succesfully retrieves a IP addres via DHCP we
# no longer try to bring the rest up.
#

while [ 1 ];
do
	for device in $net_devices
	do

			# We're only interested in ethernet enxxxx or ethxx devices
        	if [[ "$device" == en* ]] || [[ "$device" == eth* ]]
        	then

				# and we are only interested in one device being active at any one time
        		if [ "$active_device" == "$device" ] || [ "$active_device" == "none" ];
        		then

				# Obtain network device link status and carrier states
				device_operstate="$device"_operstate
				eval "$device_operstate"=$(more /sys/class/net/$device/operstate)
				eval device_operstate_result="\${$device_operstate}"

				device_carrier_up_count="$device"_carrier_up_count
				eval "$device_carrier_up_count"=$(more /sys/class/net/$device/carrier_up_count)
				eval device_carrier_up_count_result="\${$device_carrier_up_count}"

				device_carrier_down_count="$device"_carrier_down_count
				eval "$device_carrier_down_count"=$(more /sys/class/net/$device/carrier_down_count)
				eval device_carrier_down_count_result="\${$device_carrier_down_count}"

				device_status="$device"_status
				eval device_status_result="\${$device_status}"

				if [ $device_carrier_down_count_previous_result != $device_carrier_down_count_result ];
				then
					ifdown -f $device
					if [ $? == 0 ];
					then
						eval "$device_status"="down"
						echo "[OK] $device is down"
					else
						echo "[FAIL] $device ifdown failed"
					fi
					device_carrier_down_count="$device"_carrier_down_count
					eval "$device_carrier_down_count"=$(more /sys/class/net/$device/carrier_down_count)
					eval device_carrier_down_count_previous_result="\${$device_carrier_down_count}"

					# After the carrier is lost and the interface brought down, bring it back up
					# so DHCP requests will be issued as soon as it's plugged back in.
					ifup $device
					if [ $? == 0 ];
					then
						eval "$device_status"="up"
						echo "[OK] $device is up"
					else
						echo "[FAIL] $device ifup failed"
					fi
				fi

				if [ $device_carrier_up_count_previous_result != $device_carrier_up_count_result ];
				then
					ifup $device
					if [ $? == 0 ];
					then
						eval "$device_status"="up"
						echo "[OK] $device is up"
					else
						echo "[FAIL] $device ifup failed"
					fi
					# update previous carrier up count value
					device_carrier_up_count="$device"_carrier_up_count
					eval "$device_carrier_up_count"=$(more /sys/class/net/$device/carrier_up_count)
					eval device_carrier_up_count_previous_result="\${$device_carrier_up_count}"
				fi
			fi
		fi
	done
	
	# Never remove this sleep statement ! Could be changed to 1 second for
	# a less responsive hotplug, however 0.5 seconds provides sufficient
	# responsiveness while not wasting CPU cycles.
	sleep 0.5
done
