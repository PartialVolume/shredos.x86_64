################################################################################
#
# bluez5_utils
#
################################################################################

# Keep the version and patches in sync with bluez5_utils-headers
BLUEZ5_UTILS_VERSION = 5.60
BLUEZ5_UTILS_SOURCE = bluez-$(BLUEZ5_UTILS_VERSION).tar.xz
BLUEZ5_UTILS_SITE = $(BR2_KERNEL_MIRROR)/linux/bluetooth
BLUEZ5_UTILS_INSTALL_STAGING = YES
BLUEZ5_UTILS_LICENSE = GPL-2.0+, LGPL-2.1+
BLUEZ5_UTILS_LICENSE_FILES = COPYING COPYING.LIB
BLUEZ5_UTILS_CPE_ID_VENDOR = bluez
BLUEZ5_UTILS_CPE_ID_PRODUCT = bluez

BLUEZ5_UTILS_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_BLUEZ5_UTILS_HEADERS),bluez5_utils-headers) \
	dbus \
	libglib2

BLUEZ5_UTILS_CONF_OPTS = \
	--enable-library \
	--disable-cups \
	--disable-manpages \
	--with-dbusconfdir=/etc

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_OBEX),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-obex
BLUEZ5_UTILS_DEPENDENCIES += libical
else
BLUEZ5_UTILS_CONF_OPTS += --disable-obex
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_CLIENT),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-client
BLUEZ5_UTILS_DEPENDENCIES += readline
else
BLUEZ5_UTILS_CONF_OPTS += --disable-client
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_MONITOR),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-monitor
else
BLUEZ5_UTILS_CONF_OPTS += --disable-monitor
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_TOOLS),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-tools
else
BLUEZ5_UTILS_CONF_OPTS += --disable-tools
endif

# experimental plugins
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_EXPERIMENTAL),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-experimental
else
BLUEZ5_UTILS_CONF_OPTS += --disable-experimental
endif

# enable audio plugins (a2dp and avrcp)
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_AUDIO),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-a2dp --enable-avrcp
else
BLUEZ5_UTILS_CONF_OPTS += --disable-a2dp --disable-avrcp
endif

# enable health plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_HEALTH),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-health
else
BLUEZ5_UTILS_CONF_OPTS += --disable-health
endif

# enable hid plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_HID),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-hid
else
BLUEZ5_UTILS_CONF_OPTS += --disable-hid
endif

# enable hog plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_HOG),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-hog
else
BLUEZ5_UTILS_CONF_OPTS += --disable-hog
endif

# enable mesh profile
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_MESH),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-external-ell --enable-mesh
BLUEZ5_UTILS_DEPENDENCIES += ell json-c readline
else
BLUEZ5_UTILS_CONF_OPTS += --disable-external-ell --disable-mesh
endif

# enable midi profile
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_MIDI),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-midi
BLUEZ5_UTILS_DEPENDENCIES += alsa-lib
else
BLUEZ5_UTILS_CONF_OPTS += --disable-midi
endif

# enable network plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_NETWORK),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-network
else
BLUEZ5_UTILS_CONF_OPTS += --disable-network
endif

# enable nfc plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_NFC),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-nfc
else
BLUEZ5_UTILS_CONF_OPTS += --disable-nfc
endif

# enable sap plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_SAP),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-sap
else
BLUEZ5_UTILS_CONF_OPTS += --disable-sap
endif

# enable sixaxis plugin
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_PLUGINS_SIXAXIS),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-sixaxis
else
BLUEZ5_UTILS_CONF_OPTS += --disable-sixaxis
endif

ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_DEPRECATED),y)
# install gatttool (For some reason upstream choose not to do it by default)
# gattool depends on the client for readline
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_CLIENT),y)
define BLUEZ5_UTILS_INSTALL_GATTTOOL
	$(INSTALL) -D -m 0755 $(@D)/attrib/gatttool $(TARGET_DIR)/usr/bin/gatttool
endef
BLUEZ5_UTILS_POST_INSTALL_TARGET_HOOKS += BLUEZ5_UTILS_INSTALL_GATTTOOL
endif

# hciattach_bcm43xx defines default firmware path in `/etc/firmware`, but
# Broadcom firmware blobs are usually located in `/lib/firmware`.
BLUEZ5_UTILS_CONF_ENV += \
	CPPFLAGS='$(TARGET_CPPFLAGS) -DFIRMWARE_DIR=\"/lib/firmware\"'
BLUEZ5_UTILS_CONF_OPTS += --enable-deprecated
else
BLUEZ5_UTILS_CONF_OPTS += --disable-deprecated
endif

# enable test
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_TEST),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-test
else
BLUEZ5_UTILS_CONF_OPTS += --disable-test
endif

# enable hid2hci tool
ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS_TOOLS_HID2HCI),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-hid2hci
else
BLUEZ5_UTILS_CONF_OPTS += --disable-hid2hci
endif

# use udev if available
ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-udev
BLUEZ5_UTILS_DEPENDENCIES += udev
else
BLUEZ5_UTILS_CONF_OPTS += --disable-udev
endif

# integrate with systemd if available
ifeq ($(BR2_PACKAGE_SYSTEMD),y)
BLUEZ5_UTILS_CONF_OPTS += --enable-systemd
BLUEZ5_UTILS_DEPENDENCIES += systemd
else
BLUEZ5_UTILS_CONF_OPTS += --disable-systemd
endif

define BLUEZ5_UTILS_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/bluez5_utils/S40bluetooth \
		$(TARGET_DIR)/etc/init.d/S40bluetooth
endef

$(eval $(autotools-package))
