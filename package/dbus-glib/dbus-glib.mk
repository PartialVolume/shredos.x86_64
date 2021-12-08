################################################################################
#
# dbus-glib
#
################################################################################

DBUS_GLIB_VERSION = 0.112
DBUS_GLIB_SITE = http://dbus.freedesktop.org/releases/dbus-glib
DBUS_GLIB_INSTALL_STAGING = YES
DBUS_GLIB_LICENSE = AFL-2.1 or GPL-2.0+
DBUS_GLIB_LICENSE_FILES = COPYING
DBUS_GLIB_CPE_ID_VENDOR = freedesktop

DBUS_GLIB_CONF_ENV = \
	ac_cv_have_abstract_sockets=yes \
	ac_cv_func_posix_getpwnam_r=yes \
	have_abstract_sockets=yes

DBUS_GLIB_CONF_OPTS = \
	--disable-tests \
	--disable-xml-docs \
	--with-introspect-xml=$(DBUS_HOST_INTROSPECT) \
	--with-dbus-binding-tool=$(DBUS_GLIB_HOST_BINARY) \
	--disable-bash-completion \
	--disable-doxygen-docs \
	--enable-asserts=yes

DBUS_GLIB_DEPENDENCIES = host-pkgconf dbus host-dbus host-dbus-glib libglib2 expat

HOST_DBUS_GLIB_DEPENDENCIES = host-dbus host-expat host-libglib2

HOST_DBUS_GLIB_CONF_OPTS = \
	--disable-tests \
	--disable-xml-docs \
	--disable-bash-completion \
	--disable-doxygen-docs \
	--enable-asserts=yes

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# dbus-glib for the host
DBUS_GLIB_HOST_BINARY = $(HOST_DIR)/bin/dbus-binding-tool
