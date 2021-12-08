################################################################################
#
# util-linux
#
################################################################################

# When making changes to this file, please check if
# util-linux-libs/util-linux-libs.mk needs to be updated accordingly as well.

UTIL_LINUX_VERSION_MAJOR = 2.36
UTIL_LINUX_VERSION = $(UTIL_LINUX_VERSION_MAJOR).2
UTIL_LINUX_SOURCE = util-linux-$(UTIL_LINUX_VERSION).tar.xz
UTIL_LINUX_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/util-linux/v$(UTIL_LINUX_VERSION_MAJOR)

# README.licensing claims that some files are GPL-2.0 only, but this is not
# true. Some files are GPL-3.0+ but only in tests and optionally in hwclock
# (but we disable that option). rfkill uses an ISC-style license.
UTIL_LINUX_LICENSE = GPL-2.0+, BSD-4-Clause, LGPL-2.1+ (libblkid, libfdisk, libmount), BSD-3-Clause (libuuid), ISC (rfkill)
UTIL_LINUX_LICENSE_FILES = README.licensing \
	Documentation/licenses/COPYING.BSD-3-Clause \
	Documentation/licenses/COPYING.BSD-4-Clause-UC \
	Documentation/licenses/COPYING.GPL-2.0-or-later \
	Documentation/licenses/COPYING.ISC \
	Documentation/licenses/COPYING.LGPL-2.1-or-later

UTIL_LINUX_CPE_ID_VENDOR = kernel
UTIL_LINUX_INSTALL_STAGING = YES
UTIL_LINUX_DEPENDENCIES = \
	host-pkgconf \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBS),util-linux-libs) \
	$(TARGET_NLS_DEPENDENCIES)
UTIL_LINUX_CONF_OPTS += \
	--disable-rpath \
	--disable-makeinstall-chown

UTIL_LINUX_LINK_LIBS = $(TARGET_NLS_LIBS)

HOST_UTIL_LINUX_DEPENDENCIES = host-pkgconf

# We also don't want the host-python dependency
HOST_UTIL_LINUX_CONF_OPTS = \
	--without-systemd \
	--with-systemdsystemunitdir=no \
	--without-python

ifneq ($(BR2_PACKAGE_UTIL_LINUX_BINARIES)$(BR2_PACKAGE_UTIL_LINUX_CRAMFS)$(BR2_PACKAGE_UTIL_LINUX_FSCK)$(BR2_PACKAGE_UTIL_LINUX_LOSETUP),)
UTIL_LINUX_SELINUX_MODULES = fstools
endif

# Prevent the installation from attempting to move shared libraries from
# ${usrlib_execdir} (/usr/lib) to ${libdir} (/lib), since both paths are
# the same when merged usr is in use.
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
UTIL_LINUX_CONF_OPTS += --bindir=/usr/bin --sbindir=/usr/sbin --libdir=/usr/lib
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
UTIL_LINUX_CONF_OPTS += --with-systemd --with-systemdsystemunitdir=/usr/lib/systemd/system
UTIL_LINUX_DEPENDENCIES += systemd
else
UTIL_LINUX_CONF_OPTS += --without-systemd --with-systemdsystemunitdir=no
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
UTIL_LINUX_CONF_OPTS += --with-udev
UTIL_LINUX_DEPENDENCIES += udev
else
UTIL_LINUX_CONF_OPTS += --without-udev
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
UTIL_LINUX_DEPENDENCIES += ncurses
ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
UTIL_LINUX_CONF_OPTS += --with-ncursesw
UTIL_LINUX_CONF_ENV += NCURSESW6_CONFIG=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)
else
UTIL_LINUX_CONF_OPTS += --without-ncursesw --with-ncurses --disable-widechar
UTIL_LINUX_CONF_ENV += NCURSES6_CONFIG=$(STAGING_DIR)/usr/bin/$(NCURSES_CONFIG_SCRIPTS)
endif
else
ifeq ($(BR2_USE_WCHAR),y)
UTIL_LINUX_CONF_OPTS += --enable-widechar
else
UTIL_LINUX_CONF_OPTS += --disable-widechar
endif
UTIL_LINUX_CONF_OPTS += --without-ncursesw --without-ncurses
endif

# Unfortunately, the util-linux does LIBS="" at the end of its
# configure script. So we have to pass the proper LIBS value when
# calling the configure script to make configure tests pass properly,
# and then pass it again at build time.
UTIL_LINUX_CONF_ENV += LIBS="$(UTIL_LINUX_LINK_LIBS)"
UTIL_LINUX_MAKE_OPTS += LIBS="$(UTIL_LINUX_LINK_LIBS)"

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
UTIL_LINUX_DEPENDENCIES += libselinux
UTIL_LINUX_CONF_OPTS += --with-selinux
else
UTIL_LINUX_CONF_OPTS += --without-selinux
define UTIL_LINUX_SELINUX_PAMFILES_TWEAK
	$(foreach f,su su-l,
		$(SED) '/^.*pam_selinux.so.*$$/d' \
			$(TARGET_DIR)/etc/pam.d/$(f)
	)
endef
endif

# Used by setpriv
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBCAP_NG),libcap-ng)

# Used by cramfs utils
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_ZLIB),zlib)

# Used by login-utils
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_LINUX_PAM),linux-pam)

# Used by hardlink
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_PCRE2),pcre2)

# Disable/Enable utilities
UTIL_LINUX_CONF_OPTS += \
	$(if $(BR2_PACKAGE_UTIL_LINUX_BINARIES),--enable-all-programs,--disable-all-programs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_AGETTY),--enable-agetty,--disable-agetty) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_BFS),--enable-bfs,--disable-bfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CAL),--enable-cal,--disable-cal) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHFN_CHSH),--enable-chfn-chsh,--disable-chfn-chsh) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CHMEM),--enable-chmem,--disable-chmem) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_CRAMFS),--enable-cramfs,--disable-cramfs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_EJECT),--enable-eject,--disable-eject) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FALLOCATE),--enable-fallocate,--disable-fallocate) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FDFORMAT),--enable-fdformat,--disable-fdformat) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_FSCK),--enable-fsck,--disable-fsck) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_HARDLINK),--enable-hardlink,--disable-hardlink) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_HWCLOCK),--enable-hwclock --disable-hwclock-gplv3,--disable-hwclock) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_IPCRM),--enable-ipcrm,--disable-ipcrm) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_IPCS),--enable-ipcs,--disable-ipcs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_KILL),--enable-kill,--disable-kill) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LAST),--enable-last,--disable-last) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),--enable-libblkid,--disable-libblkid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBFDISK),--enable-libfdisk,--disable-libfdisk) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),--enable-libmount,--disable-libmount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBSMARTCOLS),--enable-libsmartcols,--disable-libsmartcols) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBUUID),--enable-libuuid,--disable-libuuid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LINE),--enable-line,--disable-line) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LOGGER),--enable-logger,--disable-logger) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LOGIN),--enable-login,--disable-login) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LOSETUP),--enable-losetup,--disable-losetup) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LSLOGINS),--enable-lslogins,--disable-lslogins) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LSMEM),--enable-lsmem,--disable-lsmem) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MESG),--enable-mesg,--disable-mesg) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MINIX),--enable-minix,--disable-minix) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MORE),--enable-more,--disable-more) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MOUNT),--enable-mount,--disable-mount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_MOUNTPOINT),--enable-mountpoint,--disable-mountpoint) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_NEWGRP),--enable-newgrp,--disable-newgrp) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_NOLOGIN),--enable-nologin,--disable-nologin) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_NSENTER),--enable-nsenter,--disable-nsenter) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PARTX),--enable-partx,--disable-partx) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PG),--enable-pg,--disable-pg) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_PIVOT_ROOT),--enable-pivot_root,--disable-pivot_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RAW),--enable-raw,--disable-raw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RENAME),--enable-rename,--disable-rename) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RFKILL),--enable-rfkill,--disable-rfkill) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_RUNUSER),--enable-runuser,--disable-runuser) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SCHEDUTILS),--enable-schedutils,--disable-schedutils) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SETPRIV),--enable-setpriv,--disable-setpriv) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SETTERM),--enable-setterm,--disable-setterm) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SU),--enable-su,--disable-su) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SULOGIN),--enable-sulogin,--disable-sulogin) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_SWITCH_ROOT),--enable-switch_root,--disable-switch_root) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_TUNELP),--enable-tunelp,--disable-tunelp) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UL),--enable-ul,--disable-ul) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UNSHARE),--enable-unshare,--disable-unshare) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UTMPDUMP),--enable-utmpdump,--disable-utmpdump) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_UUIDD),--enable-uuidd,--disable-uuidd) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_VIPW),--enable-vipw,--disable-vipw) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WALL),--enable-wall,--disable-wall) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WDCTL),--enable-wdctl,--disable-wdctl) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WIPEFS),--enable-wipefs,--disable-wipefs) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_WRITE),--enable-write,--disable-write) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_ZRAMCTL),--enable-zramctl,--disable-zramctl)

# In the host version of util-linux, we only require libuuid and
# libmount (plus libblkid as an indirect dependency of libmount).
# So disable all of the programs, unless BR2_PACKAGE_HOST_UTIL_LINUX is set

HOST_UTIL_LINUX_CONF_OPTS += \
	--enable-libblkid \
	--enable-libmount \
	--enable-libuuid \
	--without-libmagic \
	--without-ncurses \
	--without-ncursesw \
	--without-tinfo

ifeq ($(BR2_PACKAGE_HOST_UTIL_LINUX),y)
HOST_UTIL_LINUX_CONF_OPTS += --disable-makeinstall-chown
# disable commands that have ncurses dependency, as well as
# other ones that are useless on the host
HOST_UTIL_LINUX_CONF_OPTS += \
	--disable-agetty \
	--disable-chfn-chsh \
	--disable-chmem \
	--disable-login \
	--disable-lslogins \
	--disable-mesg \
	--disable-more \
	--disable-newgrp \
	--disable-nologin \
	--disable-nsenter \
	--disable-pg \
	--disable-rfkill \
	--disable-runuser \
	--disable-schedutils \
	--disable-setpriv \
	--disable-setterm \
	--disable-su \
	--disable-sulogin \
	--disable-tunelp \
	--disable-ul \
	--disable-unshare \
	--disable-uuidd \
	--disable-vipw \
	--disable-wall \
	--disable-wdctl \
	--disable-write \
	--disable-zramctl
# Used by cramfs utils
HOST_UTIL_LINUX_DEPENDENCIES += host-zlib
else
HOST_UTIL_LINUX_CONF_OPTS += --disable-all-programs
endif

# Install libmount Python bindings
ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
UTIL_LINUX_CONF_OPTS += --with-python
UTIL_LINUX_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON),python,python3)
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),y)
UTIL_LINUX_CONF_OPTS += --enable-pylibmount
else
UTIL_LINUX_CONF_OPTS += --disable-pylibmount
endif
else
UTIL_LINUX_CONF_OPTS += --without-python
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
UTIL_LINUX_CONF_OPTS += --with-readline
UTIL_LINUX_LINK_LIBS += $(if $(BR2_STATIC_LIBS),-lcurses)
UTIL_LINUX_DEPENDENCIES += readline
else
UTIL_LINUX_CONF_OPTS += --without-readline
endif

ifeq ($(BR2_PACKAGE_AUDIT),y)
UTIL_LINUX_CONF_OPTS += --with-audit
UTIL_LINUX_DEPENDENCIES += audit
else
UTIL_LINUX_CONF_OPTS += --without-audit
endif

ifeq ($(BR2_PACKAGE_FILE),y)
UTIL_LINUX_CONF_OPTS += --with-libmagic
UTIL_LINUX_DEPENDENCIES += file
else
UTIL_LINUX_CONF_OPTS += --without-libmagic
endif

# Install PAM configuration files
ifeq ($(BR2_PACKAGE_UTIL_LINUX_SU)$(BR2_PACKAGE_LINUX_PAM),yy)
define UTIL_LINUX_INSTALL_PAMFILES
	$(INSTALL) -D -m 0644 package/util-linux/su.pam \
		$(TARGET_DIR)/etc/pam.d/su
	$(INSTALL) -D -m 0644 package/util-linux/su.pam \
		$(TARGET_DIR)/etc/pam.d/su-l
	$(UTIL_LINUX_SELINUX_PAMFILES_TWEAK)
endef
UTIL_LINUX_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_INSTALL_PAMFILES
endif

# Install agetty->getty symlink to avoid breakage when there's no busybox
ifeq ($(BR2_PACKAGE_UTIL_LINUX_AGETTY),y)
ifeq ($(BR2_PACKAGE_BUSYBOX),)
define UTIL_LINUX_GETTY_SYMLINK
	ln -sf agetty $(TARGET_DIR)/sbin/getty
endef
endif
endif

UTIL_LINUX_POST_INSTALL_TARGET_HOOKS += UTIL_LINUX_GETTY_SYMLINK

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# Must be included after the autotools-package call, to make sure all variables
# are available
include package/util-linux/util-linux-libs/util-linux-libs.mk
