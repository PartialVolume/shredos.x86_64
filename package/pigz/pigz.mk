################################################################################
#
# pigz
#
################################################################################

PIGZ_VERSION = 2.6
PIGZ_SITE = $(call github,madler,pigz,v$(PIGZ_VERSION))
PIGZ_DEPENDENCIES = zlib
HOST_PIGZ_DEPENDENCIES = host-zlib
PIGZ_LICENSE = Zlib
PIGZ_LICENSE_FILES = README
PIGZ_CPE_ID_VENDOR = zlib

define PIGZ_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define HOST_PIGZ_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D)
endef

define PIGZ_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/pigz $(TARGET_DIR)/usr/bin/pigz
endef

define HOST_PIGZ_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/pigz $(HOST_DIR)/bin/pigz
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
