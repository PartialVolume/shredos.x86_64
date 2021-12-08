################################################################################
#
# pango
#
################################################################################

PANGO_VERSION_MAJOR = 1.48
PANGO_VERSION = $(PANGO_VERSION_MAJOR).10
PANGO_SOURCE = pango-$(PANGO_VERSION).tar.xz
PANGO_SITE = http://ftp.gnome.org/pub/GNOME/sources/pango/$(PANGO_VERSION_MAJOR)
PANGO_INSTALL_STAGING = YES
PANGO_LICENSE = LGPL-2.0+
PANGO_LICENSE_FILES = COPYING
PANGO_CPE_ID_VENDOR = pango

PANGO_CONF_OPTS = -Dfontconfig=enabled
HOST_PANGO_CONF_OPTS = -Dfontconfig=enabled -Dintrospection=disabled

PANGO_DEPENDENCIES = \
	$(TARGET_NLS_DEPENDENCIES) \
	host-pkgconf \
	libglib2 \
	libfribidi \
	cairo \
	harfbuzz \
	fontconfig \
	freetype
HOST_PANGO_DEPENDENCIES = \
	host-pkgconf \
	host-libglib2 \
	host-libfribidi \
	host-cairo \
	host-harfbuzz \
	host-fontconfig \
	host-freetype

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
PANGO_CONF_OPTS += -Dintrospection=enabled
PANGO_DEPENDENCIES += gobject-introspection
else
PANGO_CONF_OPTS += -Dintrospection=disabled
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
PANGO_DEPENDENCIES += xlib_libX11
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFT)$(BR2_PACKAGE_XLIB_LIBXRENDER),yy)
PANGO_DEPENDENCIES += xlib_libXft xlib_libXrender
endif

$(eval $(meson-package))
$(eval $(host-meson-package))
