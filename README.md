# ShredOS x86_64 for all Intel 64bit processors and 64 bit compatible processors 
for the 32 bit version of ShredOS that will run on both 32bit and 64bit processors, see [ShredOS i686](https://github.com/PartialVolume/shredos.i686)

| ShredOS Version | Nwipe Version | Number of Downloads |
| ---------| ---------|---------|
| Latest x86_64 64 bit version | v0.30.001 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.2020.02/latest/total.svg "Latest x86_64 64 bit version")](https://github.com/PartialVolume/shredos.2020.02/releases/latest) |
| Latest i686 32 bit version | v0.30.001 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.i686/latest/total.svg "Latest i686 32 bit version")](https://github.com/PartialVolume/shredos.i686/releases/latest) |
| v2020.02.005_x86-64_0.30.001 (64 bit) | v0.30.001 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.2020.02/v2020.02.005_x86-64_0.30.001/total.svg "v2020.02.005_x86-64_0.30.001")](https://github.com/PartialVolume/shredos.2020.02/releases/v2020.02.005_x86-64_0.30.001) |
| v2020.02.005_i686-0.30.001 (32 bit) | v0.30.001 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.i686/v2020.02.005_i686-0.30.001/total.svg "v2020.02.005_i686-0.30.001")](https://github.com/PartialVolume/shredos.i686/releases/v2020.02.005_i686-0.30.001) |
| v2020.02.004-0.29.006 (64 bit) | v0.29.006 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.2020.02/v2020.02.004-0.29.006/total.svg "v2020.02.004-0.29.006")](https://github.com/PartialVolume/shredos.2020.02/releases/v2020.02.004-0.29.006) |
| v2020.02.0.29rc.003 (64 bit) | v0.29.003 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.2020.02/v2020.02.0.29rc.003/total.svg "v2020.02.0.29rc.003")](https://github.com/PartialVolume/shredos.2020.02/releases/v2020.02.0.29rc.003) |
| v2020.02.0.29rc.002 (64 bit) | v0.29.002 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.2020.02/v2020.02.0.29rc.002/total.svg "v2020.02.0.29rc.002")](https://github.com/PartialVolume/shredos.2020.02/releases/v2020.02.0.29rc.002) |
| v2020.02.0.29rc.001 (64 bit) | v0.29.001 | [![](https://img.shields.io/github/downloads/PartialVolume/shredos.2020.02/v2020.02.0.29rc.001/total.svg "v2020.02.0.29rc.001")](https://github.com/PartialVolume/shredos.2020.02/releases/v2020.02.0.29rc.001) |

1. [What is ShredOS?](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#what-is-shredos)
1. [Nwipe's erasure methods](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#nwipes-erasure-methods)
1. [Obtaining and writing ShredOS to a USB flash drive - The easy way!](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#obtaining-and-writing-shredos-to-a-usb-flash-drive-the-easy-way-)
   1. [Linux and MAC users](https://github.com/PartialVolume/shredos.2020.02#linux-and-mac-users)
   1. [Windows users](https://github.com/PartialVolume/shredos.2020.02#windows-users)
1. [Virtual terminals](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#virtual-terminals)
1. [How to run nwipe so you can specify nwipe command line options](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#how-to-run-nwipe-so-you-can-specify-nwipe-command-line-options)
1. [How to change the default nwipe options so the change persists between reboots](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#how-to-change-the-default-nwipe-options-so-the-change-persists-between-reboots)
1. [How to set the keyboard map using the loadkeys command (see here for persistent change between reboots](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#how-to-set-the-keyboard-map-using-the-loadkeys-command-see-here-for-persistent-change-between-reboots)
1. [How to make a persistent change to keyboard maps](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#how-to-make-a-persistent-change-to-keyboard-maps)
1. [Reading and saving nwipes log files](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#reading-and-saving-nwipes-log-files)
1. [The latest ShredOS now includes the following](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#the-latest-shredos-now-includes-the-following)
1. [Compiling shredos and burning to USB stick, the harder way!](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#compiling-shredos-and-burning-to-usb-stick-the-harder-way-)
1. [Shredos is based on buildroot](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#shredos-is-based-on-buildroot)

## What is ShredOS?
ShredOS is a USB bootable (BIOS or UEFI) small linux distribution with the sole purpose of securely erasing the entire contents of your
disks using the program [nwipe](https://github.com/martijnvanbrummelen/nwipe).

ShredOS supports either 32bit or 64bit processors. You will need to download the appropriate .img.tar.gz file, depending upon your target processor.

Shredos includes the latest Nwipe master, Smartmontools, a hexeditor [hexedit](https://linux.die.net/man/1/hexedit). Nwipe automatically starts it's GUI in the first virtual terminal (ALT-F1), hdparm, smartmontools and hexeditor can be run in the second virtual terminal, (ALT-F2). Nwipe will erase drives using a user selectable choice of seven methods. hdparm, amongst many of its options can be used for wiping a drive by using the drives internal firmware. The program loadkeys can be used for setting the keyboard type. i.e. loadkeys uk, loadkeys fr etc.

ShredOS boots very quickly and depending upon the host system can boot in as little as 2 seconds (typically 4 to 6 seconds) on modern hardware, while on an old Pentium4 may take 40+ seconds. Nwipe automatically starts in GUI mode and will list the disks present on the host system. Be aware that it can launch so fast that the USB devices have not yet initialised. If you Control-C nwipe will re-start and you should now see any attached USB devices. You can then select the methods by which you want to securely erase the disk/s. Nwipe is able to simultanuosly wipe multiple disks using a threaded software architecture., personally I've tested simultaneously wiping 28 loop devices in tests.

## Nwipe's erasure methods
For an upto date list of supported wipe methods see the [nwipe](https://github.com/martijnvanbrummelen/nwipe) page.
* Quick erase        - Fills the device with zeros, one round only.
* RCMP TSSIT OPS-II  - Royal Candian Mounted Police Technical Security Standard, OPS-II
* DoD Short          - The American Department of Defense 5220.22-M short 3 pass wipe. 1,2,& 7.
* DoD 5220.22M       - The American Department of Defense 5220.22-M full 7 pass wipe. 1-7
* Gutmann Wipe       - Peter Gutmann's method. (Secure Deletion of Data from Magnetic and Solid-State Memory)
* PRNG Stream        - Fills the device with a stream from the PRNG.
* Verify only        - This method only reads the device and checks that it is all zero.
* HMG IS5 enhanced   - Secure Sanitisation of Protectively Marked Information or Sensitive Information

Nwipe also includes the following pseudo random number generators:
* mersenne
* twister
* isaac

## Obtaining and writing shredos to a USB flash drive, the easy way !

You can of course compile shredos from source but that can take a long time and you can run into all sorts of problems if your not familiar with compiling an operating system. So if you just want to get started with using shredos and nwipe then just download the shredos image file and write it to a USB flash drive. Please note this will over write the existing contents of your USB flash drive.

Download shredos for 64 bit processors from [here](https://github.com/PartialVolume/shredos.2020.02/releases/download/v2020.02.005_x86-64_0.30.001/shredos-20210106.img)

Download shredos for 32 bit processors (also runs on 64 bit processors) from [here](https://github.com/PartialVolume/shredos.i686/releases/download/v2020.02.005_i686-0.30.001/shredos-20210106.img)

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
If you are using linux or a MAC write the shredos.img file (also sometimes called shredos-2020MMDD.img i.e. shredos-20200418.img etc) to your USB flash drive using the following command.  (/dev/sdx is the device name of your USB drive, this can be obtained from the results of sudo fdisk -l)
```
dd if=shredos.img of=/dev/sdx

```
#### Windows users:
If you are a windows user, use a program such as [Rufus](https://rufus.ie/) or [etcher](https://www.balena.io/etcher/) to write the image file to a USB stick, remembering that the entire contents of the USB flash drive will be overwritten. [Winzip](https://www.winzip.com/win/en/) be used to extract the shredos.img file from the compressed shredos.img.tar.gz file that you downloaded. [hashtab](http://implbits.com/products/hashtab/) can be downloaded and used to confirm the sha1 checksum.


## Virtual Terminals
ShredOS has three tty terminals, ALT-F1 (Where nwipe is initially launched), ALT-F2 (A virtual terminal), ALT-F3 (console log, login required which is root with no password).


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
## How to set the keyboard map using the loadkeys command (see [here](https://github.com/PartialVolume/shredos.2020.02/blob/master/README.md#how-to-make-a-persistent-change-to-keyboard-maps) for persistent change between reboots)
- You can set the type of keyboard you are using by typing `loadkeys uk`, `loadkeys us`, `loadkeys fr`, `loadkeys cf`, `loadkeys by`, `loadkeys cf`, `loadkeys cz` etc. See /usr/share/keymaps/i386/ for full list of keymaps. However you will need to add an entry to `loadkeys=uk` etc to grub.cfg for a persistent change between reboots.

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

- hdparm is also available for those that want to do a firmware supported wipe. A firmware wipe is a planned enhancement to nwipe.

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
## Reading and saving nwipes log files
The nwipe that is automatically launched in the first virtual terminal ALT-F1, creates a log file that contains the details of the wipe/s and a summary table that shows successfull erasure or failure. The file is time stamped within it's name. A new timestamped log file is created each time nwipe is started. The files can be found in the / directory. A example being nwipe_log_20200418-084910.txt. As currently, shredos does not have persistent storage, if you want to keep these files between reboots of shredos, you will need to manually copy them to the USB stick as follows:

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

## The latest ShredOS now includes the following:
- smartmontools package, Nwipes ability to detect serial numbers on USB devices now works on USB bridges who's chipset supports that functionality. This also now works in ShredOS 20200405.

## Compiling shredos and burning to USB stick, the harder way !

The ShredOS system is built using buildroot.
The final system size is about 12MB but due to minimim fat32 partition size, the ending image is about
37MB and can be burnt onto a USB memory stick with a tool such as dd or Etcher.

You can build the image by doing:
```
$ git clone https://github.com/PartialVolume/shredos.2020.02.git
$ cd shredos
$ make shredos_defconfig
$ make
$ ls output/images/shredos*.img
$ cd output/images
$ dd if=shredos-20200412.img of=/dev/sdx (20200412 will be the day you compiled, sdx is the USB flash drive)
```

## shredos is based on buildroot

Buildroot is a simple, efficient and easy-to-use tool to generate embedded
Linux systems through cross-compilation.

The documentation can be found in docs/manual. You can generate a text
document with 'make manual-text' and read output/docs/manual/manual.text.
Online documentation can be found at http://buildroot.org/docs.html

To build and use the buildroot stuff, do the following:

1) run 'make menuconfig'
2) select the target architecture and the packages you wish to compile
3) run 'make'
4) wait while it compiles
5) find the kernel, bootloader, root filesystem, etc. in output/images

You do not need to be root to build or run buildroot.  Have fun!

Buildroot comes with a basic configuration for a number of boards. Run
'make list-defconfigs' to view the list of provided configurations.

Please feed suggestions, bug reports, insults, and bribes back to the
buildroot mailing list: buildroot@buildroot.org
You can also find us on #buildroot on Freenode IRC.

If you would like to contribute patches, please read
https://buildroot.org/manual.html#submitting-patches
