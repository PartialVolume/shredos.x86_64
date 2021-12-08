################################################################################
#
# uhubctl
#
################################################################################

UHUBCTL_VERSION = 2.4.0
UHUBCTL_SITE = $(call github,mvp,uhubctl,v$(UHUBCTL_VERSION))
UHUBCTL_LICENSE = GPL-2.0
UHUBCTL_LICENSE_FILES = LICENSE COPYING
UHUBCTL_DEPENDENCIES = libusb

define UHUBCTL_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) GIT_VERSION=v$(UHUBCTL_VERSION) -C $(@D)
endef

define UHUBCTL_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) DESTDIR=$(TARGET_DIR) \
		$(MAKE) -C $(@D) install
endef

$(eval $(generic-package))
