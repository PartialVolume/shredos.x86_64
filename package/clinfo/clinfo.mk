################################################################################
#
# clinfo
#
################################################################################

CLINFO_VERSION = 3.0.21.02.21
CLINFO_SITE = $(call github,Oblomov,clinfo,$(CLINFO_VERSION))
CLINFO_LICENSE = CC0-1.0
CLINFO_LICENSE_FILES = legalcode.txt LICENSE
CLINFO_DEPENDENCIES = libopencl

define CLINFO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define CLINFO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/clinfo $(TARGET_DIR)/usr/bin/clinfo
endef

$(eval $(generic-package))
