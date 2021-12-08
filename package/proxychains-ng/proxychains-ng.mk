################################################################################
#
# proxychains-ng
#
################################################################################

PROXYCHAINS_NG_VERSION = 4.14
PROXYCHAINS_NG_SOURCE = proxychains-ng-$(PROXYCHAINS_NG_VERSION).tar.xz
PROXYCHAINS_NG_SITE = http://downloads.sourceforge.net/project/proxychains-ng
PROXYCHAINS_NG_LICENSE = GPL-2.0+
PROXYCHAINS_NG_LICENSE_FILES = COPYING
PROXYCHAINS_NG_CPE_ID_VENDOR = proxychains-ng_project

define PROXYCHAINS_NG_CONFIGURE_CMDS
	cd $(@D) && \
	$(TARGET_CONFIGURE_OPTS) ./configure --prefix=/usr --sysconfdir=/etc
endef

define PROXYCHAINS_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define PROXYCHAINS_NG_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install install-config
endef

$(eval $(generic-package))
