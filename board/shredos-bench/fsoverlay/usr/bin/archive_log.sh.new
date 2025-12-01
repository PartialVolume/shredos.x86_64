#!/bin/bash
#
# This script will archive the nwipe log file/s, $dmesg_file files and PDF certificates
# to the first exFAT/FAT32 formatted partition found that is identified as having a
# matching /boot/version.txt file (ShredOS USB) as the booted ShredOS or in the case of
# Ventoy the version within the kernel filename that matches the booted ShredOS.
#
# It also checks whether /etc/nwipe/nwipe.conf and /etc/nwipe/customers.csv exist
# on the USB flash drive and assuming mode 0, read (-r argument) has been selected will
# read those two files from the USB drive into ShredOS's RAM disc, this is normally done
# prior to nwipe launch. Alternatively if mode 1, write (-w argument) is selected both
# /etc/nwipe/nwipe.conf and /etc/nwipe/customers.csv are copied from ShredOS's RAM
# disc back to the USB flash drive, which is normally done on Nwipe exit.
#
# Written by PartialVolume, archive_log.sh is a component of ShredOS - the disk eraser.

# This is the default date format used by ShredOS and nwipe for logs
date_format="+%Y/%m/%d %H:%M:%S"

dmesg_file="dmesg_$(dmidecode  -s system-serial-number).txt"
exit_code=0
mode=""

# What mode is required (read or write)
while getopts 'rw' opt; do
  case "$opt" in
    r)
      mode="read"
      ;;

    w)
      mode="write"
      ;;

    ?)
      echo -e "Invalid command option.\nUsage: $(basename $0) [-r] [-w]"
      exit 1
      ;;
  esac
done

# This is the temporary directory that the exFAT/FAT32 drive is to be mounted on
archive_drive_directory="/archive_drive"

# The nwipe logs that have been sent are moved into this directory in RAM disk.
sent_directory="/sent"

# From all the drives on the system, try to locate the ShredOS boot disc
drive_partition=$(find_shredos_boot_disc.sh)

if [ "$drive_partition" == "" ]; then
	printf "[`date "$date_format"`] archive_log.sh: No exFAT/FAT32 drive found, unable to archive nwipe log files to USB\n" 2>&1 | tee -a transfer.log
	exit 1
else
	printf "[`date "$date_format"`] Archiving nwipe logs to $drive_partition\n" 2>&1 | tee -a transfer.log
fi

# Create the temporary directory we will mount the FAT32 partition onto.
if [ ! -d "$archive_drive_directory" ]; then
    mkdir "$archive_drive_directory"
    if [ $? != 0 ]; then
                printf "[`date "$date_format"`] archive_log.sh: FAILED to create the temporary mount directory $archive_drive_directory\n" 2>&1 | tee -a transfer.log
                exit_code=2
    fi
fi

# mount the FAT32 partition onto the temporary directory
mount $drive_partition $archive_drive_directory
status=$?
if [ $status != 0 ] && [ $status != 32 ]; then
    # exit only if error, except code 32 which means already mounted
    printf "[`date "$date_format"`] archive_log.sh: FAILED to mount the FAT32 partition $drive_partition to $archive_drive_directory\n" 2>&1 | tee -a transfer.log
    exit_code=3
else
    printf "[`date "$date_format"`] archive_log.sh: exFAT/FAT32 partition $drive_partition is now mounted to $archive_drive_directory\n" 2>&1 | tee -a transfer.log

    # Copy the $dmesg_file and PDF files over to the exFAT/FAT32 partition
    dmesg > $dmesg_file
    cp /$dmesg_file "$archive_drive_directory/"
    if [ $? != 0 ]; then
	printf "[`date "$date_format"`] archive_log.sh: FAILED to copy the $dmesg_file file to the root of $drive_partition:/\n" 2>&1 | tee -a transfer.log
    else
	printf "[`date "$date_format"`] archive_log.sh: Copied $dmesg_file to $drive_partition:/\n" 2>&1 | tee -a transfer.log
    fi

    # Copy the PDF certificates over to the exFAT/FAT32 partition
    cp /nwipe_report_*pdf "$archive_drive_directory/"
    if [ $? != 0 ]; then
	printf "[`date "$date_format"`] archive_log.sh: Unable to copy the nwipe_report...pdf file to the root of $drive_partition:/\n" 2>&1 | tee -a transfer.log
    else
	printf "[`date "$date_format"`] archive_log.sh: Copied nwipe_report...pdf to $drive_partition:/\n" 2>&1 | tee -a transfer.log
    fi

    # Copy the nwipe log files over to the exFAT/FAT32 partition
    cp /nwipe_log* "$archive_drive_directory/"
    if [ $? != 0 ]; then
        printf "[`date "$date_format"`] archive_log.sh: Unable to copy the nwipe log files to the root of $drive_partition:/\n" 2>&1 | tee -a transfer.log
    else
        printf "[`date "$date_format"`] archive_log.sh: Copied the nwipe logs to $drive_partition:/\n" 2>&1 | tee -a transfer.log

        # Create the temporary sent directory we will move log files that have already been copied
        if [ ! -d "$sent_directory" ]; then
            mkdir "$sent_directory"
            if [ $? != 0 ]; then
                        printf "[`date "$date_format"`] archive_log.sh: FAILED to create the temporary directory $sent_directory on the RAM disc\n" 2>&1 | tee -a transfer.log
                        exit_code=5
            fi
        fi

        if [ exit_code != 5 ]; then
                # Move the nwipe logs into the RAM disc sent directory
                mv /nwipe_log* "$sent_directory/"
                if [ $? != 0 ]; then
                            printf "[`date "$date_format"`] archive_log.sh: Unable to move the nwipe logs into the $sent_directory on the RAM disc\n" 2>&1 | tee -a transfer.log
                            exit_code=6
                else
                            printf "[`date "$date_format"`] archive_log.sh: Moved the nwipe logs into the $sent_directory\n" 2>&1 | tee -a transfer.log
                fi
                # Move the nwipe PDF certificates into the RAM disc sent directory
                mv /nwipe_report*pdf "$sent_directory/"
                if [ $? != 0 ]; then
                            printf "[`date "$date_format"`] archive_log.sh: Unable to move the PDF certificates into the $sent_directory on the RAM disc\n" 2>&1 | tee -a transfer.log
                else
                            printf "[`date "$date_format"`] archive_log.sh: Moved the PDF certificates into the $sent_directory\n" 2>&1 | tee -a transfer.log
                fi
        fi
    fi
    # If mode 0 (read USB flash drive), read the /etc/nwipe/nwipe.conf and /etc/nwipe/customers.csv files from
    # the USB flash drive into the ShredOS RAM disc
    #
    #
    # Check that the /etc/nwipe directory exists on the ShredOS ram drive, if not create it.
    test -d "/etc/nwipe"
    if [ $? != 0 ]
    then
        mkdir "/etc/nwipe"
        if [ $? != 0 ]; then
            printf "[`date "$date_format"`] archive_log.sh: FAILED to create directory /etc/nwipe on ShredOS ram drive\n" 2>&1 | tee -a transfer.log
        else
            printf "[`date "$date_format"`] archive_log.sh: Created directory /etc/nwipe on ShredOS ram drive\n" 2>&1 | tee -a transfer.log
        fi
    fi
    if [[ "$mode" == "read" ]]; then
        # Copy /etc/nwipe/nwipe.conf from USB to ShredOS's ram disc
        test -f "$archive_drive_directory/etc/nwipe/nwipe.conf"
        if [ $? == 0 ]
        then
            # Copy nwipe.conf from USB flash to ShredOS ram disc
            cp "$archive_drive_directory/etc/nwipe/nwipe.conf" /etc/nwipe/nwipe.conf
            if [ $? != 0 ]; then
                printf "[`date "$date_format"`] archive_log.sh: FAILED to copy $drive_partition:/etc/nwipe/nwipe.conf to ShredOS's ram disc\n" 2>&1 | tee -a transfer.log
            else
                printf "[`date "$date_format"`] archive_log.sh: Copied $drive_partition:/etc/nwipe/nwipe.conf to ShredOS's ram disc\n" 2>&1 | tee -a transfer.log
            fi
        fi

        # Copy /etc/nwipe/customers.csv from USB to ShredOS's ram disc
        test -f "$archive_drive_directory/etc/nwipe/nwipe_customers.csv"
        if [ $? == 0 ]
        then
            # Copy nwipe.conf from USB flash to ShredOS ram disc
            cp "$archive_drive_directory/etc/nwipe/nwipe_customers.csv" /etc/nwipe/nwipe_customers.csv
            if [ $? != 0 ]; then
                printf "[`date "$date_format"`] archive_log.sh: FAILED to copy $drive_partition:/etc/nwipe/nwipe_customers.csv to /etc/nwipe/nwipe_customers.csv\n" 2>&1 | tee -a transfer.log
            else
                printf "[`date "$date_format"`] archive_log.sh: Copied $drive_partition:/etc/nwipe/nwipe_customers.csv to /etc/nwipe/nwipe_customers.csv\n" 2>&1 | tee -a transfer.log
            fi
        fi
    fi
    # If mode 1 (write USB flash drive), write the /etc/nwipe/nwipe.conf and /etc/nwipe/customers.csv files to
    # the USB flash drive from the ShredOS RAM disc.
    #
    #
    # Check the /etc/ and /etc/nwipe directories exist on the USB drive, if not create them
    test -d "$archive_drive_directory/etc"
    if [ $? != 0 ]
    then
        mkdir "$archive_drive_directory/etc"
        if [ $? != 0 ]; then
            printf "[`date "$date_format"`] archive_log.sh: FAILED to create directory /etc on $drive_partition:/\n" 2>&1 | tee -a transfer.log
        else
            printf "[`date "$date_format"`] archive_log.sh: Created directory /etc on $drive_partition:/\n" 2>&1 | tee -a transfer.log
        fi
    fi

    test -d "$archive_drive_directory/etc/nwipe"
    if [ $? != 0 ]
    then
        mkdir "$archive_drive_directory/etc/nwipe"
        if [ $? != 0 ]; then
            printf "[`date "$date_format"`] archive_log.sh: FAILED to create directory /etc/nwipe on $drive_partition:/\n" 2>&1 | tee -a transfer.log
        else
            printf "[`date "$date_format"`] archive_log.sh: Created directory /etc/nwipe on $drive_partition:/\n" 2>&1 | tee -a transfer.log
        fi
    fi
    if [[ "$mode" == "write" ]]; then
        # Copy /etc/nwipe/nwipe.conf from ShredOS's ram disc to USB
        test -f "/etc/nwipe/nwipe.conf"
        if [ $? == 0 ]
        then
            cp /etc/nwipe/nwipe.conf "$archive_drive_directory/etc/nwipe/nwipe.conf"
            if [ $? != 0 ]; then
                printf "[`date "$date_format"`] archive_log.sh: FAILED to copy /etc/nwipe/nwipe.conf to $drive_partition:/etc/nwipe/nwipe.conf\n" 2>&1 | tee -a transfer.log
            else
                printf "[`date "$date_format"`] archive_log.sh: Copied /etc/nwipe/nwipe.conf to $drive_partition:/etc/nwipe/nwipe.conf\n" 2>&1 | tee -a transfer.log
            fi
        fi

        # Copy /etc/nwipe/customers.csv from ShredOS's ram disc to USB
        test -f "/etc/nwipe/nwipe_customers.csv"
        if [ $? == 0 ]
        then
            cp /etc/nwipe/nwipe_customers.csv "$archive_drive_directory/etc/nwipe/nwipe_customers.csv"
            if [ $? != 0 ]; then
                printf "[`date "$date_format"`] archive_log.sh: FAILED to copy /etc/nwipe/nwipe_customers.csv file to the root of $drive_partition:/etc/nwipe/nwipe_customers.csv\n" 2>&1 | tee -a transfer.log
            else
                printf "[`date "$date_format"`] archive_log.sh: Copied /etc/nwipe/nwipe_customers.csv to $drive_partition:/etc/nwipe/nwipe_customers.csv\n" 2>&1 | tee -a transfer.log
            fi
        fi
    fi
fi

# unmount the FAT32 drive
sleep 1
umount "$archive_drive_directory"
if [ $? != 0 ]; then
                printf "[`date "$date_format"`] archive_log.sh: FAILED to unmount the FAT partition\n" 2>&1 | tee -a transfer.log
                exit_code=7
else
    printf "[`date "$date_format"`] archive_log.sh: Unmounted $archive_drive_directory ($drive_partition)\n" 2>&1 | tee -a transfer.log
fi

if [ $exit_code != 0 ]; then
    printf "[`date "$date_format"`] archive_log.sh: FAILED to copy nwipe log files to $drive_partition, exit code $exit_code\n" 2>&1 | tee -a transfer.log
fi
exit $exit_code
