################################################################################
#
# libvorbis
#
################################################################################

LIBVORBIS_VERSION = 1.3.7
LIBVORBIS_SOURCE = libvorbis-$(LIBVORBIS_VERSION).tar.xz
LIBVORBIS_SITE = https://downloads.xiph.org/releases/vorbis
LIBVORBIS_INSTALL_STAGING = YES
LIBVORBIS_CONF_OPTS = --disable-oggtest
LIBVORBIS_DEPENDENCIES = host-pkgconf libogg
LIBVORBIS_LICENSE = BSD-3-Clause
LIBVORBIS_LICENSE_FILES = COPYING
LIBVORBIS_CPE_ID_VENDOR = xiph.org

$(eval $(autotools-package))
