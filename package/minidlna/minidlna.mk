################################################################################
#
# minidlna
#
################################################################################

MINIDLNA_VERSION = 1.3.0
MINIDLNA_SITE = https://downloads.sourceforge.net/project/minidlna/minidlna/$(MINIDLNA_VERSION)
MINIDLNA_LICENSE = GPL-2.0, BSD-3-Clause
MINIDLNA_LICENSE_FILES = COPYING LICENCE.miniupnpd
MINIDLNA_CPE_ID_VENDOR = readymedia_project
MINIDLNA_CPE_ID_PRODUCT = readymedia
MINIDLNA_SELINUX_MODULES = minidlna

MINIDLNA_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	ffmpeg flac libvorbis libogg libid3tag libexif jpeg sqlite \
	host-xutil_makedepend

MINIDLNA_CONF_OPTS = \
	--disable-static

define MINIDLNA_INSTALL_CONF
	$(INSTALL) -D -m 644 $(@D)/minidlna.conf $(TARGET_DIR)/etc/minidlna.conf
endef

MINIDLNA_POST_INSTALL_TARGET_HOOKS += MINIDLNA_INSTALL_CONF

define MINIDLNA_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/minidlna/S60minidlnad \
		$(TARGET_DIR)/etc/init.d/S60minidlnad
endef

define MINIDLNA_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/minidlna/minidlnad.service \
		$(TARGET_DIR)/usr/lib/systemd/system/minidlnad.service
endef

$(eval $(autotools-package))
