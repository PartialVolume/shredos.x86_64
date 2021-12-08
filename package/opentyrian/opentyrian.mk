################################################################################
#
# opentyrian
#
################################################################################

OPENTYRIAN_VERSION = cf5dbeb69eebd9ef9afc4473088d9469b79589eb
OPENTYRIAN_SITE = $(call github,opentyrian,opentyrian,$(OPENTYRIAN_VERSION))
OPENTYRIAN_LICENSE = GPL-2.0+
OPENTYRIAN_LICENSE_FILES = COPYING

OPENTYRIAN_DEPENDENCIES = sdl

ifeq ($(BR2_PACKAGE_OPENTYRIAN_NET),y)
OPENTYRIAN_DEPENDENCIES += sdl_net
OPENTYRIAN_NETWORK = true
else
OPENTYRIAN_NETWORK = false
endif

define OPENTYRIAN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PLATFORM=UNIX \
		CC="$(TARGET_CC)" \
		STRIP="/bin/true" \
		SDL_CONFIG="$(STAGING_DIR)/usr/bin/sdl-config" \
		LDFLAGS="$(TARGET_LDFLAGS) -lm" \
		WITH_NETWORK="$(OPENTYRIAN_NETWORK)" \
		-C $(@D) release
endef

define OPENTYRIAN_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/opentyrian $(TARGET_DIR)/usr/bin/opentyrian
endef

$(eval $(generic-package))
