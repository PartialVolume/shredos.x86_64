################################################################################
#
# exfat
#
################################################################################

EXFAT_VERSION = 1.3.0
EXFAT_SITE = https://github.com/relan/exfat/releases/download/v$(EXFAT_VERSION)
EXFAT_SOURCE = fuse-exfat-$(EXFAT_VERSION).tar.gz
EXFAT_DEPENDENCIES = libfuse host-pkgconf
EXFAT_LICENSE = GPL-2.0+
EXFAT_LICENSE_FILES = COPYING
EXFAT_CFLAGS = $(TARGET_CFLAGS) -std=c99

EXFAT_CONF_OPTS += --exec-prefix=/

$(eval $(autotools-package))
