################################################################################
#
# qemu
#
################################################################################

QEMU_VERSION = 6.0.0
QEMU_SOURCE = qemu-$(QEMU_VERSION).tar.xz
QEMU_SITE = http://download.qemu.org
QEMU_LICENSE = GPL-2.0, LGPL-2.1, MIT, BSD-3-Clause, BSD-2-Clause, Others/BSD-1c
QEMU_LICENSE_FILES = COPYING COPYING.LIB
# NOTE: there is no top-level license file for non-(L)GPL licenses;
#       the non-(L)GPL license texts are specified in the affected
#       individual source files.
QEMU_CPE_ID_VENDOR = qemu

#-------------------------------------------------------------

# The build system is now partly based on Meson.
# However, building is still done with configure and make as in previous versions of QEMU.

# Target-qemu
QEMU_DEPENDENCIES = host-meson host-pkgconf libglib2 zlib pixman host-python3

# Need the LIBS variable because librt and libm are
# not automatically pulled. :-(
QEMU_LIBS = -lrt -lm

QEMU_OPTS =

QEMU_VARS = LIBTOOL=$(HOST_DIR)/bin/libtool

# If we want to specify only a subset of targets, we must still enable all
# of them, so that QEMU properly builds its list of default targets, from
# which it then checks if the specified sub-set is valid. That's what we
# do in the first part of the if-clause.
# Otherwise, if we do not want to pass a sub-set of targets, we then need
# to either enable or disable -user and/or -system emulation appropriately.
# That's what we do in the else-clause.
ifneq ($(call qstrip,$(BR2_PACKAGE_QEMU_CUSTOM_TARGETS)),)
QEMU_OPTS += --enable-system --enable-linux-user
QEMU_OPTS += --target-list="$(call qstrip,$(BR2_PACKAGE_QEMU_CUSTOM_TARGETS))"
else

ifeq ($(BR2_PACKAGE_QEMU_SYSTEM),y)
QEMU_OPTS += --enable-system
else
QEMU_OPTS += --disable-system
endif

ifeq ($(BR2_PACKAGE_QEMU_LINUX_USER),y)
QEMU_OPTS += --enable-linux-user
else
QEMU_OPTS += --disable-linux-user
endif

endif

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
QEMU_OPTS += --disable-vhost-user
else
QEMU_OPTS += --enable-vhost-user
endif

ifeq ($(BR2_PACKAGE_QEMU_SLIRP),y)
QEMU_OPTS += --enable-slirp=system
QEMU_DEPENDENCIES += slirp
else
QEMU_OPTS += --disable-slirp
endif

ifeq ($(BR2_PACKAGE_QEMU_SDL),y)
QEMU_OPTS += --enable-sdl
QEMU_DEPENDENCIES += sdl2
QEMU_VARS += SDL2_CONFIG=$(BR2_STAGING_DIR)/usr/bin/sdl2-config
else
QEMU_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_QEMU_FDT),y)
QEMU_OPTS += --enable-fdt
QEMU_DEPENDENCIES += dtc
else
QEMU_OPTS += --disable-fdt
endif

ifeq ($(BR2_PACKAGE_QEMU_TOOLS),y)
QEMU_OPTS += --enable-tools
else
QEMU_OPTS += --disable-tools
endif

ifeq ($(BR2_PACKAGE_LIBFUSE3),y)
QEMU_OPTS += --enable-fuse --enable-fuse-lseek
QEMU_DEPENDENCIES += libfuse3
else
QEMU_OPTS += --disable-fuse --disable-fuse-lseek
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
QEMU_OPTS += --enable-seccomp
QEMU_DEPENDENCIES += libseccomp
else
QEMU_OPTS += --disable-seccomp
endif

ifeq ($(BR2_PACKAGE_LIBSSH),y)
QEMU_OPTS += --enable-libssh
QEMU_DEPENDENCIES += libssh
else
QEMU_OPTS += --disable-libssh
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
QEMU_OPTS += --enable-libusb
QEMU_DEPENDENCIES += libusb
else
QEMU_OPTS += --disable-libusb
endif

ifeq ($(BR2_PACKAGE_LIBVNCSERVER),y)
QEMU_OPTS += \
	--enable-vnc \
	--disable-vnc-sasl
QEMU_DEPENDENCIES += libvncserver
ifeq ($(BR2_PACKAGE_LIBPNG),y)
QEMU_OPTS += --enable-vnc-png
QEMU_DEPENDENCIES += libpng
else
QEMU_OPTS += --disable-vnc-png
endif
ifeq ($(BR2_PACKAGE_JPEG),y)
QEMU_OPTS += --enable-vnc-jpeg
QEMU_DEPENDENCIES += jpeg
else
QEMU_OPTS += --disable-vnc-jpeg
endif
else
QEMU_OPTS += --disable-vnc
endif

ifeq ($(BR2_PACKAGE_NETTLE),y)
QEMU_OPTS += --enable-nettle
QEMU_DEPENDENCIES += nettle
else
QEMU_OPTS += --disable-nettle
endif

ifeq ($(BR2_PACKAGE_NUMACTL),y)
QEMU_OPTS += --enable-numa
QEMU_DEPENDENCIES += numactl
else
QEMU_OPTS += --disable-numa
endif

ifeq ($(BR2_PACKAGE_SPICE),y)
QEMU_OPTS += --enable-spice
QEMU_DEPENDENCIES += spice
else
QEMU_OPTS += --disable-spice
endif

ifeq ($(BR2_PACKAGE_USBREDIR),y)
QEMU_OPTS += --enable-usb-redir
QEMU_DEPENDENCIES += usbredir
else
QEMU_OPTS += --disable-usb-redir
endif

# Override CPP, as it expects to be able to call it like it'd
# call the compiler.
define QEMU_CONFIGURE_CMDS
	unset TARGET_DIR; \
	cd $(@D); \
		LIBS='$(QEMU_LIBS)' \
		$(TARGET_CONFIGURE_OPTS) \
		$(TARGET_CONFIGURE_ARGS) \
		CPP="$(TARGET_CC) -E" \
		$(QEMU_VARS) \
		./configure \
			--prefix=/usr \
			--cross-prefix=$(TARGET_CROSS) \
			--audio-drv-list= \
			--meson=$(HOST_DIR)/bin/meson \
			--ninja=$(HOST_DIR)/bin/ninja \
			--enable-kvm \
			--enable-attr \
			--enable-vhost-net \
			--disable-bsd-user \
			--disable-containers \
			--disable-xen \
			--disable-virtfs \
			--disable-brlapi \
			--disable-curses \
			--disable-curl \
			--disable-vde \
			--disable-linux-aio \
			--disable-linux-io-uring \
			--disable-cap-ng \
			--disable-docs \
			--disable-rbd \
			--disable-libiscsi \
			--disable-strip \
			--disable-sparse \
			--disable-mpath \
			--disable-sanitizers \
			--disable-hvf \
			--disable-whpx \
			--disable-malloc-trim \
			--disable-membarrier \
			--disable-vhost-crypto \
			--disable-libxml2 \
			--disable-capstone \
			--with-git-submodules=ignore \
			--disable-opengl \
			--disable-vhost-user-blk-server \
			--disable-virtiofsd \
			--disable-tests \
			$(QEMU_OPTS)
endef

define QEMU_BUILD_CMDS
	unset TARGET_DIR; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEMU_INSTALL_TARGET_CMDS
	unset TARGET_DIR; \
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(QEMU_MAKE_ENV) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))

#-------------------------------------------------------------
# Host-qemu

HOST_QEMU_DEPENDENCIES = host-meson host-pkgconf host-zlib host-libglib2 host-pixman host-python3

#       BR ARCH         qemu
#       -------         ----
#       arm             arm
#       armeb           armeb
#       i486            i386
#       i586            i386
#       i686            i386
#       x86_64          x86_64
#       m68k            m68k
#       microblaze      microblaze
#       mips            mips
#       mipsel          mipsel
#       mips64          mips64
#       mips64el        mips64el
#       nios2           nios2
#       or1k            or1k
#       powerpc         ppc
#       powerpc64       ppc64
#       powerpc64le     ppc64 (system) / ppc64le (usermode)
#       sh2a            not supported
#       sh4             sh4
#       sh4eb           sh4eb
#       sh4a            sh4
#       sh4aeb          sh4eb
#       sparc           sparc
#       sparc64         sparc64
#       xtensa          xtensa

HOST_QEMU_ARCH = $(ARCH)
ifeq ($(HOST_QEMU_ARCH),i486)
HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),i586)
HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),i686)
HOST_QEMU_ARCH = i386
endif
ifeq ($(HOST_QEMU_ARCH),powerpc)
HOST_QEMU_ARCH = ppc
endif
ifeq ($(HOST_QEMU_ARCH),powerpc64)
HOST_QEMU_ARCH = ppc64
endif
ifeq ($(HOST_QEMU_ARCH),powerpc64le)
HOST_QEMU_ARCH = ppc64le
HOST_QEMU_SYS_ARCH = ppc64
endif
ifeq ($(HOST_QEMU_ARCH),sh4a)
HOST_QEMU_ARCH = sh4
endif
ifeq ($(HOST_QEMU_ARCH),sh4aeb)
HOST_QEMU_ARCH = sh4eb
endif
HOST_QEMU_SYS_ARCH ?= $(HOST_QEMU_ARCH)

HOST_QEMU_CFLAGS = $(HOST_CFLAGS)

ifeq ($(BR2_PACKAGE_HOST_QEMU_SYSTEM_MODE),y)
HOST_QEMU_TARGETS += $(HOST_QEMU_SYS_ARCH)-softmmu
HOST_QEMU_OPTS += --enable-system --enable-fdt
HOST_QEMU_CFLAGS += -I$(HOST_DIR)/include/libfdt
HOST_QEMU_DEPENDENCIES += host-dtc
else
HOST_QEMU_OPTS += --disable-system
endif

ifeq ($(BR2_PACKAGE_HOST_QEMU_LINUX_USER_MODE),y)
HOST_QEMU_TARGETS += $(HOST_QEMU_ARCH)-linux-user
HOST_QEMU_OPTS += --enable-linux-user

HOST_QEMU_HOST_SYSTEM_TYPE = $(shell uname -s)
ifneq ($(HOST_QEMU_HOST_SYSTEM_TYPE),Linux)
$(error "qemu-user can only be used on Linux hosts")
endif

else # BR2_PACKAGE_HOST_QEMU_LINUX_USER_MODE
HOST_QEMU_OPTS += --disable-linux-user
endif # BR2_PACKAGE_HOST_QEMU_LINUX_USER_MODE

ifeq ($(BR2_PACKAGE_HOST_QEMU_VDE2),y)
HOST_QEMU_OPTS += --enable-vde
HOST_QEMU_DEPENDENCIES += host-vde2
endif

# virtfs-proxy-helper is the only user of libcap-ng.
ifeq ($(BR2_PACKAGE_HOST_QEMU_VIRTFS),y)
HOST_QEMU_OPTS += --enable-virtfs --enable-cap-ng
HOST_QEMU_DEPENDENCIES += host-libcap-ng
else
HOST_QEMU_OPTS += --disable-virtfs --disable-cap-ng
endif

ifeq ($(BR2_PACKAGE_HOST_QEMU_USB),y)
HOST_QEMU_OPTS += --enable-libusb
HOST_QEMU_DEPENDENCIES += host-libusb
else
HOST_QEMU_OPTS += --disable-libusb
endif

# Override CPP, as it expects to be able to call it like it'd
# call the compiler.
define HOST_QEMU_CONFIGURE_CMDS
	unset TARGET_DIR; \
	cd $(@D); $(HOST_CONFIGURE_OPTS) CPP="$(HOSTCC) -E" \
		./configure \
		--target-list="$(HOST_QEMU_TARGETS)" \
		--prefix="$(HOST_DIR)" \
		--interp-prefix=$(STAGING_DIR) \
		--cc="$(HOSTCC)" \
		--host-cc="$(HOSTCC)" \
		--extra-cflags="$(HOST_QEMU_CFLAGS)" \
		--extra-ldflags="$(HOST_LDFLAGS)" \
		--meson=$(HOST_DIR)/bin/meson \
		--ninja=$(HOST_DIR)/bin/ninja \
		--disable-bzip2 \
		--disable-containers \
		--disable-curl \
		--disable-docs \
		--disable-libssh \
		--disable-linux-io-uring \
		--disable-sdl \
		--disable-vhost-user-blk-server \
		--disable-virtiofsd \
		--disable-vnc-jpeg \
		--disable-vnc-png \
		--disable-vnc-sasl \
		--disable-tests \
		$(HOST_QEMU_OPTS)
endef

define HOST_QEMU_BUILD_CMDS
	unset TARGET_DIR; \
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D)
endef

define HOST_QEMU_INSTALL_CMDS
	unset TARGET_DIR; \
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) install
endef

$(eval $(host-generic-package))

# variable used by other packages
QEMU_USER = $(HOST_DIR)/bin/qemu-$(HOST_QEMU_ARCH)
