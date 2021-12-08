################################################################################
#
# lynx
#
################################################################################

LYNX_VERSION = 2.8.9rel.1
LYNX_SOURCE = lynx$(LYNX_VERSION).tar.bz2
LYNX_SITE = ftp://ftp.invisible-island.net/lynx/tarballs
LYNX_PATCH = \
	https://salsa.debian.org/lynx-team/lynx/-/raw/debian/2.9.0dev.6-3_deb11u1/debian/patches/90_CVE-2021-38165.patch
# 90_CVE-2021-38165.patch
LYNX_IGNORE_CVES += CVE-2021-38165
LYNX_LICENSE = GPL-2.0
LYNX_LICENSE_FILES = COPYING

LYNX_DEPENDENCIES = host-pkgconf $(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_REPRODUCIBLE),y)
# configuration info leaks build paths
LYNX_CONF_OPTS += --disable-config-info
# disable build timestamp
LYNX_CFLAGS += -DNO_BUILDSTAMP
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
LYNX_DEPENDENCIES += ncurses
LYNX_CONF_OPTS += --with-screen=ncurses$(if $(BR2_PACKAGE_NCURSES_WCHAR),w)
else ifeq ($(BR2_PACKAGE_SLANG),y)
LYNX_DEPENDENCIES += slang
LYNX_CONF_OPTS += --with-screen=slang
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LYNX_DEPENDENCIES += openssl
LYNX_CONF_OPTS += --with-ssl=$(STAGING_DIR)/usr
LYNX_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs openssl`
else ifeq ($(BR2_PACKAGE_GNUTLS),y)
LYNX_DEPENDENCIES += gnutls
LYNX_CONF_OPTS += --with-gnutls
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
LYNX_DEPENDENCIES += zlib
LYNX_CONF_OPTS += --with-zlib
else
LYNX_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
LYNX_DEPENDENCIES += libidn
LYNX_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs libidn`
endif

LYNX_CONF_ENV = LIBS="$(LYNX_LIBS)" CFLAGS="$(TARGET_CFLAGS) $(LYNX_CFLAGS)"

$(eval $(autotools-package))
