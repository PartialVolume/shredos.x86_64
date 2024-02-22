#!/bin/bash
#
# This program looks for any exfat, fat32 or fat16 filesystem, it then
# examines the filesystem, looking for a kernel file or .img or .iso
# file that has the same version number as the booted ShredOS. Once
# the boot USB has been found this script outputs the drive name in 
# the following form, example being /dev/sdc etc.
#
# If there is no FAT drive found the script fails silently
# producing no output.
#
# If a ShredOS boot device is found it's name is output to the file boot_device.txt
# as well as output to stdout (with no return)
#
# If a ShredOS boot device is not present boot_device.txt is deleted.
#
version=$(cat /etc/shredos/version.txt)
drive_dir="boot_tmp"
drive=""
first_drive=""
boot_disk_found="0"

# Create a directory to mount the USB stick onto.
test -d "$drive_dir"
    if [ $? != 0 ]
    then
        mkdir "$drive_dir"  2>&1 | tee -a transfer.log
    fi

# Remove any previously existing exclusion file
if [ -f "/exclude_disc.txt" ]
then
    rm "/exclude_disc.txt"
fi

# Remove any previously existing file that showed a boot device
if [ -f "/boot_device.txt" ]
then
    rm "/boot_device.txt"
fi

# ----
# Search every disc on the system for a exfat/fat32/fat16 filesystems, mount each
# in turn and see if it could be our boot disc by examining the version on the
# disc against the booted version. Supports vanila ShredOS, Ventoy and Rufus boot discs.
#
while read drive ;
do
	if [[ "$first_drive" == "" ]]
	then
		first_drive=$drive
	fi

	if [[ "$drive" != "" ]]
	then
		mount $drive $drive_dir 2>&1 | tee -a transfer.log

		# Check the partion for the file /etc/shredos/shredos_exclude_disc,
		# If the file is found it indicates that the user considers that
		# this disc is the ShredOS boot disc and should be excluded from nwipe's
		# enumeration.

		test -f "$drive_dir/etc/shredos/shredos_exclude_disc"
		if [ $? == 0 ]
		then
			# output drive & partition, i.e /dev/sdb1 to stdout
			printf "$drive"

			# Strip out partition id from drive and write drive to file i.e /dev/sdb
			printf "$drive" | tr -d '0-9' > /exclude_disc.txt

			# Strip out partition id from drive and write drive to file i.e /dev/sdb
			printf "$drive" | tr -d '0-9' > /boot_device.txt

			boot_disk_found="1"
			umount $drive_dir 2>&1 | tee -a transfer.log
			break
		fi

		# Check for correct version of ShredOS on a vanilla ShredOS or Rufus etc USB drive
		test -f "$drive_dir/boot/version.txt"
		if [ $? == 0 ]
		then
			version_on_USB=$(cat "$drive_dir/boot/version.txt")
			if [[ "$version" == "$version_on_USB" ]]
			then
				# output drive & partition, i.e /dev/sdb1 to stdout
				printf "$drive"

				# Strip out partition id from drive and write drive to file i.e /dev/sdb
				printf "$drive" | tr -d '0-9' > /boot_device.txt

				boot_disk_found="1"
				umount $drive_dir  2>&1 | tee -a transfer.log
				break
			fi
		fi

		# Check each filename for the correct ShredOS version on a Ventoy USB drive
		for filename in $drive_dir/*;
		do
			if [[ "$filename" == *"$version"* ]]
			then
				# output drive & partition, i.e /dev/sdb1 to stdout
				printf "$drive"

				# Strip out partition id from drive and write drive to file i.e /dev/sdb
				printf "$drive" | tr -d '0-9' > /boot_device.txt

				boot_disk_found="1"
				umount $drive_dir 2>&1 | tee -a transfer.log
				break
			fi
		done

		if [[ "$boot_disk_found" == "1" ]]
		then
			break
		fi

		umount $drive_dir 2>&1 | tee -a transfer.log
	fi
done <<< $(fdisk -l | grep -i "exfat\|fat16\|fat32" | awk '{print $1}')

# If no boot disc has been found that contains the version of ShredOS
# that is running, then output the first FAT formatted drive we came across.
#
if [[ "$boot_disk_found" == "0" ]]
then
	printf "$first_drive"
	if [ -f "/boot_device.txt" ]; then
		rm /boot_device.txt
	fi
fi
