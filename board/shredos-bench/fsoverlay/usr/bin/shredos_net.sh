#!/bin/bash
#
# Determine all the network devices, i.e those devices that start with
# 'en' (ethernet) or wl (wifi) and then populate /etc/network/interfaces
# with those devices set up as DHCP hot plug. We then monitor the link
# state (whether the ethernet cable is connected).
#
version=1.1-211123-1901
#
# Forcefully shutdown all network interfaces if any are up
ifdown -f -a

# Bring up loopback device
ifup lo

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
		
		# no need to check the return status, whether it works or not we need
		# to initialise the device statuses.
#		ifdown $device

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
		fi
	fi
done

# Now Monitor the link status of each network device
# If we lose the link status 'down' then we bring down that network
# device. ie it's association with an IPv4/IPv6 address is removed.
# When the link status is 'up' then we bring the network back up
# which means we request a IP address via DHCP. This is therefore
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

				device_carrier="$device"_carrier
				eval "$device_carrier"=$(more /sys/class/net/$device/carrier)
				eval device_carrier_result="\${$device_carrier}"

				device_status="$device"_status
				eval device_status_result="\${$device_status}"

#				eval echo "device=$device, status=""\${$device_status}"", device_operstate_result=$device_operstate_result, device_carrier_result=$device_carrier_result, device_status_result=$device_status_result"

				if [[ $device_carrier_result != 1 ]];
				then
					if [[ $device_carrier_result != 0 ]];
					then
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

				if [[ $device_operstate_result == down ]];
				then
					if [[ $device_status_result == up ]];
					then
						ifdown -f $device
						if [ $? == 0 ];
						then
							eval "$device_status"="down"
							echo "[OK] $device is down"
						else
							echo "[FAIL] $device ifdown failed"
						fi
					fi
				else
					if [[ $device_status_result == down ]];
					then
						ifup $device
						if [ $? == 0 ];
						then
							eval "$device_status"="up"
							echo "[OK] $device is up"
						else
							echo "[FAIL] $device ifup failed"
						fi
					fi
				fi
			fi
		fi
	done
	
	# Never remove this sleep statement ! Could be changed to 1 second for
	# a less responsive hotplug, however 0.5 seconds provides sufficient
	# responsiveness while not wasting CPU cycles.
	sleep 0.5
done
