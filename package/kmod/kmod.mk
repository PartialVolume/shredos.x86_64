################################################################################
#
# kmod
#
################################################################################

KMOD_VERSION = 28
KMOD_SOURCE = kmod-$(KMOD_VERSION).tar.xz
KMOD_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/kernel/kmod
KMOD_INSTALL_STAGING = YES
KMOD_DEPENDENCIES = host-pkgconf
HOST_KMOD_DEPENDENCIES = host-pkgconf

# license info for libkmod only, conditionally add more below
KMOD_LICENSE = LGPL-2.1+ (library)
KMOD_LICENSE_FILES = libkmod/COPYING

KMOD_CPE_ID_VENDOR = kernel

# --gc-sections triggers binutils ld segfault
# https://sourceware.org/bugzilla/show_bug.cgi?id=21180
ifeq ($(BR2_microblaze),y)
KMOD_CONF_ENV += cc_cv_LDFLAGS__Wl___gc_sections=false
endif

# static linking not supported, see
# https://git.kernel.org/cgit/utils/kernel/kmod/kmod.git/commit/?id=b7016153ec8
KMOD_CONF_OPTS = --disable-static --enable-shared

KMOD_CONF_OPTS += --disable-manpages
HOST_KMOD_CONF_OPTS = --disable-manpages

ifeq ($(BR2_PACKAGE_BASH_COMPLETION),y)
KMOD_CONF_OPTS += --with-bashcompletiondir=/usr/share/bash-completion/completions
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
KMOD_DEPENDENCIES += zlib
KMOD_CONF_OPTS += --with-zlib
else
KMOD_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_ZSTD),y)
KMOD_DEPENDENCIES += zstd
KMOD_CONF_OPTS += --with-zstd
else
KMOD_CONF_OPTS += --without-zstd
endif

ifeq ($(BR2_PACKAGE_XZ),y)
KMOD_DEPENDENCIES += xz
KMOD_CONF_OPTS += --with-xz
else
KMOD_CONF_OPTS += --without-xz
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
KMOD_DEPENDENCIES += openssl
KMOD_CONF_OPTS += --with-openssl
else
KMOD_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
KMOD_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON),python,python3)
KMOD_CONF_OPTS += --enable-python
endif

ifeq ($(BR2_PACKAGE_KMOD_TOOLS),y)

# add license info for kmod tools
KMOD_LICENSE += , GPL-2.0+ (tools)
KMOD_LICENSE_FILES += COPYING

# /sbin is really /usr/sbin with merged /usr, so adjust relative symlink
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
KMOD_BIN_PATH = ../bin/kmod
else
KMOD_BIN_PATH = ../usr/bin/kmod
endif

define KMOD_INSTALL_TOOLS
	for i in depmod insmod lsmod modinfo modprobe rmmod; do \
		ln -sf $(KMOD_BIN_PATH) $(TARGET_DIR)/sbin/$$i; \
	done
endef

KMOD_POST_INSTALL_TARGET_HOOKS += KMOD_INSTALL_TOOLS
else
KMOD_CONF_OPTS += --disable-tools
endif

ifeq ($(BR2_PACKAGE_HOST_KMOD_GZ),y)
HOST_KMOD_DEPENDENCIES += host-zlib
HOST_KMOD_CONF_OPTS += --with-zlib
else
HOST_KMOD_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_HOST_KMOD_ZSTD),y)
HOST_KMOD_DEPENDENCIES += host-zstd
HOST_KMOD_CONF_OPTS += --with-zstd
else
HOST_KMOD_CONF_OPTS += --without-zstd
endif

ifeq ($(BR2_PACKAGE_HOST_KMOD_XZ),y)
HOST_KMOD_DEPENDENCIES += host-xz
HOST_KMOD_CONF_OPTS += --with-xz
else
HOST_KMOD_CONF_OPTS += --without-xz
endif

# We only install depmod, since that's the only tool used for the
# host.
define HOST_KMOD_INSTALL_TOOLS
	mkdir -p $(HOST_DIR)/sbin/
	ln -sf ../bin/kmod $(HOST_DIR)/sbin/depmod
endef

HOST_KMOD_POST_INSTALL_HOOKS += HOST_KMOD_INSTALL_TOOLS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
