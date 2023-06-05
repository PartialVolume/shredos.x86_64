#!/bin/bash
#
# This script will archive the nwipe log file/s and dmesg.txt file to a
# FAT32 formatted partition. If there is more than one FAT32 drive this
# script will always archive to the first drive found.
#
# Written by PartialVolume, a component of ShredOS - the disk eraser.

exit_code=0

# This is the temporary directory that the FAT32 drive is to be mounted on
archive_drive_directory="/archive_drive"

# The nwipe logs that have been sent are moved into this directory in RAM disk.
sent_directory="/sent"

# From all the drives on the system, find the first and probably only FAT32 partition
drive=$(fdisk -l | grep -i '/dev/*' | grep -i FAT32 | awk '{print $1}' | head -n 1)

if [ "$drive" == "" ]; then
	printf "archive_log.sh: No FAT32 formatted drive found, unable to archive nwipe log file\n"
	exit 1
else
	printf "Archiving nwipe logs to $drive\n"
fi

# Create the temporary directory we will mount the FAT32 partition onto.
if [ ! -d "$archive_drive_directory" ]; then
    mkdir "$archive_drive_directory"
    if [ $? != 0 ]; then
                printf "archive_log.sh: Unable to create the temporary mount directory $archive_drive_directory\n"
                exit_code=2
    fi
fi

# mount the FAT32 partition onto the temporary directory
mount $drive $archive_drive_directory
status=$?
if [ $status != 0 ] && [ $status != 32 ]; then
    # exit only if error, except code 32 which means already mounted
    printf "archive_log.sh: Unable to mount the FAT32 partition $drive to $archive_drive_directory\n"
    exit_code=3
else
    printf "archive_log.sh: FAT32 partition $drive is now mounted to $archive_drive_directory\n"

    # Copy the dmesg.txt file over to the FAT32 partition
    dmesg > dmesg.txt
    cp /dmesg.txt "$archive_drive_directory/"
    if [ $? != 0 ]; then
	printf "archive_log.sh: Unable to copy the dmesg.txt file to the root of $drive:/\n"
    else
	printf "archive_log.sh: Sucessfully copied dmesg.txt to $drive:/\n" 
    fi

    # Copy the nwipe log files over to the FAT32 partition
    cp /nwipe_log* "$archive_drive_directory/"
    if [ $? != 0 ]; then
        printf "archive_log.sh: Unable to copy the nwipe log files to the root of $drive:/\n"
    else
        printf "archive_log.sh: Successfully copied the nwipe logs to $drive:/\n"

        # Create the temporary sent directory we will move log files that have already been copied
        if [ ! -d "$sent_directory" ]; then
            mkdir "$sent_directory"
            if [ $? != 0 ]; then
                        printf "archive_log.sh: Unable to create the temporary directory $sent_directory on the RAM disc\n"
                        exit_code=5
            fi
        fi

        if [ exit_code != 5 ]; then
                # Move the nwipe logs into the RAM disc sent directory
                mv /nwipe_log* "$sent_directory/"
                if [ $? != 0 ]; then
                            printf "archive_log.sh: Unable to move the nwipe logs into the $sent_directory on the RAM disc\n"
                            exit_code=6
                else
                            printf "archive_log.sh: Moved the nwipe logs into the $sent_directory\n"
                fi
        fi
    fi
fi

# unmount the FAT32 drive
sleep 1
umount "$archive_drive_directory"
if [ $? != 0 ]; then
                printf "archive_log.sh: Unable to unmount the FAT32 partition\n"
                exit_code=7
else
    printf "archive_log.sh: Successfully unmounted $archive_drive_directory ($drive)\n"
fi

if [ $exit_code != 0 ]; then
    printf "archive_log.sh: Failed to copy nwipe log files to $drive, exit code $exit_code\n"
fi
exit $exit_code
