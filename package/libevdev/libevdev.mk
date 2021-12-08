################################################################################
#
# libevdev
#
################################################################################

LIBEVDEV_VERSION = 1.11.0
LIBEVDEV_SITE = http://www.freedesktop.org/software/libevdev
LIBEVDEV_SOURCE = libevdev-$(LIBEVDEV_VERSION).tar.xz
LIBEVDEV_LICENSE = MIT
LIBEVDEV_LICENSE_FILES = COPYING

LIBEVDEV_DEPENDENCIES = $(BR2_PYTHON3_HOST_DEPENDENCY)

LIBEVDEV_INSTALL_STAGING = YES

LIBEVDEV_CONF_OPTS += \
	-Dtests=disabled \
	-Ddocumentation=disabled \
	-Dcoverity=false

$(eval $(meson-package))
