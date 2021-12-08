################################################################################
#
# pcsc-lite
#
################################################################################

PCSC_LITE_VERSION = 1.9.1
PCSC_LITE_SOURCE = pcsc-lite-$(PCSC_LITE_VERSION).tar.bz2
PCSC_LITE_SITE = https://pcsclite.apdu.fr/files
PCSC_LITE_INSTALL_STAGING = YES
PCSC_LITE_DEPENDENCIES = host-pkgconf
PCSC_LITE_LICENSE = BSD-2-Clause (auth), BSD-3-Clause, GPL-3.0+ (demo, spy, tests), ISC (simclist)
PCSC_LITE_LICENSE_FILES = COPYING GPL-3.0.txt

# - libudev and libusb are optional
# - libudev and libusb can't be used together
# - libudev has a priority over libusb

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
PCSC_LITE_CONF_OPTS += --enable-libudev --disable-libusb
PCSC_LITE_DEPENDENCIES += udev
else
ifeq ($(BR2_PACKAGE_LIBUSB),y)
PCSC_LITE_CONF_OPTS += --enable-libusb --disable-libudev
PCSC_LITE_DEPENDENCIES += libusb
else
PCSC_LITE_CONF_OPTS += --disable-libusb --disable-libudev
endif
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
PCSC_LITE_CONF_OPTS += --enable-libsystemd
PCSC_LITE_DEPENDENCIES += systemd
else
PCSC_LITE_CONF_OPTS += --disable-libsystemd
endif

ifeq ($(PACKAGE_PCSC_LITE_DEBUGATR),y)
PCSC_LITE_CONF_OPTS += --enable-debugatr
endif

ifeq ($(PACKAGE_PCSC_LITE_EMBEDDED),y)
PCSC_LITE_CONF_OPTS += --enable-embedded
endif

$(eval $(autotools-package))
