################################################################################
#
# fb-test-app
#
################################################################################

FB_TEST_APP_VERSION = 1.1.1
FB_TEST_APP_SITE = $(call github,andy-shev,fb-test-app,rosetta-$(FB_TEST_APP_VERSION))
FB_TEST_APP_LICENSE = GPL-2.0
FB_TEST_APP_LICENSE_FILES = COPYING

define FB_TEST_APP_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define FB_TEST_APP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/perf $(TARGET_DIR)/usr/bin/fb-test-perf
	$(INSTALL) -D -m 0755 $(@D)/rect $(TARGET_DIR)/usr/bin/fb-test-rect
	$(INSTALL) -D -m 0755 $(@D)/fb-test $(TARGET_DIR)/usr/bin/fb-test
	$(INSTALL) -D -m 0755 $(@D)/offset $(TARGET_DIR)/usr/bin/fb-test-offset
	$(INSTALL) -D -m 0755 $(@D)/fb-string $(TARGET_DIR)/usr/bin/fb-test-string
endef

$(eval $(generic-package))
