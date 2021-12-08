################################################################################
#
# libcdio
#
################################################################################

LIBCDIO_VERSION = 2.1.0
LIBCDIO_SOURCE = libcdio-$(LIBCDIO_VERSION).tar.bz2
LIBCDIO_SITE = $(BR2_GNU_MIRROR)/libcdio
LIBCDIO_INSTALL_STAGING = YES
LIBCDIO_LICENSE = GPL-3.0+
LIBCDIO_LICENSE_FILES = COPYING
LIBCDIO_CPE_ID_VENDOR = gnu
LIBCDIO_CONF_OPTS = --disable-example-progs --disable-cddb

ifeq ($(BR2_ENABLE_LOCALE),)
LIBCDIO_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_INSTALL_LIBSTDCPP),)
LIBCDIO_CONF_OPTS += --disable-cxx
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
LIBCDIO_DEPENDENCIES += ncurses
else
LIBCDIO_CONF_OPTS += --without-cdda-player
endif

$(eval $(autotools-package))
