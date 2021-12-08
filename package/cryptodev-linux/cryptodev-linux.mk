################################################################################
#
# cryptodev-linux
#
################################################################################

CRYPTODEV_LINUX_VERSION = fabe5989a3dc9fba0cd0a40b612247cdde351c01
CRYPTODEV_LINUX_SITE = $(call github,cryptodev-linux,cryptodev-linux,$(CRYPTODEV_LINUX_VERSION))
CRYPTODEV_LINUX_INSTALL_STAGING = YES
CRYPTODEV_LINUX_LICENSE = GPL-2.0+
CRYPTODEV_LINUX_LICENSE_FILES = COPYING
CRYPTODEV_LINUX_CPE_ID_VENDOR = cryptodev-linux

CRYPTODEV_LINUX_PROVIDES = cryptodev

define CRYPTODEV_LINUX_MODULE_GEN_VERSION_H
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) version.h
endef
CRYPTODEV_LINUX_PRE_BUILD_HOOKS += CRYPTODEV_LINUX_MODULE_GEN_VERSION_H

define CRYPTODEV_LINUX_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 644 $(@D)/crypto/cryptodev.h \
		$(STAGING_DIR)/usr/include/crypto/cryptodev.h
endef

$(eval $(kernel-module))
$(eval $(generic-package))
