################################################################################
#
# procps-NG
#
################################################################################

PROCPS-NG_VERSION = 3.3.17
PROCPS-NG_SOURCE = procps-NG-$(PROCPS-NG_VERSION).tar.xz
PROCPS-NG_SITE = http://downloads.sourceforge.net/project/procps-NG/Production
PROCPS-NG_LICENSE = GPL-2.0+, LGPL-2.0+ (libproc and libps)
PROCPS-NG_LICENSE_FILES = COPYING COPYING.LIB
PROCPS-NG_CPE_ID_VALID = YES
PROCPS-NG_INSTALL_STAGING = YES
# We're patching configure.ac
PROCPS-NG_AUTORECONF = YES
PROCPS-NG_DEPENDENCIES = ncurses host-pkgconf $(TARGET_NLS_DEPENDENCIES)
PROCPS-NG_CONF_OPTS = LIBS=$(TARGET_NLS_LIBS)

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
PROCPS-NG_DEPENDENCIES += systemd
PROCPS-NG_CONF_OPTS += --with-systemd
else
PROCPS-NG_CONF_OPTS += --without-systemd
endif

# Make sure binaries get installed in /bin, as busybox does, so that we
# don't end up with two versions.
# Make sure libprocps.pc is installed in STAGING_DIR/usr/lib/pkgconfig/
# otherwise it's installed in STAGING_DIR/lib/pkgconfig/ breaking
# pkg-config --libs libprocps.
PROCPS-NG_CONF_OPTS += --exec-prefix=/ \
	--libdir=/usr/lib

# Allows unicode characters to show in 'watch'
ifeq ($(BR2_PACKAGE_NCURSES_WCHAR),y)
PROCPS-NG_CONF_OPTS += \
	--enable-watch8bit
endif

ifeq ($(BR2_USE_WCHAR),)
PROCPS-NG_CONF_OPTS += CPPFLAGS=-DOFF_XTRAWIDE
endif

# numa support requires libdl, so explicitly disable it when
# BR2_STATIC_LIBS=y
ifeq ($(BR2_STATIC_LIBS),y)
PROCPS-NG_CONF_OPTS += --disable-numa
endif

# w requires utmp.h
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
PROCPS-NG_CONF_OPTS += --disable-w
else
PROCPS-NG_CONF_OPTS += --enable-w
endif

# Avoid installing S02sysctl, since openrc provides /etc/init.d/sysctl.
define PROCPS-NG_INSTALL_INIT_OPENRC
	@:
endef

define PROCPS-NG_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/procps-NG/S02sysctl \
		$(TARGET_DIR)/etc/init.d/S02sysctl
endef

$(eval $(autotools-package))
