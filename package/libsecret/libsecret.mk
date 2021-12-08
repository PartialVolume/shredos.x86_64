################################################################################
#
# libsecret
#
################################################################################

LIBSECRET_VERSION_MAJOR = 0.20
LIBSECRET_VERSION = $(LIBSECRET_VERSION_MAJOR).4
LIBSECRET_SITE = http://ftp.gnome.org/pub/GNOME/sources/libsecret/$(LIBSECRET_VERSION_MAJOR)
LIBSECRET_SOURCE = libsecret-$(LIBSECRET_VERSION).tar.xz
LIBSECRET_INSTALL_STAGING = YES
LIBSECRET_DEPENDENCIES = libglib2 $(TARGET_NLS_DEPENDENCIES)
LIBSECRET_CONF_ENV = LIBS=$(TARGET_NLS_LIBS)
LIBSECRET_CONF_OPTS = \
	--disable-manpages \
	--disable-strict \
	--disable-coverage \
	--enable-vala=no
LIBSECRET_LICENSE = LGPL-2.1+
LIBSECRET_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
LIBSECRET_CONF_OPTS += --enable-introspection=yes
LIBSECRET_DEPENDENCIES += gobject-introspection
else
LIBSECRET_CONF_OPTS += --enable-introspection=no
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
LIBSECRET_DEPENDENCIES += libgcrypt
LIBSECRET_CONF_OPTS += --enable-gcrypt \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBSECRET_CONF_OPTS += --disable-gcrypt
endif

$(eval $(autotools-package))
