Run the emulation with:

 qemu-system-mipsel -M malta -kernel output/images/vmlinux -serial stdio -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/hda" -net nic,model=pcnet -net user # qemu_mips32r2el_malta_defconfig

The login prompt will appear in the terminal that started Qemu. The
graphical window is the framebuffer. No keyboard support has been
enabled.
