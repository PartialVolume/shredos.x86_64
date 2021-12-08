################################################################################
#
# dbus
#
################################################################################

DBUS_VERSION = 1.12.20
DBUS_SITE = https://dbus.freedesktop.org/releases/dbus
DBUS_LICENSE = AFL-2.1 or GPL-2.0+ (library, tools), GPL-2.0+ (tools)
DBUS_LICENSE_FILES = COPYING
DBUS_CPE_ID_VENDOR = d-bus_project
DBUS_CPE_ID_PRODUCT = d-bus
DBUS_INSTALL_STAGING = YES

define DBUS_PERMISSIONS
	/usr/libexec/dbus-daemon-launch-helper f 4750 0 dbus - - - - -
endef

define DBUS_USERS
	dbus -1 dbus -1 * /run/dbus - dbus DBus messagebus user
endef

DBUS_DEPENDENCIES = host-pkgconf expat

DBUS_SELINUX_MODULES = dbus

DBUS_CONF_OPTS = \
	--with-dbus-user=dbus \
	--disable-tests \
	--disable-asserts \
	--disable-xml-docs \
	--disable-doxygen-docs \
	--with-system-socket=/run/dbus/system_bus_socket \
	--with-system-pid-file=/run/messagebus.pid

ifeq ($(BR2_STATIC_LIBS),y)
DBUS_CONF_OPTS += LIBS='-pthread'
endif

ifeq ($(BR2_microblaze),y)
# microblaze toolchain doesn't provide inotify_rm_* but does have sys/inotify.h
DBUS_CONF_OPTS += --disable-inotify
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
DBUS_CONF_OPTS += --enable-selinux
DBUS_DEPENDENCIES += libselinux
else
DBUS_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_AUDIT)$(BR2_PACKAGE_LIBCAP_NG),yy)
DBUS_CONF_OPTS += --enable-libaudit
DBUS_DEPENDENCIES += audit libcap-ng
else
DBUS_CONF_OPTS += --disable-libaudit
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
DBUS_CONF_OPTS += --with-x
DBUS_DEPENDENCIES += xlib_libX11
ifeq ($(BR2_PACKAGE_XLIB_LIBSM),y)
DBUS_DEPENDENCIES += xlib_libSM
endif
else
DBUS_CONF_OPTS += --without-x
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
DBUS_CONF_OPTS += \
	--enable-systemd \
	--with-systemdsystemunitdir=/usr/lib/systemd/system
DBUS_DEPENDENCIES += systemd
else
DBUS_CONF_OPTS += --disable-systemd
endif

# fix rebuild (dbus makefile errors out if /var/lib/dbus is a symlink)
define DBUS_REMOVE_VAR_LIB_DBUS
	rm -rf $(TARGET_DIR)/var/lib/dbus
endef

DBUS_PRE_INSTALL_TARGET_HOOKS += DBUS_REMOVE_VAR_LIB_DBUS

define DBUS_REMOVE_DEVFILES
	rm -rf $(TARGET_DIR)/usr/lib/dbus-1.0
endef

DBUS_POST_INSTALL_TARGET_HOOKS += DBUS_REMOVE_DEVFILES

define DBUS_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/dbus/S30dbus \
		$(TARGET_DIR)/etc/init.d/S30dbus

	mkdir -p $(TARGET_DIR)/var/lib
	rm -rf $(TARGET_DIR)/var/lib/dbus
	ln -sf /tmp/dbus $(TARGET_DIR)/var/lib/dbus
endef

define DBUS_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/var/lib/dbus
	ln -sf /etc/machine-id $(TARGET_DIR)/var/lib/dbus/machine-id
endef

HOST_DBUS_DEPENDENCIES = host-pkgconf host-expat
HOST_DBUS_CONF_OPTS = \
	--with-dbus-user=dbus \
	--disable-tests \
	--disable-asserts \
	--disable-selinux \
	--disable-xml-docs \
	--disable-doxygen-docs \
	--disable-systemd \
	--without-x

# dbus for the host
DBUS_HOST_INTROSPECT = $(HOST_DBUS_DIR)/introspect.xml

HOST_DBUS_GEN_INTROSPECT = \
	$(HOST_DIR)/bin/dbus-daemon --introspect > $(DBUS_HOST_INTROSPECT)

HOST_DBUS_POST_INSTALL_HOOKS += HOST_DBUS_GEN_INTROSPECT

$(eval $(autotools-package))
$(eval $(host-autotools-package))
