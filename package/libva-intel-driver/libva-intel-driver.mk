################################################################################
#
# libva-intel-driver
#
################################################################################

LIBVA_INTEL_DRIVER_VERSION = 2.4.1
LIBVA_INTEL_DRIVER_SOURCE = intel-vaapi-driver-$(LIBVA_INTEL_DRIVER_VERSION).tar.bz2
LIBVA_INTEL_DRIVER_SITE = \
	https://github.com/intel/intel-vaapi-driver/releases/download/$(LIBVA_INTEL_DRIVER_VERSION)
LIBVA_INTEL_DRIVER_LICENSE = MIT
LIBVA_INTEL_DRIVER_LICENSE_FILES = COPYING
LIBVA_INTEL_DRIVER_DEPENDENCIES = host-pkgconf libdrm libva

ifeq ($(BR2_PACKAGE_XORG7),y)
LIBVA_INTEL_DRIVER_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXfixes
LIBVA_INTEL_DRIVER_CONF_OPTS += --enable-x11
else
LIBVA_INTEL_DRIVER_CONF_OPTS += --disable-x11
endif

ifeq ($(BR2_PACKAGE_WAYLAND),y)
LIBVA_INTEL_DRIVER_DEPENDENCIES += wayland
LIBVA_INTEL_DRIVER_CONF_OPTS += --enable-wayland
else
LIBVA_INTEL_DRIVER_CONF_OPTS += --disable-wayland
endif

$(eval $(autotools-package))
