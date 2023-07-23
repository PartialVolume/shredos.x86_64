<!-- ShredOS LOGO -->
<br />
<p align="left">
  <a href="https://github.com/PartialVolume/shredos.x86_64/">
    <img src="images/shred_db.png" alt="Logo" width="160" height="160">
  </a>
</p>
	<p align="left">
	<a href="https://www.buymeacoffee.com/Shredos" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" "height="60" width="217"></a>
		</p>
</p>

# ShredOS x86_64 - Disk Eraser

## For all Intel and compatible 64 & 32 bit processors

#### As well as a 64bit versions, also included are 32bit .img & .iso images of ShredOS that will run on both 32bit and 64bit processors, see [Release Assets](https://github.com/PartialVolume/shredos.x86_64/releases) and the table of download links below. For those that wish to build their own ShredOS from source, rather than just burn the .img/.iso images, instructions for modififing the x86_64 build to generate 32bit code as well as .iso images will be included below in the notes in due course.
		
#### For those that just want to get on with using ShredOS, you can download the prebuild .img or .iso images and burn them straight to USB flash drive or CD/DVD. Boot from the USB flash drive or CD/DVD and nwipe will appear ready for you to select your preferred wipe options.
[![GitHub all releases](https://img.shields.io/github/downloads/PartialVolume/shredos.x86_64/total?label=Total%20downloads%20x86_64%20all%20releases,%2064%20and%2032bit%20code,%20.iso%20and%20.img%20&style=plastic)](https://github.com/PartialVolume/shredos.x86_64/releases)

## Download the Latest ShredOS .img and .iso files for burning to USB flash drives and CD-R/DVD-R.

> **Warning**
> v2021.08.2_23_x86-64_0.34 (v23) is missing the AMDGPU, Radeon and Intel firmware and therefore on some systems will not boot to the nwipe program. If you find your system doesn't boot please try the preview version, v2021.08.2_23.1_x86-64_0.34 (v23.1), see [release page](https://github.com/PartialVolume/shredos.x86_64/releases/tag/v2021.08.2_23.1_x86-64_0.34) for the details and  [shredos-2021.08.2_23.1_x86-64_0.34_20230320.img](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_23.1_x86-64_0.34/shredos-2021.08.2_23.1_x86-64_0.34_20230320.img) for the .img file to burn to a USB stick. This pre-release version includes the missing firmware required for DRM graphics. Please leave a comment in [discussions](https://github.com/PartialVolume/shredos.x86_64/discussions/134) on whether it worked (or not), with the preview version (23.1) of ShredOS

NOTE! There may be pre-release versions that are newer than the latest versions listed below, To see all versions, [pre-release & latest](https://github.com/PartialVolume/shredos.x86_64/releases) The latest versions contain a full set of .img & .iso images in 32bit & 64bit while the pre-releases generally only contain a 64bit .img. Which should you use? Well, unless you need either 32 bit images or .iso images I would tend to download the very latest pre-release. Even the pre-releases are subjected to a fair amount of testing before they become a pre-release.

### ShredOS version v2021.08.2_23_x86-64_0.34 (LATEST RELEASE) 
| Media | Nwipe Version | File to download |
| -- | -- | -- |
| 64bit .img for USB flash drive | v0.34 | [ShredOS .img 64bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_23_x86-64_0.34/shredos-2021.08.2_23_x86-64_0.34_20221231.img) |
| 64bit .iso for CD/DVD | v0.34 | [ShredOS .iso 64bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_23_x86-64_0.34/shredos-2021.08.2_23_x86-64_0.34_20221231.iso) |
| 32bit .img for USB flash drive | v0.34 | [ShredOS .img 32bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_23_x86-64_0.34/shredos-2021.08.2_23_i586_0.34_32-bit_20221231.img) |
| 32bit .iso for CD/DVD | v0.34 | [ShredOS .iso 32bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_23_x86-64_0.34/shredos-2021.08.2_23_i586_0.34_32-bit_20221231.iso) |

### ShredOS version v2021.08.2_21_x86-64_0.32.023 (PREVIOUS RELEASE)
| Media | Nwipe Version | File to download |
| -- | -- | -- |
| 64bit .img for USB flash drive | v0.32.023 | [ShredOS .img 64bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_21_x86-64_0.32.023/shredos-2021.08.2_21_x86-64_0.32.023_20220123.img) |
| 64bit .iso for CD/DVD | v0.32.023 | [ShredOS .iso 64bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_21_x86-64_0.32.023/shredos-2021.08.2_21_x86-64_0.32.023_20220126.iso) |
| 32bit .img for USB flash drive | v0.32.023 | [ShredOS .img 32bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_21_x86-64_0.32.023/shredos-2021.08.2_21_i586_0.32.023_20220126.img) |
| 32bit .iso for CD/DVD | v0.32.023 | [ShredOS .iso 32bit](https://github.com/PartialVolume/shredos.x86_64/releases/download/v2021.08.2_21_x86-64_0.32.023/shredos-2021.08.2_21_i586_0.32.023_20220126.iso) |

### For all releases including latest and more recent pre-releases [releases](https://github.com/PartialVolume/shredos.x86_64/releases)

Note: The .img files for burning to USB flash drives support both bios/UEFI booting. The .iso image currently supports legacy bios booting only and not UEFI, however, a bios/UEFI version of the .iso is in development and will be released shortly.
You can also consider [VENTOY (Open Source tool to create bootable USB drive for ISO/WIM/IMG/VHD(x)/EFI files)](https://github.com/ventoy/Ventoy) as a workaround to avoid bios/UEFI issues.
		
#### Demo video showing ShredOS having booted straight into Nwipe where you can then select one or more drives to be erased.

![Example wipe](/images/example_wipe.gif)

1. [What is ShredOS?](#what-is-shredos)
1. [What do I do after I've erased everything on my disk? What is actually erased?](#what-do-i-do-after-ive-erased-everything-on-my-disk-what-is-actually-erased)
1. [Nwipe's erasure methods](#nwipes-erasure-methods)
1. [Obtaining and writing ShredOS to a USB flash drive - The easy way!](#obtaining-and-writing-shredos-to-a-usb-flash-drive-the-easy-way)
   1. [Linux and MAC users](#linux-and-mac-users)
   1. [Windows users](#windows-users)
   1. [Multi OS with VENTOY](#multi-os-with-ventoy)
1. [A word about the MAC Book Pro](#a-word-about-the-mac-book-pro)
1. [Having trouble with USB adapters not working/hanging, want to buy one that works properly!](https://github.com/PartialVolume/shredos.x86_64/discussions/128#discussion-4906723)
1. [Virtual terminals](#virtual-terminals)
1. [How to run nwipe so you can specify nwipe command line options](#how-to-run-nwipe-so-you-can-specify-nwipe-command-line-options)
1. [How to change the default nwipe options so the change persists between reboots](#how-to-change-the-default-nwipe-options-so-the-change-persists-between-reboots)
1. [How to set the keyboard map using the loadkeys command (see here for persistent change between reboots](#how-to-set-the-keyboard-map-using-the-loadkeys-command-see-here-for-persistent-change-between-reboots)
1. [How to make a persistent change to keyboard maps](#how-to-make-a-persistent-change-to-keyboard-maps)
1. [Reading and saving nwipes log files - via USB (manually) or ftp (manually & automatically)](#reading-and-saving-nwipes-log-files---via-usb-manually-or-ftp-manually--automatically)
   1. [Transferring nwipe log files to a USB storage device](#transferring-nwipe-log-files-to-a-usb-storage-device)
   1. [Transferring nwipe log files to a ftp server](#transferring-nwipe-log-files-to-a-ftp-server)
1. [How to wipe drives on headless systems or systems with faulty display hardware. (For use on secure LANs only)](#how-to-wipe-drives-on-headless-systems-or-systems-with-faulty-display-hardware-for-use-on-secure-lans-only)
1. [Nwipe's font size is too small, How to double the size of the text](#Nwipes-font-size-is-too-small-How-to-double-the-size-of-the-text)
1. [Shredos includes the following related programs](#shredos-includes-the-following-related-programs)
   1. [smartmontools](#smartmontools)
   1. [hexedit](#hexedit)
   1. [hdparm](#hdparm)
1. [Compiling shredos and burning to USB stick, the harder way!](#compiling-shredos-and-burning-to-usb-stick-the-harder-way-)
   1. [Install the following prerequisite software first. Without this software, the make command will fail](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#install-the-following-prerequisite-software-first-without-this-software-the-make-command-will-fail)
   1. [Download the ShredOS source using the git command and build ShredOS](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#download-the-shredos-source-using-the-git-command-and-build-shredos)
   1. [Commands to configure buildroot, you will only need to use these if you are making changes to ShredOS](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#commands-to-configure-buildroot-you-will-only-need-to-use-these-if-you-are-making-changes-to-shredos)
1. [Important ShredOS files and folders when building from source](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#important-shredos-files-and-folders-when-building-from-source)
	1. [../board/shredos/doimg.sh](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#boardshredosdoimgsh)
	1. [../board/shredos/version.txt](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#boardshredosversiontxt)
	1. [../board/shredos/fsoverlay/](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#boardshredosfsoverlay)
	1. [../board/shredos/fsoverlay/etc/init.d/S40network](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#boardshredosfsoverlayetcinitds40network)
	1. [../board/shredos/fsoverlay/usr/bin/nwipe_launcher](https://github.com/PartialVolume/shredos.x86_64/blob/master/README.md#boardshredosfsoverlayusrbinnwipe_launcher)
	1. [../package/nwipe/](#packagenwipe)
	1. [../package/nwipe/nwipe.mk](#packagenwipenwipemk)
	1. [../package/nwipe/nwipe.hash](#packagenwipenwipehash)
	1. [../package/nwipe/Config.in](#packagenwipeconfigin)
	1. [../package/nwipe/002-nwipe-banner-patch.sh](#packagenwipe002-nwipe-banner-patchsh)

## What is ShredOS?
ShredOS is a USB bootable (BIOS or UEFI) small linux distribution with the sole purpose of securely erasing the entire contents of your
disks using the program [nwipe](https://github.com/martijnvanbrummelen/nwipe). If you are familiar with dwipe from DBAN then you will feel right at home with ShredOS and nwipe. What are the advantages of nwipe over dwipe/DBAN? Well as everybody probably knows, DBAN development stopped in 2015 which means it has not received any further bug fixes or support for new hardware since that date. Nwipe originally was a fork of dwipe but has continued to have improvements and bug fixes and is now available in many Linux distros. ShredOS hopefully will always provide the latest nwipe on a up to date Linux kernel so it will support modern hardware.

ShredOS supports either 32bit or 64bit processors. You will need to download the appropriate 64bit or 32bit .img or .iso file, depending upon your target processor and whether you want to burn ShredOS to a USB memory stick, in which case you would download the .img file. Alternatively, if you wanted to burn ShredOS to CD/DVD, then you would download the .iso file.

Because ShredOS boots and runs straight from a USB flash drive or DVD/CD, it doesn't matter what operating system already exists on the computer. It will remove all data/directories/operating systems, from the drive or drives you have selected for wiping, leaving a disk with no trace of what originally existed. It will wipe PC's & Intel based MACs, such as MAC Book Pros. It doesn't care what operating system previosuly existed, be it Windows/MAC OSX/Linux/VXWorks. 

ShredOS can be used as a software image and booted via the network using a client PC that supports Preboot execution environment (PXE) via a PXE enabled server. A procedure for creating a simple UEFI PXE server based on Debian/Ubuntu and serving up ShredOS can be found here [#148](https://github.com/PartialVolume/shredos.x86_64/discussions/148)
		
You can also use ShredOS on headless systems or systems with faulty display hardware as it includes a user enabled telnet server. Further details can be found here. [How to wipe drives on headless systems or systems with faulty or missing display hardware or keyboards](#how-to-wipe-drives-on-headless-systems-or-systems-with-faulty-display-hardware-for-use-on-secure-lans-only)

ShredOS includes the latest Nwipe official release, but in addition includes other disc related utilities such as Smartmontools, hdparm, a hexeditor [hexedit](https://linux.die.net/man/1/hexedit), and, the program loadkeys which can be used for [setting the keyboard layout](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#how-to-set-the-keyboard-map-using-the-loadkeys-command-see-here-for-persistent-change-between-reboots). Nwipe automatically starts it's GUI in the first virtual terminal (ALT-F1), hdparm, smartmontools and hexeditor can be run in the second virtual terminal, (ALT-F2). Nwipe will erase drives using a user selectable choice of seven methods. hdparm - amongst many of its options - can be used for wiping a drive by [issueing ATA erase commands to the drive's internal firmware](https://ata.wiki.kernel.org/index.php/ATA_Secure_Erase). This is a planned feature addition to nwipe.

ShredOS boots very quickly and depending upon the host system can boot in as little as 2 seconds (typically 4 to 6 seconds) on modern hardware, while on an old Pentium4 may take 40+ seconds. Nwipe automatically starts in GUI mode and will list the disks present on the host system. In fact, Nwipe can launch so fast that the USB devices have not yet initialised so the first time nwipe appears it may not show any USB drives. If you then use Control-C to exit and restart nwipe, you should now see any attached USB devices. You can then select the methods by which you want to securely erase the disk/s. Nwipe is able to simultanuosly wipe multiple disks using a threaded software architecture. I have simultaneously wiped 28 loop devices in tests and know of instances where it's been used to wipe upwards of 10 drives on a system.
		
The vanilla version of ShredOS boots into nwipe's GUI and shows the available discs that can then be selected for wiping. It does not autonuke your discs at launch, however it is capable of doing that, if you edit the grub.cfg file and specify the appropriate nwipe command line option. Details of configuring nwipe's launch behaviour is shown below [How to run nwipe so you can specify nwipe command line options](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#how-to-run-nwipe-so-you-can-specify-nwipe-command-line-options)

## What do I do after I've erased everything on my disk? What is actually erased?
> **Warning**
> Nwipe & therefore ShredOS does not automatically detect HDA (hidden disc areas) i.e the disc reporting a smaller size than it actually is. You should always run hdparm to detect for a HDA (and correct if necessary) before running a wipe.
>
>HPA/DCO detection and correction, along with the automatic creation of PDF certificates will appear in nwipe 0.35 and will be included in the next release of ShredOS.
		
This paragraph is for those that are not familiar with wiping discs. if you know what you are doing skip to the next section. So you have erased your disc with ShredOS/nwipe and nwipe reported zero errors and the disc was erased. In it's erased state and depending upon the method you used every block on the drive contains either zero's or meaningless random data. In this state the disc won't be recognised by your operating system except at a very low level or by specialised programs. You won't be able to write files to the disc because nwipe has removed everything, absolutely everything, the operating system is gone, all your data is gone, the partition table is gone, the file system gone, the MBR and all the files have been erased without a trace and will never ever be recovered from the disk. The only thing left is a whole load of zeros or random data. To make the disc usable again you will either need to format the disk, which creates a partition table and directory structure or install a new operating system such as Linux or Windows. Of course, if you are just disposing of or reselling the disk then you don't need to do anything else. So if you are reasonably happy that you know what you are doing and you understand that you will need to format the disc then I hope this software does it's job and is useful to you. Before you press that 'S' key to start the wipe, pause and double check you have selected the correct drive/s, something I always do !

## Nwipe's erasure methods

* Fill With Zeros    - Fills the device with zeros (0x00), one round only.
* Fill With Ones     - Fills the device with ones  (0xFF), one round only.
* RCMP TSSIT OPS-II  - Royal Candian Mounted Police Technical Security Standard, OPS-II
* DoD Short          - The American Department of Defense 5220.22-M short 3 pass wipe (passes 1, 2 & 7).
* DoD 5220.22M       - The American Department of Defense 5220.22-M full 7 pass wipe.
* Gutmann Wipe       - Peter Gutmann's method (Secure Deletion of Data from Magnetic and Solid-State Memory).
* PRNG Stream        - Fills the device with a stream from the PRNG.
* Verify Zeros       - This method only reads the device and checks that it is filled with zeros (0x00).
* Verify Ones        - This method only reads the device and checks that it is filled with ones (0xFF).
* HMG IS5 enhanced   - Secure Sanitisation of Protectively Marked Information or Sensitive Information
		
Nwipe also includes the following pseudo random number generators:
* Mersenne Twister (mt19937ar-cok)
* ISAAC (rand.c 20010626)

## Obtaining and writing ShredOS to a USB flash drive, the easy way!

You can of course compile ShredOS from source but that can take a long time and you can run into all sorts of problems if your not familiar with compiling an operating system. So if you just want to get started with using ShredOS and nwipe then just download the ShredOS image file and write it to a USB flash drive. Please note this will over write the existing contents of your USB flash drive.

Download the latest ShredOS for either 32bit, 64bit, .img or .iso from [here](#download-img-and-iso-files-for-burning-to-usb-flash-drives-and-cd-rdvd-r)

#### Linux (and MAC) users

Check it's not corrupt by running the following command and comparing with the checksum shown in the release notes:
```
$ sha1sum shredos.img.tar.gz (shasum instead of sha1sum if your using a MAC)
(example) sha1 db37ea8526a17898b0fb34a2ec4d254744ef08a1 shredos.img.tar.gz
```
If the image file has a .img.tar.gz extension then use the following commands to extract the .img file. If the file extension simply ends with .img and there is no tar.gz then skip this step.
```
$ gunzip shredos.img.tar.gz
$ tar xvf shredos.img.tar
```
If you are using linux or a MAC write the shredos.img file (also sometimes called shredos-2020MMDD.img i.e. shredos-20200418.img etc) to your USB flash drive using the following command.  (/dev/sdx is the device name of your USB drive, this can be obtained from the results of sudo fdisk -l on linux and diskutil list on a MAC)
```
sudo dd if=shredos.img of=/dev/sdx

```
#### Windows users:
If you are a windows user, use a program such as [Rufus](https://rufus.ie/) or [etcher](https://www.balena.io/etcher/) to write the image file to a USB stick, remembering that the entire contents of the USB flash drive will be overwritten. [Winzip](https://www.winzip.com/win/en/) can be used to extract the shredos.img file from the compressed shredos.img.tar.gz file that you downloaded. [hashtab](http://implbits.com/products/hashtab/) can be downloaded and used to confirm the sha1 checksum.

#### Multi OS with VENTOY
As explained on the [GitHub repository](https://github.com/ventoy/Ventoy):
> Ventoy is an open source tool to create bootable USB drive for ISO/WIM/IMG/VHD(x)/EFI files.
With ventoy, you don't need to format the disk over and over, you just need to copy the image files to the USB drive and boot it. You can copy many image files at a time and ventoy will give you a boot menu to select them.
You can also browse ISO/WIM/IMG/VHD(x)/EFI files in local disk and boot them.
x86 Legacy BIOS, IA32 UEFI, x86_64 UEFI, ARM64 UEFI and MIPS64EL UEFI are supported in the same way.
Both MBR and GPT partition style are supported in the same way.
Most type of OS supported(Windows/WinPE/Linux/Unix/ChromeOS/Vmware/Xen...)
920+ ISO files are tested (List). 90%+ distros in distrowatch.com supported (Details).

Once your USB removable drive is having VENTOY installed, you just have to copy the latest .iso version of ShredOS at the root.

		
## Virtual Terminals
ShredOS has three tty terminals, ALT-F1 (Where nwipe is initially launched), ALT-F2 (A virtual terminal), ALT-F3 (console log, login required which is root with no password). Typical use of a virtual terminal might be to run other disk related tools such as hdparm to remove hidden sectors or hexedit to display the contents of the disc as hexadecimal values.

## A word about the MAC Book Pro
Yes, ShredOS will boot on MAC Book Pros, however here's a few tips you may find useful.

- Booting from USB. Power off then power on holding down the `alt` key. After a few seconds select EFI boot.
- Due to the high resolution screens on a MAC Book Pro you may find the text displayed by nwipe and in the virtual terminals is very small. To enlarge the text follow the instructions [here](#nwipes-font-size-is-too-small-I-want-the-text-to-be-bigger).
- How to switch between virtual terminals on a MAC. On a PC it's usually (but not always) ALT F1 (/dev/tty1 - nwipe), ALT F2 (/dev/tty2 or /dev/tty0 - terminal), ALT F3 (/dev/console - console). However on a MAC you switch virtual terminals as follows. FN+ALT F1 (/dev/tty1 - nwipe), FN+ALT F2 (/dev/tty2 or /dev/tty0 - terminal), FN+ALT F3 (/dev/console).

## How to make a persistent change to the terminal resolution

This procedure only applies to setting the resolution of the frame buffer in legacy boot. Using `set gfxpayload=1024x768x16` appears to have no affect on UEFI resolution.

After you have created the bootable ShredOS USB flash drive, you may want to increase the resolution from the default value which is usually quite low, i.e. 640x480 in legacy boot.
		
If you prefer a higher resolution than 640x480, then edit the /boot/grub/grub.cfg file as shown below. However very occasionally it might be necessary to change the resolution. Case in point, a blank screen after booting ShredOS. Sometimes you may come across a monitor that will not work with 640x480 resolution, such as the HP compaq LA2405X. In which case you should increase the resolution to 1024x768x16 which seems to work with the majority of monitors, even 16:10/16:9 ratio monitors.

#### Example resolutions based on screen aspect ratio:
**4:3 aspect ratio resolutions:**
		640×480, 800×600, 960×720, 1024×768, 1280×960, 1400×1050, 1440×1080 , 1600×1200, 1856×1392, 1920×1440, and 2048×1536.
		
**16:10 aspect ratio resolutions:**
		1280×800, 1440×900, 1680×1050, 1920×1200, 2560×1600 and 2880x1800.
		
**16:9 aspect ratio resolutions:**
		1024×576, 1152×648, 1280×720, 1366×768, 1600×900, 1920×1080, 2560×1440 and 3840×2160.
		
Add the command `set gfxpayload=1024x768x16` prior to the kernel command line, changing the resolution as required for your hardware/monitor. See the example below:
```
set default="0"
set timeout="0"
set gfxpayload=1024x768x16
menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3
}
```

## How to run nwipe so you can specify nwipe command line options
The version of nwipe that runs in the default terminal will automatically restart when you exit it, either at the end of a wipe or using CONTROL-C to abort. So if you want to run nwipe in the traditional way, along with any command line options you require, then use the second terminal ALT-F2, as an example, you could then use the command ```nwipe --nousb --logfile=nwipe.log``` etc. If you do use ALT-F2 to run a second copy of nwipe, please remember that if you already have one copy of nwipe wiping, the second copy of nwipe will hang on starting. Therefore nwipe in the default terminal should be left at the drive selection screen to prevent the second occurence of nwipe from hanging. Alternatively, a second occurrence of nwipe could be started by specifying the drive on the command line as long as that drive is not already being wiped by the first instance of nwipe, i.e.```nwipe /dev/sdc``` etc.

## How to change the default nwipe options so the change persists between reboots
To change the default settings of nwipe you will need to place the nwipe options required on the kernel command line in /boot/grub/grub.cfg and /EFI/BOOT/grub.cfg

Example of default grub.cfg
```
set default="0"
set timeout="0"

menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3
}
```

Adding nwipe_options="..." to grub.cfg to make the default nwipe start up with zero method, no verification, no blanking, ignore USB devices and automatically power off the computer at the end of the wipe.
```
set default="0"
set timeout="0"

menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3 nwipe_options="--method=zero --verify=off --noblank --nousb --autopoweroff"
}
```

You are not only limited to nwipe options, you can also specify devices along with those options. As would be the case when using nwipe from the command line, the devices to be wiped come after the options, as shown in the example below.
```
set default="0"
set timeout="0"

menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3 nwipe_options="--method=zero --verify=off --noblank --nousb --autopoweroff /dev/sdd /dev/sde"
}
```

For reference and as of nwipe v0.32.014, listed below are all the options that you can use with nwipe and can place on the kernel command line in grub.cfg as described in the examples above.
```
Usage: nwipe [options] [device1] [device2] ...
Options:
  -V, --version           Prints the version number

  -v, --verbose           Prints more messages to the log

  -h, --help              Prints this help

      --autonuke          If no devices have been specified on the command line,
                          starts wiping all devices immediately. If devices have
                          been specified, starts wiping only those specified
                          devices immediately.

      --autopoweroff      Power off system on completion of wipe delayed for
                          for one minute. During this one minute delay you can
                          abort the shutdown by typing sudo shutdown -c

      --sync=NUM          Will perform a sync after NUM writes (default: 100000)
                          0    - fdatasync after the disk is completely written
                                 fdatasync errors not detected until completion.
                                 0 is not recommended as disk errors may cause
                                 nwipe to appear to hang
                          1    - fdatasync after every write
                                 Warning: Lower values will reduce wipe speeds.
                          1000 - fdatasync after 1000 writes etc.

      --verify=TYPE       Whether to perform verification of erasure
                          (default: last)
                          off   - Do not verify
                          last  - Verify after the last pass
                          all   - Verify every pass

  -m, --method=METHOD     The wiping method. See man page for more details.
                          (default: dodshort)
                          dod522022m / dod       - 7 pass DOD 5220.22-M method
                          dodshort / dod3pass    - 3 pass DOD method
                          gutmann                - Peter Gutmann's Algorithm
                          ops2                   - RCMP TSSIT OPS-II
                          random / prng / stream - PRNG Stream
                          zero / quick           - Overwrite with zeros
                          one                    - Overwrite with ones (0xFF)
                          verify_zero            - Verifies disk is zero filled
                          verify_one             - Verifies disk is 0xFF filled

  -l, --logfile=FILE      Filename to log to. Default is STDOUT

  -p, --prng=METHOD       PRNG option (mersenne|twister|isaac)

  -q, --quiet             Anonymize logs/GUI by removing serial numbers
                          XXXXXX = S/N exists, ????? = S/N not obtainable 

  -r, --rounds=NUM        Number of times to wipe the device using the selected
                          method (default: 1)

      --noblank           Do NOT blank disk after wipe
                          (default is to complete a final blank pass)

      --nowait            Do NOT wait for a key before exiting
                          (default is to wait)

      --nosignals         Do NOT allow signals to interrupt a wipe
                          (default is to allow)

      --nogui             Do NOT show the GUI interface. Automatically invokes
                          the nowait option. Must be used with the --autonuke
                          option. Send SIGUSR1 to log current stats

      --nousb             Do NOT show or wipe any USB devices whether in GUI
                          mode, --nogui or --autonuke modes.

  -e, --exclude=DEVICES   Up to ten comma separated devices to be excluded
                          --exclude=/dev/sdc
                          --exclude=/dev/sdc,/dev/sdd
                          --exclude=/dev/sdc,/dev/sdd,/dev/mapper/cryptswap1
```
## How to set the keyboard map using the loadkeys command (see [here](#how-to-make-a-persistent-change-to-keyboard-maps) for persistent change between reboots)
You can set the type of keyboard that you are using by typing, `loadkeys uk`, `loadkeys us`, `loadkeys fr`, `loadkeys cf`, `loadkeys by`, `loadkeys cf`, `loadkeys cz` etc. See /usr/share/keymaps/i386/ for full list of keymaps. However you will need to add an entry to `loadkeys=uk` etc to grub.cfg for a persistent change between reboots.

Examples are:
(azerty:) azerty, be-latin1, fr-latin1, fr-latin9, fr-pc, fr, wangbe, wangbe2

(bepo:) fr-bepo-latin9, fr-bepo

(carpalx:) carpalx-full, carpalx

(colemak:) en-latin9

(dvorak:) ANSI-dvorak, dvorak-ca-fr, dvorak-es, dvorak-fr, dvorak-l, dvorak-la, dvorak-programmer, dvorak-r, dvorak-ru, dvorak-sv-a1, dvorak-sv-a5, dvorak-uk, dvorak, no

(fgGIod:) tr_f-latin5, trf

(include:) applkey, backspace, ctrl, euro, euro1, euro2, keypad, unicode, windowkeys

(olpc:) es, pt

(qwerty:) bashkir, bg-cp1251, bg-cp855, bg_bds-cp1251, bg_bds-utf8, bg_pho-cp1251, ... by, cf, cz, dk, es, et, fi, gr, il, it, jp106, kazakh, la-latin1, lt, lv, mk, nl, nl2, no, pc110, pl, ro, ru, sk-qwerty, sr-cy, sv-latin1, ua, uk, us (for the full list see /usr/share/keymaps/i386/qwerty)

## How to make a persistent change to keyboard maps
The default grub.cfg looks like this
```
set default="0"
set timeout="0"

menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3
}
```
Add the following options to the kernel command line, i.e. `loadkeys=uk`, `loadkeys=fr` etc
```
set default="0"
set timeout="0"

menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3 loadkeys=uk
}
```
## Reading and saving nwipes log files - via USB (manually) or ftp (manually & automatically)
The nwipe that is automatically launched in the first virtual terminal ALT-F1, creates a log file that contains the details of the wipe/s and a summary table that shows successfull erasure or failure. The file is time stamped within it's name. A new timestamped log file is created each time nwipe is started. The files can be found in the / directory. A example being nwipe_log_20200418-084910.txt. As of version [v2021.08.2_23_x86-64_0.34](https://github.com/PartialVolume/shredos.x86_64/releases/tag/v2021.08.2_23_x86-64_0.34) ShredOS will automatically copy the nwipe log files to the first FAT32 partition it finds, which is normally the ShredOS USB flash drive. In addition you can manually copy the log files or send them to a ftp server on your local area network. Both methods are described below starting with manually writing to a USB storage device. This is then followed by setting up grub.cfg to auto transfer the nwipe log files to a ftp server.

### Transferring nwipe log files to a USB storage device
1. Locate the device name of your USB stick from it's model & size. 

For Linux: If the | character isn't displayed properly use loadkeys fr etc to select the correct keyboard if not US qwerty prior to running this pipe command.
```
fdisk -l | more
```
For MACS:
```
diskutil list
```
2. Create a directory that we will mount the USB flash drive on
```
mkdir /store
```
3. Mount the USB flash drive, replacing sdx with the device name of your USB flash drive found in step 1
```
mount /dev/sdx1 /store
```
4. Copy the log files to the USB flash drive
```
cp /nwipe_log* /store/
```
5. Unmount the USB flash drive
```
cd /;umount store
```
### Transferring nwipe log files to a ftp server
ShredOS uses the lftp application to transfer files to a remote server. To enable the automatic transfer of nwipe log files, you will need to edit both grub.cfg files (/boot/grub/grub.cfg and /EFI/BOOT/grub.cfg) on the ShredOS USB memory stick. In much the same way you you specify loadkeys or nwipe options which are described above, you edit the linux kernal command line and add the following lftp="open 192.168.1.60; user your-username your-password; cd data; mput nwipe_*.txt", changing the IP, username and password as required. As ftp does not encrypt data you should really only use it to transfer data on your local area network and not over the internet. sftp may be implemented at a future date if users request that feature. You can also manually use lftp on the command line (ALT-F2 or ALT-F3) if you prefer. I use this feature with a chrooted vsftpd ftp server on a Linux PC. The automatic transfer of nwipe log files will be initiated on completion of all wipes and after pressing any key in nwipe to exit. The lftp status will be shown after the nwipe summary table.
		
**IMPORTANT**
- I would recommend you setup a new user account on the system that hosts your ftp server and only use that new user's account, username and password with ShredOS. You don't want to use your own personal user account details as you will be placing those details on the ShredOS USB storage device in a plain text format.
- For security reasons, you should setup your ftp server as chrooted.
		
Example grub.cfg with the lftp option appended:
```
set default="0"
set timeout="0"

menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3 lftp="open 192.168.1.60; user your-username your-password; cd data; mput nwipe_*.txt"
}
```
**vsftpd configuration for a chrooted server**

For those using vsftpd as your ftp server, you will need to change /etc/vsftpd.conf as follows. Some of these entries may already be present but commented out, make a backup of /etc/vsftpd.conf prior to editing and the uncomment or alter as below:
```
anon_mkdir_write_enable=YES
listen=YES
listen_ipv6=YES
local_root=/home/yournewftpuser/ftpdata/
write_enable=YES
anon_mkdir_write_enable=YES
chown_uploads=YES
chown_username=yournewftpuser
nopriv_user=ftpsecure
ftpd_banner=Welcome to the ShredOS log server.
chroot_local_user=YES
chroot_list_enable=NO
secure_chroot_dir=/home/yournewftpuser/ftpdata
```
Disclaimer: The above settings should get you going but may or may not be ideal for your local situation. Refer to the vsftp website and forums if things aren't working as they should. The lftp application that ShredOS uses, should also work with any Microsoft Windows based ftp server, as well as Linux and MAC based systems.

## How to wipe drives on headless systems or systems with faulty display hardware. (For use on secure LANs only)
ShredOS includes a user enabled telnet server. The downloadable .img images are supplied with telnet disabled as default.
		
To enable the telnet server, edit /boot/grub/grub.cfg or/and /EFI/BOOT/grub.cfg and on the USB flash drive, add `telnetd=enable` to the kernel command line.

Example:
```
set default="0"
set timeout="0"

menuentry "shredos" {
	linux /boot/shredos console=tty3 loglevel=3 telnetd=enable
}
```
		
Assuming the headless systems are configured to boot via USB and if UEFI that secure boot is disabled, just plug a USB stick containing ShredOS v2021.08.2_20_0.32.014 or higher into the system. Power cycle the system and then after giving ShredOS sufficient time to boot (4 to 60 seconds depending on the hardware) you can then, from another PC/laptop on the same network, use nmap as shown below to list all IP addresses that have open telnet ports on your local LAN:

```
nmap -p23 192.168.1.0/24 --open
$ nmap -p23 192.168.1.0/24 --open
Starting Nmap 7.80 ( https://nmap.org ) at 2021-11-29 20:54 GMT
Nmap scan report for 192.168.1.30
Host is up (0.071s latency).

PORT   STATE SERVICE
23/tcp open  telnet

Nmap scan report for 192.168.1.100
Host is up (0.050s latency).

PORT   STATE SERVICE
23/tcp open  telnet

Nmap done: 256 IP addresses (19 hosts up) scanned in 14.53 seconds
		
```

Telnet into the appropriate IP address `telnet 192.168.1.100`. ShredOS will respond with:

```
telnet 192.168.1.100
Trying 192.168.1.100...
Connected to 192.168.1.100.
Escape character is '^]'.

shredos login: root
		{ no password }

sh-5.1# nwipe
```
Type `nwipe` as shown above and the nwipe GUI will be displayed and you can proceed with wiping the discs. On some terminals, i.e retro, nwipe doesn't display properly. If you find this then use a different terminal to launch nwipe. Terminals that do work ok are KDE's Konsole, terminator, guake, tmux, xfce terminal and xterm. Terminals that don't seem to work properly via a telnet session with nwipe are cool retro term and qterminal. Putty works but doesn't have the correct box characters but is usable. Putty may work perfectly if you can set the correct character encoding. These are my observations using KDE Neon, they may differ on your systems. If you find a workaround for those terminals that don't display nwipe perfectly over telnet, then please let me know. 
		
> **Warning** 
>Due to the insecure nature of telnet as opposed to ssh, it goes without saying that this method of accessing ShredOS & nwipe should only be carried out on a trusted local area network and never over the internet unless via a VPN or SSH tunnel. ssh access may be provided at a future date if it's requested.

## Nwipes font size is too small How to double the size of the text
If you are using a monitor with a native high resolution you may find that nwipe's font size is too small for your liking, if that's the case, you just need to type the following command in the second virtual terminal `/bin/setfont -d -C /dev/tty1`. To double the font size in other virtual terminals use `/bin/setfont -d -C /dev/tty2` and `/bin/setfont -d -C /dev/console`.

#### Detail
Type ALT F2 (Fn ALT F2 on a MAC) to bring up the 2nd virtual console. Type the following tty command which will return the current console name. So from this result /dev/tty2 we can deduce that the default nwipe in ALT F1 is /dev/tty1. For reference ALT F3 is /dev/console.

```
tty
/dev/tty2
```
To set the font for the default nwipe in the first virtual console ALT F1 (/dev/tty1), type the following command in the 2nd virtual console (ALT F2)
```
/bin/setfont -d -C /dev/tty1
```

> **Warning**
>Always specify the full path to setfont, setfont -d -C /dev/tty1 without the /bin/ prefix, will not work! There are actually two different versions of setfont on Linux and if you ommit the prefix path you will be running the wrong setfont which won't work.


![image](https://user-images.githubusercontent.com/22084881/216849290-8e1c05d2-c856-4466-b76f-eec4ccd2d880.png)
Default font size on a high resolution monitor.
.
![image](https://user-images.githubusercontent.com/22084881/216849326-e9a5c3a0-4485-432a-a3c7-a72858faeab1.png)
After running the setfont command.
		
## ShredOS includes the following related programs

#### smartmontools
Nwipes ability to detect serial numbers on USB devices now works on USB bridges who's chipset supports that functionality.Smartmontools provides nwipe with that capability. Smartmontools can be used in the second or third virtual terminal. ALT-F2 and ALT-F3.

#### hexedit
Use hexedit to examine and modify the contents of a hard disk. Hexedit can be used in the second or third virtual terminal. ALT-F2 and ALT-F3.

#### hdparm
hdparm has many uses and is a powerfull tool. Although Nwipe will be adding ATA secure erase capability, i.e using the hard disk own firmware to initiate an erase, nwipe currently wipes drives using the traditional method of writing to every block. If you want to initiate a ATA secure erase using the drives firmware then hdparm will be of use.


## Compiling ShredOS and burning to USB stick, the harder way !

The ShredOS system is based on the buildroot tool whos main application is to create operating systems for embedded systems.
The image (.img) file is approximately 60 MiB and can be written to a USB memory stick with a tool such as dd or Etcher.

### You can build shredos using the following commands. This example build was compiled on KDE Neon (Ubuntu 20.04).

#### Install the following prerequisite software first. Without this software, the make command will fail
```
$ sudo apt install git
$ sudo apt install build-essential   pkg-config   automake   libncurses5-dev   autotools-dev   libparted-dev   dmidecode   coreutils   smartmontools
$ sudo apt-get install libssl-dev
$ sudo apt-get install libelf-dev
$ sudo apt-get install mtools
```

#### Download the ShredOS source using the git clone command, build ShredOS and write to a USB memory device.
```
$ git clone https://github.com/PartialVolume/shredos.x86_64.git (or shredos.i686.git for 32bit)
$ cd shredos
$ mkdir package/shredos
$ touch package/shredos/Config.in
$ make clean
$ make shredos_defconfig
$ make
$ ls output/images/shredos*.img
$ cd output/images
$ dd if=shredos-20200412.img of=/dev/sdx (20200412 will be the day you compiled, sdx is the USB flash drive)
```
### Issues that you may get when building ShredOS
- **Error: "Internal Size Too Big"** If you are compiling the vanilla version of ShredOS and have made no alterations or additions but it fails to build the .img with the error "Internal error: size too big" then you may have a version of mtools that has a version of mcopy which has a bug whenever the -b option is used. This bug is known to exist in mcopy version 4.0.32 and maybe others but is fixed in v4.0.42. The solution is to upgrade your copy of mtools to a later version. However, if you have altered ShredOS by adding more packages you may need to update the size of the fat32 partition. You can do this by increasing the 'size' in ../board/shredos/genimage.cfg. Depending on how much extra software you have added increase the size by 10MB or more. Currently as of March 2023 the current size is `size = 130000000`, this is in bytes, so adding 10MB will mean you need to edit this value so that it reads `size = 140000000`. After the edit, just run `make` which will result in a quicker build. You don't need to run `make clean` first as that would result in a full rebuild which is not neccessary when all you are doing is increasing the final image size. If your repository does not supply a later version of mtools, then you can obtain mtools packages for various distros from [here](https://www.gnu.org/software/mtools/#downloads)

>INFO: vfat(boot.vfat): cmd: "MTOOLS_SKIP_CHECK=1 mcopy -bsp -i '/home/shredos/Downloads/shredos/mcopybug/shredos.x86_64/output/images/boot.vfat' '/home/shredos/Downloads/shredos/mcopybug/shredos.x86_64/output/images/grub.cfg' '::boot/grub/grub.cfg'" (stderr):
***Internal error, size too big***
Streamcache allocation problem:: 5
INFO: vfat(boot.vfat): cmd: "rm -f "/home/shredos/Downloads/shredos/mcopybug/shredos.x86_64/output/images/boot.vfat"" (stderr):
***ERROR: vfat(boot.vfat): failed to generate boot.vfat***
make[1]: [Makefile:823: target-post-image] Error 1
make: [Makefile:84: _all] Error 2


### Commands to configure buildroot, you will only need to use these if you are making changes to ShredOS

#### Change buildroot configuration, select the architecture, install software packages then save the buildroot config changes to shredos_defconfig, the location if which is defined in the buildroot config within `make menuconfig` ALWAYS RUN `make savedefconfig` AFTER CHANGES are made in menuconfig.
```		
$ make menuconfig
$ make savedefconfig # save the changes
```
#### Edit the linux kernel configuration, install kernel drivers .. then save the configuration.
```
$ make linux-menuconfig
$ make linux-update-defconfig # save the changes
```
#### Edit the busybox selection of software and save the configuration.
```
make busybox-menuconfig
make busybox-update-config # save the changes
```
### Important ShredOS files and folders when building ShredOS from source

#### ../board/shredos/doimg.sh
doimg.sh is a bash script, the main purpose of which is to generate the .img file located in output/images/. However it is also used to copy the pre-compiled .efi file and other files such as the shredos.ico, autorun.inf for Windows, README.txt. The contents of board/shredos/version.txt is also used to rename the .img file with version info and the current date and time.
		
#### ../board/shredos/version.txt
This file contains the version information as seen in the title on nwipe's title bar, i.e. '2021.08.2_22_x86-64_0.32.023'. This version ingformation is also used when naming the .img file in ../output/images/ /board/shredos/version.txt is manually updated for each new release of ShredOS.
		
#### ../board/shredos/fsoverlay/
This fsoverlay directory contains files and folders that are directly copied into the root filesystem of ShredOS. A example of this is the  ../board/shredos/fsoverlay/etc/inittab file where the tty1 and tty2 virtual terminals are configured. This is where you will find the script `/usr/bin/nwipe_launcher` that automatically starts in tty1 after ShredOS has booted. If you want to place or overwrite a specific file in the root filesystem of ShredOS, the ../board/shredos/fsoverlay/ directory is one way of inserting your own files.
		
#### ../board/shredos/fsoverlay/etc/init.d/S40network
S40network is responsible for starting the network & obtaining a IP address via DHCP by starting a ShredOS script called `/usr/bin/shredos_net.sh` The shredos_net.sh script can also be found in the fsoverlay directory `../board/shredos/fsoverlay/usr/bin/shredos_net.sh` which then ends up in the directory /usr/bin/ of the ShredOS filesystem.
		
#### ../board/shredos/fsoverlay/usr/bin/nwipe_launcher
nwipe_launcher starts the nwipe program in tty1, see ../board/shredos/fsoverlay/etc/inittab which is where nwipe_launcher is called from. The nwipe_launcher script, apart from starting nwipe in tty1 also is responsible for calling the lftp program to automatically transfer log files to a remote ftp server on your local area network, assuming lftp has been enabled on the kernel command line. It also contains the 4,3,2,1 countdown and nwipe restart code.
		
#### ../package/nwipe/
All programs in ShredOS appear under their individual sub-directory under the package directory, therefore, you will find all the information relating to the build of nwipe under ../package/nwipe. The four files contained here are involved in downloading the nwipe source from https://github.com/PartialVolume/nwipe, checking the integrity of the source by comparison of the hash, patching the nwipe version.c and compiling the code. Each file in ../package/nwipe/ is descibed below.
		
#### ../package/nwipe/nwipe.mk
This is the buildroot make file for nwipe. This is where the nwipe source download is initiated & hash checked. It also patches the nwipe code, in the case of ShredOS the only patching to the vanilla nwipe code is to change the nwipe title bar from nwipe [version] to ShredOS [shredos version] i.e ShredOS 2021.08.2_22_x86-64_0.32.023. This file also includes nwipe dependencies and nwipe version number. Therefore is file should have the nwipe version number updated if a new version of nwipe is incorporated into ShredOS.
		
#### ../package/nwipe/nwipe.hash
This file contains the sha1 hash for the nwipe tar file, i.e. nwipe-v0.32.023.tar.gz. The hash and filename contained in this file is manually updated with each new release of nwipe.
		
#### ../package/nwipe/Config.in
This is a buildroot file that exists in each package. The only time it would be manually edited is if nwipe's dependendencies changed.
		
#### ../package/nwipe/002-nwipe-banner-patch.sh
This script contains the changes that are made to nwipe's version.c

#### END OF README.md
