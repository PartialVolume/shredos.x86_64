################################################################################
#
# atk
#
################################################################################

ATK_VERSION_MAJOR = 2.36
ATK_VERSION = $(ATK_VERSION_MAJOR).0
ATK_SOURCE = atk-$(ATK_VERSION).tar.xz
ATK_SITE = http://ftp.gnome.org/pub/gnome/sources/atk/$(ATK_VERSION_MAJOR)
ATK_LICENSE = LGPL-2.0+
ATK_LICENSE_FILES = COPYING
ATK_INSTALL_STAGING = YES
ATK_DEPENDENCIES = libglib2 $(TARGET_NLS_DEPENDENCIES)

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
ATK_CONF_OPTS += -Dintrospection=true
ATK_DEPENDENCIES += gobject-introspection
else
ATK_CONF_OPTS += -Dintrospection=false
endif

ATK_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

$(eval $(meson-package))
