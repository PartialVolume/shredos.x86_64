Run the emulation with:

qemu-system-ppc64 -M pseries -cpu POWER8 -m 256 -kernel output/images/vmlinux -append "console=hvc0 rootwait root=/dev/sda" -drive file=output/images/rootfs.ext2,if=scsi,index=0,format=raw -serial stdio -display curses # qemu_ppc64le_pseries_defconfig

The login prompt will appear in the terminal window.
