#!/bin/bash
#
# Determine all the network devices, i.e those devices that start with
# 'en' (ethernet) or wl (wifi) and then populate /etc/network/interfaces
# with those devices set up as DHCP hot plug. We then monitor the link
# state (whether the ethernet cable is connected).
#
# Shutdown all network interfaces if any are up
ifdown -a

# delete the existing non populated interfaces file
rm /etc/network/interfaces

# Re-create the interfaces file starting with the loopback device
echo "auto lo" > /etc/network/interfaces
echo "iface lo inet loopback" >> /etc/network/interfaces
echo "" >> /etc/network/interfaces

# Create a list of all network devices
#net_devices=$(ip add | grep ": " | awk '{print $2}' | sed 's/://')
net_devices=$(ls -1 /sys/class/net)

# Populate /etc/network/interfaces with each network device if ethernet or wifi
for device in $net_devices
do
	# We're only interested in ethernet (enxxxx) and wifi (wlxxxx) devices
	if [[ $device == en* ]];
	then
		echo "auto $device" >> /etc/network/interfaces
		echo "iface $device inet dhcp" >> /etc/network/interfaces
	fi
done

# Bring all network devices up and record whether they 
for device in $net_devices
do
	ifup $device
	if [ $? == 0 ];
	then
		# Obtain network device link status
		device_operstate=$(more /sys/class/net/$device/operstate)

		# If the device link status is up record the current state
		if [ $device_operstate == "up" ];
		then
			device_status="up"
		else
			device_status="down"
		fi
	fi
done

# Now Monitor the link status of each network device
# If we lose the link status 'down' then we bring down that network
# device. ie it's association with an IPv4/IPv6 address is removed.
# When the link status is 'up' then we bring the network back up
# which means we request a IP address via DHCP. This is therefore
# acting as a hotplug for ethernet.

while [ 1 ];
do
	for device in $net_devices
	do
		# We're only interested in ethernet (enxxxx) devices
        	if [[ $device == en* ]];
        	then
			# Obtain network device link status
			device_carrier=$(more "/sys/class/net/$device/carrier")
			device_operstate=$(more "/sys/class/net/$device/operstate")

			if [[ $device_carrier != 1 ]];
			then
				if [[ $device_carrier != 0 ]];
				then
					ifup $device
					if [ $? == 0 ];
					then
						device_status="up"
						echo "[OK] $device is now up"
					else
						device_status="down"
						echo "[FAIL] $device could not be brought up"
					fi
				fi
			fi	

			if [[ $device_operstate == down ]];
			then
				if [[ $device_status == up ]];
				then
					ifdown $device
					if [ $? == 0 ];
					then
						device_status="down"
						echo "[OK] $device is now down"
					else
						echo "[FAIL] $device could not be brought down"
					fi
				fi
			else
				if [[ $device_status == down ]];
				then
					ifup $device
					if [ $? == 0 ];
					then
						device_status="up"
						echo "[OK] $device is now up"
					else
						echo "[FAIL] $device could not be brought up"
					fi
				fi
			fi
		fi
	done
	sleep 0.5
done

