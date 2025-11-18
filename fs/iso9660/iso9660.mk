################################################################################
#
# Build the ISO9660 root filesystem image
#
################################################################################

#
# We need to handle three cases:
#
#  1. The ISO9660 filesystem will really be the real root filesystem
#     itself. This is when BR2_TARGET_ROOTFS_ISO9660_INITRD is
#     disabled.
#
#  2. The ISO9660 filesystem will be a filesystem with just a kernel
#     image, initrd and grub. This is when
#     BR2_TARGET_ROOTFS_ISO9660_INITRD is enabled, but
#     BR2_TARGET_ROOTFS_INITRAMFS is disabled.
#
#  3. The ISO9660 filesystem will be a filesystem with just a kernel
#     image and grub. This is like (2), except that the initrd is
#     built into the kernel image. This is when
#     BR2_TARGET_ROOTFS_INITRAMFS is enabled (regardless of the value
#     of BR2_TARGET_ROOTFS_ISO9660_INITRD).
#

################################################################################
# Configuration Variables
################################################################################

ROOTFS_ISO9660_DEPENDENCIES = host-xorriso linux

ROOTFS_ISO9660_GRUB2_BOOT_MENU = $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_GRUB2_BOOT_MENU))
ROOTFS_ISO9660_GRUB2_EFI_BOOT_MENU = $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_GRUB2_EFI_BOOT_MENU))
ROOTFS_ISO9660_GRUB2_EFI_PARTITION_SIZE = $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_GRUB2_EFI_PARTITION_SIZE))
ROOTFS_ISO9660_GRUB2_EFI_IDENT_FILE = $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_GRUB2_EFI_IDENT_FILE))
ROOTFS_ISO9660_ISOLINUX_BOOT_MENU = $(call qstrip,$(BR2_TARGET_ROOTFS_ISO9660_ISOLINUX_BOOT_MENU))

################################################################################
# Architecture-specific variables
################################################################################

ifeq ($(BR2_ARCH_IS_64),y)
ROOTFS_ISO9660_EFI_NAME = bootx64.efi
ROOTFS_ISO9660_EFI_NOTNAME = bootia32.efi
ROOTFS_ISO9660_GRUB2_EFI_PREFIX = $(call qstrip,$(GRUB2_PREFIX_x86_64-efi))
else
ROOTFS_ISO9660_EFI_NAME = bootia32.efi
ROOTFS_ISO9660_EFI_NOTNAME = bootx64.efi
ROOTFS_ISO9660_GRUB2_EFI_PREFIX = $(call qstrip,$(GRUB2_PREFIX_i386-efi))
endif

################################################################################
# Determine if we're using initrd
################################################################################

ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
ROOTFS_ISO9660_USE_INITRD = YES
endif

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_INITRD),y)
ROOTFS_ISO9660_USE_INITRD = YES
endif

################################################################################
# Setup temporary target directory
################################################################################

ifeq ($(ROOTFS_ISO9660_USE_INITRD),YES)
# Using initrd: create minimal temporary directory
ROOTFS_ISO9660_TMP_TARGET_DIR = $(FS_DIR)/rootfs.iso9660.tmp
define ROOTFS_ISO9660_CREATE_TEMPDIR
	$(RM) -rf $(ROOTFS_ISO9660_TMP_TARGET_DIR)
	mkdir -p $(ROOTFS_ISO9660_TMP_TARGET_DIR)
endef
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_CREATE_TEMPDIR

else ifeq ($(BR2_TARGET_ROOTFS_ISO9660_TRANSPARENT_COMPRESSION),y)
# Using transparent compression: create compressed tree
ROOTFS_ISO9660_DEPENDENCIES += host-zisofs-tools
ROOTFS_ISO9660_TMP_TARGET_DIR = $(FS_DIR)/rootfs.iso9660.tmp
define ROOTFS_ISO9660_MKZFTREE
	$(RM) -rf $(ROOTFS_ISO9660_TMP_TARGET_DIR)
	$(HOST_DIR)/bin/mkzftree -X -z 9 -p $(PARALLEL_JOBS) \
		$(TARGET_DIR) \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)
endef
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_MKZFTREE
ROOTFS_ISO9660_OPTS += -z

else
# Standard mode: use TARGET_DIR directly
ROOTFS_ISO9660_TMP_TARGET_DIR = $(TARGET_DIR)
endif

################################################################################
# Reproducible build support
################################################################################

ifeq ($(BR2_REPRODUCIBLE),y)
ROOTFS_ISO9660_VFAT_OPTS = --invariant
ROOTFS_ISO9660_FIX_TIME = touch -d @$(SOURCE_DATE_EPOCH)
else
ROOTFS_ISO9660_FIX_TIME = :
endif

################################################################################
# GRUB2 BIOS Bootloader Configuration
################################################################################

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_GRUB2)$(BR2_TARGET_ROOTFS_ISO9660_BIOS_BOOTLOADER),yy)
ROOTFS_ISO9660_DEPENDENCIES += grub2
ROOTFS_ISO9660_GRUB2_CONFIG_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/boot/grub/grub.cfg
ROOTFS_ISO9660_BOOT_IMAGE = boot/grub/grub-eltorito.img

define ROOTFS_ISO9660_INSTALL_GRUB2_BIOS
	$(INSTALL) -D -m 0644 $(BINARIES_DIR)/grub-eltorito.img \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/boot/grub/grub-eltorito.img
endef

define ROOTFS_ISO9660_INSTALL_GRUB2_CONFIG
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_GRUB2_BOOT_MENU) \
		$(ROOTFS_ISO9660_GRUB2_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_GRUB2_CONFIG_PATH)
endef
endif

################################################################################
# GRUB2 EFI Bootloader Configuration
################################################################################

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_GRUB2)$(BR2_TARGET_ROOTFS_ISO9660_EFI_BOOTLOADER),yy)
ROOTFS_ISO9660_DEPENDENCIES += grub2 host-dosfstools host-mtools
ROOTFS_ISO9660_EFI_PARTITION = boot/efi.img
ROOTFS_ISO9660_EFI_PARTITION_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_EFI_PARTITION)
ROOTFS_ISO9660_EFI_PARTITION_CONTENT = $(BINARIES_DIR)/efi-part
ROOTFS_ISO9660_GRUB2_CONFIG_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/boot/grub/grub.cfg
ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/grub.cfg

define ROOTFS_ISO9660_INSTALL_GRUB2_EFI
	# Create file to better find ISO9660 filesystem
	$(INSTALL) -D -m 0644 /dev/null \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_GRUB2_EFI_IDENT_FILE)
	# Copy EFI bootloader also to ISO9660 filesystem
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_EFI_PARTITION_CONTENT)/$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/$(ROOTFS_ISO9660_EFI_NAME) \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/$(ROOTFS_ISO9660_EFI_NAME)
	# Create EFI FAT partition
	rm -rf $(ROOTFS_ISO9660_EFI_PARTITION_PATH)
	mkdir -p $(dir $(ROOTFS_ISO9660_EFI_PARTITION_PATH))
	dd if=/dev/zero of=$(ROOTFS_ISO9660_EFI_PARTITION_PATH) bs=$(ROOTFS_ISO9660_GRUB2_EFI_PARTITION_SIZE) count=1
	$(HOST_DIR)/sbin/mkfs.vfat $(ROOTFS_ISO9660_VFAT_OPTS) $(ROOTFS_ISO9660_EFI_PARTITION_PATH)
	# Copy bootloader and modules to EFI partition
	$(ROOTFS_ISO9660_FIX_TIME) $(ROOTFS_ISO9660_EFI_PARTITION_CONTENT)/*
	$(HOST_DIR)/bin/mcopy -p -m -i $(ROOTFS_ISO9660_EFI_PARTITION_PATH) -s \
		$(ROOTFS_ISO9660_EFI_PARTITION_CONTENT)/* ::/
	# Delete the EFI bootloader that is NOT for the platform we're building for
	$(HOST_DIR)/bin/mdel -i $(ROOTFS_ISO9660_EFI_PARTITION_PATH) \
		::$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/$(ROOTFS_ISO9660_EFI_NOTNAME) || true
	# Copy EFI configuration to EFI partition
	$(HOST_DIR)/bin/mcopy -n -o -p -m -i $(ROOTFS_ISO9660_EFI_PARTITION_PATH) \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH) ::$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/grub.cfg
	$(ROOTFS_ISO9660_FIX_TIME) $(ROOTFS_ISO9660_EFI_PARTITION_PATH)
endef

define ROOTFS_ISO9660_INSTALL_GRUB2_CONFIG
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_GRUB2_BOOT_MENU) \
		$(ROOTFS_ISO9660_GRUB2_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_GRUB2_CONFIG_PATH)
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_GRUB2_EFI_BOOT_MENU) \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH)
	$(SED) "s%__EFI_ID_FILE__%$(ROOTFS_ISO9660_GRUB2_EFI_IDENT_FILE)%" \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH)
endef
endif

################################################################################
# ISOLINUX Bootloader Configuration (BIOS only)
################################################################################

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_ISOLINUX),y)
ROOTFS_ISO9660_DEPENDENCIES += syslinux
ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/isolinux.cfg
ROOTFS_ISO9660_BOOT_IMAGE = isolinux/isolinux.bin

define ROOTFS_ISO9660_INSTALL_ISOLINUX_BIOS
	$(INSTALL) -D -m 0644 $(BINARIES_DIR)/syslinux/* \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/ldlinux.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/ldlinux.c32
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/menu.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/menu.c32
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/libutil.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/libutil.c32
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/libcom32.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/libcom32.c32
endef

define ROOTFS_ISO9660_INSTALL_ISOLINUX_CONFIG
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_ISOLINUX_BOOT_MENU) \
		$(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH)
endef
endif

################################################################################
# BOTH Mode: ISOLINUX (BIOS) + GRUB2 (EFI)
################################################################################

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_BOTH),y)
ROOTFS_ISO9660_DEPENDENCIES += syslinux grub2 host-dosfstools host-mtools

# ISOLINUX configuration
ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/isolinux.cfg
ROOTFS_ISO9660_BOOT_IMAGE = isolinux/isolinux.bin

# GRUB2 EFI configuration
ROOTFS_ISO9660_GRUB2_CONFIG_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/boot/grub/grub.cfg
ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/grub.cfg
ROOTFS_ISO9660_EFI_PARTITION = boot/efi.img
ROOTFS_ISO9660_EFI_PARTITION_PATH = $(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_EFI_PARTITION)
ROOTFS_ISO9660_EFI_PARTITION_CONTENT = $(BINARIES_DIR)/efi-part

define ROOTFS_ISO9660_INSTALL_ISOLINUX_BIOS
	$(INSTALL) -D -m 0644 $(BINARIES_DIR)/syslinux/* \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/ldlinux.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/ldlinux.c32
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/menu.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/menu.c32
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/libutil.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/libutil.c32
	$(INSTALL) -D -m 0644 $(HOST_DIR)/share/syslinux/libcom32.c32 \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/isolinux/libcom32.c32
endef

define ROOTFS_ISO9660_INSTALL_ISOLINUX_CONFIG
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_ISOLINUX_BOOT_MENU) \
		$(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH)
endef

define ROOTFS_ISO9660_INSTALL_GRUB2_EFI
	# Create file to better find ISO9660 filesystem
	$(INSTALL) -D -m 0644 /dev/null \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_GRUB2_EFI_IDENT_FILE)
	# Copy EFI bootloader also to ISO9660 filesystem
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_EFI_PARTITION_CONTENT)/$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/$(ROOTFS_ISO9660_EFI_NAME) \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/$(ROOTFS_ISO9660_EFI_NAME)
	# Create EFI FAT partition
	rm -rf $(ROOTFS_ISO9660_EFI_PARTITION_PATH)
	mkdir -p $(dir $(ROOTFS_ISO9660_EFI_PARTITION_PATH))
	dd if=/dev/zero of=$(ROOTFS_ISO9660_EFI_PARTITION_PATH) bs=$(ROOTFS_ISO9660_GRUB2_EFI_PARTITION_SIZE) count=1
	$(HOST_DIR)/sbin/mkfs.vfat $(ROOTFS_ISO9660_VFAT_OPTS) $(ROOTFS_ISO9660_EFI_PARTITION_PATH)
	# Copy bootloader and modules to EFI partition
	$(ROOTFS_ISO9660_FIX_TIME) $(ROOTFS_ISO9660_EFI_PARTITION_CONTENT)/*
	$(HOST_DIR)/bin/mcopy -p -m -i $(ROOTFS_ISO9660_EFI_PARTITION_PATH) -s \
		$(ROOTFS_ISO9660_EFI_PARTITION_CONTENT)/* ::/
	# Delete the EFI bootloader that is NOT for the platform we're building for
	$(HOST_DIR)/bin/mdel -i $(ROOTFS_ISO9660_EFI_PARTITION_PATH) \
		::$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/$(ROOTFS_ISO9660_EFI_NOTNAME) || true
	# Copy EFI configuration to EFI partition
	$(HOST_DIR)/bin/mcopy -n -o -p -m -i $(ROOTFS_ISO9660_EFI_PARTITION_PATH) \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH) ::$(ROOTFS_ISO9660_GRUB2_EFI_PREFIX)/grub.cfg
	$(ROOTFS_ISO9660_FIX_TIME) $(ROOTFS_ISO9660_EFI_PARTITION_PATH)
endef

define ROOTFS_ISO9660_INSTALL_GRUB2_CONFIG
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_GRUB2_BOOT_MENU) \
		$(ROOTFS_ISO9660_GRUB2_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_GRUB2_CONFIG_PATH)
	$(INSTALL) -D -m 0644 $(ROOTFS_ISO9660_GRUB2_EFI_BOOT_MENU) \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH)
	$(SED) "s%__KERNEL_PATH__%/boot/$(LINUX_IMAGE_NAME)%" \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH)
	$(SED) "s%__EFI_ID_FILE__%$(ROOTFS_ISO9660_GRUB2_EFI_IDENT_FILE)%" \
		$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH)
endef
endif

################################################################################
# Bootloader Configuration Installation
################################################################################

define ROOTFS_ISO9660_INSTALL_BOOTLOADER_CONFIGS
	$(ROOTFS_ISO9660_INSTALL_GRUB2_CONFIG)
	$(ROOTFS_ISO9660_INSTALL_ISOLINUX_CONFIG)
endef

ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_INSTALL_BOOTLOADER_CONFIGS

################################################################################
# Initrd Handling
################################################################################

define ROOTFS_ISO9660_COPY_KERNEL
	$(INSTALL) -D -m 0644 $(LINUX_IMAGE_PATH) \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/boot/$(LINUX_IMAGE_NAME)
endef

define ROOTFS_ISO9660_ENABLE_EXTERNAL_INITRD
	$(INSTALL) -D -m 0644 $(BINARIES_DIR)/rootfs.cpio$(ROOTFS_CPIO_COMPRESS_EXT) \
		$(ROOTFS_ISO9660_TMP_TARGET_DIR)/boot/initrd
	$(if $(ROOTFS_ISO9660_GRUB2_CONFIG_PATH), \
		$(SED) "s%__INITRD_PATH__%/boot/initrd%" \
			$(ROOTFS_ISO9660_GRUB2_CONFIG_PATH))
	$(if $(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH), \
		$(SED) "s%__INITRD_PATH__%/boot/initrd%" \
			$(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH))
	$(if $(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH), \
		$(SED) "s%__INITRD_PATH__%/boot/initrd%" \
			$(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH))
endef

define ROOTFS_ISO9660_DISABLE_EXTERNAL_INITRD
	$(if $(ROOTFS_ISO9660_GRUB2_CONFIG_PATH), \
		$(SED) '/__INITRD_PATH__/d' $(ROOTFS_ISO9660_GRUB2_CONFIG_PATH))
	$(if $(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH), \
		$(SED) '/__INITRD_PATH__/d' $(ROOTFS_ISO9660_GRUB2_EFI_CONFIG_PATH))
	$(if $(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH), \
		$(SED) '/append[[:space:]]*initrd=__INITRD_PATH__[[:space:]]*$$/d' $(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH) && \
		$(SED) 's/initrd=__INITRD_PATH__[[:space:]]*//' $(ROOTFS_ISO9660_ISOLINUX_CONFIG_PATH))
endef

ifeq ($(ROOTFS_ISO9660_USE_INITRD),YES)
# Copy kernel when using initrd
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_COPY_KERNEL

ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
# Initramfs is built into kernel - disable external initrd
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_DISABLE_EXTERNAL_INITRD
else
# External initrd - copy it and update configs
ROOTFS_ISO9660_DEPENDENCIES += rootfs-cpio
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_ENABLE_EXTERNAL_INITRD
endif

else # Not using initrd
ifeq ($(BR2_TARGET_ROOTFS_ISO9660_TRANSPARENT_COMPRESSION),y)
# Transparent compression requires uncompressed kernel
ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_COPY_KERNEL
endif

ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_DISABLE_EXTERNAL_INITRD
endif

################################################################################
# Bootloader Installation
# This must happen last after all config files are prepared
################################################################################

define ROOTFS_ISO9660_INSTALL_BOOTLOADERS
	$(ROOTFS_ISO9660_INSTALL_GRUB2_BIOS)
	$(ROOTFS_ISO9660_INSTALL_ISOLINUX_BIOS)
	$(ROOTFS_ISO9660_INSTALL_GRUB2_EFI)
endef

ROOTFS_ISO9660_PRE_GEN_HOOKS += ROOTFS_ISO9660_INSTALL_BOOTLOADERS

################################################################################
# ISO9660 Generation Options
#
# Note: Argument order is crucial here, this command line was inspired by
# modern Debian distributions (see .disk/mkisofs inside one of their ISOs)
################################################################################

ROOTFS_ISO9660_OPTS += -r -V 'ISO9660' -J -joliet-long -cache-inodes

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_BOTH)$(BR2_TARGET_ROOTFS_ISO9660_HYBRID),yy)
# Hybrid Image Support (Modern Variant, Debian-style)
ROOTFS_ISO9660_OPTS_BIOS = \
	-isohybrid-mbr $(HOST_DIR)/share/syslinux/isohdpfx.bin \
	-b $(ROOTFS_ISO9660_BOOT_IMAGE) \
	-c isolinux/boot.cat \
	-boot-load-size 4 \
	-boot-info-table \
	-no-emul-boot
else ifeq ($(BR2_TARGET_ROOTFS_ISO9660_ISOLINUX),y)
ROOTFS_ISO9660_OPTS_BIOS = \
	-b $(ROOTFS_ISO9660_BOOT_IMAGE) \
	-c isolinux/boot.cat \
	-boot-load-size 4 \
	-boot-info-table \
	-no-emul-boot
else
ROOTFS_ISO9660_OPTS_BIOS = \
	-b $(ROOTFS_ISO9660_BOOT_IMAGE) \
	-boot-load-size 4 \
	-boot-info-table \
	-no-emul-boot
endif

ifeq ($(BR2_TARGET_ROOTFS_ISO9660_BOTH)$(BR2_TARGET_ROOTFS_ISO9660_HYBRID),yy)
# Hybrid Image Support (Modern Variant, Debian-style)
ROOTFS_ISO9660_OPTS_EFI = \
	-e $(ROOTFS_ISO9660_EFI_PARTITION) \
	-no-emul-boot \
	-isohybrid-gpt-basdat \
	-isohybrid-apm-hfsplus
else
ROOTFS_ISO9660_OPTS_EFI = \
	-e $(ROOTFS_ISO9660_EFI_PARTITION) \
	-no-emul-boot
endif

# Determine which boot options to use
ifeq ($(BR2_TARGET_ROOTFS_ISO9660_BIOS_BOOTLOADER)$(BR2_TARGET_ROOTFS_ISO9660_EFI_BOOTLOADER),yy)
# Both BIOS and EFI
ROOTFS_ISO9660_OPTS += \
	$(ROOTFS_ISO9660_OPTS_BIOS) \
	-eltorito-alt-boot \
	$(ROOTFS_ISO9660_OPTS_EFI)

else ifeq ($(BR2_TARGET_ROOTFS_ISO9660_BIOS_BOOTLOADER),y)
# BIOS only
ROOTFS_ISO9660_OPTS += $(ROOTFS_ISO9660_OPTS_BIOS)

else ifeq ($(BR2_TARGET_ROOTFS_ISO9660_EFI_BOOTLOADER),y)
# EFI only
ROOTFS_ISO9660_OPTS += $(ROOTFS_ISO9660_OPTS_EFI)

endif

################################################################################
# Hybrid Image Support (Legacy Variant, No UEFI)
################################################################################

ifneq ($(BR2_TARGET_ROOTFS_ISO9660_BOTH),y)
ifeq ($(BR2_TARGET_ROOTFS_ISO9660_HYBRID),y)
define ROOTFS_ISO9660_GEN_HYBRID
	$(HOST_DIR)/bin/isohybrid -t 0x96 $@
endef
ROOTFS_ISO9660_POST_GEN_HOOKS += ROOTFS_ISO9660_GEN_HYBRID
endif
endif

################################################################################
# ISO9660 Image Generation
################################################################################

define ROOTFS_ISO9660_CMD
	$(HOST_DIR)/bin/xorriso -as mkisofs \
		$(ROOTFS_ISO9660_OPTS) \
		-o $@ $(ROOTFS_ISO9660_TMP_TARGET_DIR)
endef

################################################################################
# Register filesystem
################################################################################

$(eval $(rootfs))
