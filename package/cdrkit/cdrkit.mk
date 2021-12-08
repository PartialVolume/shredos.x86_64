################################################################################
#
# cdrkit
#
################################################################################

CDRKIT_VERSION = 1.1.11
CDRKIT_SOURCE = cdrkit_$(CDRKIT_VERSION).orig.tar.gz
CDRKIT_SITE = http://snapshot.debian.org/archive/debian/20141023T043132Z/pool/main/c/cdrkit
CDRKIT_DEPENDENCIES = libcap bzip2 zlib
HOST_CDRKIT_DEPENDENCIES = host-libcap host-bzip2 host-zlib
CDRKIT_LICENSE = GPL-2.0
CDRKIT_LICENSE_FILES = COPYING

ifeq ($(BR2_ENDIAN),"BIG")
CDRKIT_CONF_OPTS += -DBITFIELDS_HTOL=1
else
CDRKIT_CONF_OPTS += -DBITFIELDS_HTOL=0
endif

ifeq ($(BR2_PACKAGE_FILE),y)
CDRKIT_DEPENDENCIES += host-pkgconf file
CDRKIT_CONF_OPTS += \
	-DUSE_MAGIC=ON \
	-DEXTRA_LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libmagic`"
else
CDRKIT_CONF_OPTS += -DUSE_MAGIC=OFF
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))
