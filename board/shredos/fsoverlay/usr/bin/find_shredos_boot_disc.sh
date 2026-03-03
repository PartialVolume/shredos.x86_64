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

# Save original stdout (terminal) to FD 3
# We use this later to print ONLY the device path.
exec 3>&1

# Redirect all stdout and stderr to a file
# All other command output will go to the file instead.
exec >>transfer.log 2>&1

# Create a directory to mount the USB stick onto.
if [[ ! -d "$drive_dir" ]]; then
	mkdir "$drive_dir"
fi

# Remove any previously existing exclusion file
if [[ -f "/exclude_disc.txt" ]]; then
	rm "/exclude_disc.txt"
fi

# Remove any previously existing file that showed a boot device
if [[ -f "/boot_device.txt" ]]; then
	rm "/boot_device.txt"
fi

# ----
# Search every disc on the system for a exfat/fat32/fat16 filesystems, mount each
# in turn and see if it could be our boot disc by examining the version on the
# disc against the booted version. Supports vanila ShredOS, Ventoy and Rufus boot discs.
#
while IFS= read -r drive
do
	if [[ "$drive" != "" ]]
	then
		if mount "$drive" "$drive_dir"
		then
			# Note the first mountable drive, we will use this for storage of PDFs
			# if we can't identify a ShredOS USB stick
			if [[ "$first_drive" == "" ]]
			then
				first_drive="$drive"
			fi
		fi

		# Check the partion for the file /etc/shredos/shredos_exclude_disc,
		# If the file is found it indicates that the user considers that
		# this disc is the ShredOS boot disc and should be excluded from nwipe's
		# enumeration.
		if [[ -f "$drive_dir/etc/shredos/shredos_exclude_disc" ]]
		then
			# output drive & partition, i.e /dev/sdb1 to stdout (FD3)
			printf '%s' "$drive" >&3

			# Strip out partition id from drive and write drive to file i.e /dev/sdb
			printf '%s' "$drive" | tr -d '0-9' > /exclude_disc.txt

			# Strip out partition id from drive and write drive to file i.e /dev/sdb
			printf '%s' "$drive" | tr -d '0-9' > /boot_device.txt

			boot_disk_found="1"
			umount "$drive_dir"
			break
		fi

		# Check for correct version of ShredOS on a vanilla ShredOS or Rufus etc USB drive
		if [[ -f "$drive_dir/boot/version.txt" ]]
		then
			version_on_USB=$(cat "$drive_dir/boot/version.txt")
			if [[ "$version" == "$version_on_USB" ]]
			then
				# output drive & partition, i.e /dev/sdb1 to stdout (FD3)
				printf '%s' "$drive" >&3

				# Strip out partition id from drive and write drive to file i.e /dev/sdb
				printf '%s' "$drive" | tr -d '0-9' > /boot_device.txt

				boot_disk_found="1"
				umount "$drive_dir"
				break
			fi
		fi

		# Check each filename for the correct ShredOS version on a Ventoy USB drive
		for filename in "$drive_dir"/*;
		do
			if [[ "$filename" == *"$version"* ]]
			then
				# output drive & partition, i.e /dev/sdb1 to stdout (FD3)
				printf '%s' "$drive" >&3

				# Strip out partition id from drive and write drive to file i.e /dev/sdb
				printf '%s' "$drive" | tr -d '0-9' > /boot_device.txt

				boot_disk_found="1"
				umount "$drive_dir"
				break
			fi
		done

		if [[ "$boot_disk_found" == "1" ]]
		then
			break
		fi

		umount "$drive_dir"
	fi
done < <(fdisk -l | grep -i "exfat\|fat16\|fat32\|Microsoft basic data" | awk '{print $1}')

# If no boot disc has been found that contains the version of ShredOS
# that is running, then output the first FAT formatted drive we came across.
#
if [[ "$boot_disk_found" == "0" ]]
then
	# output drive & partition, i.e /dev/sdb1 to stdout (FD3)
	printf '%s' "$first_drive" >&3

	if [[ -f "/boot_device.txt" ]]; then
		rm /boot_device.txt
	fi
fi
