################################################################################
#
# librtlsdr
#
################################################################################

LIBRTLSDR_VERSION = ed0317e6a58c098874ac58b769cf2e609c18d9a5
LIBRTLSDR_SITE = $(call github,steve-m,librtlsdr,$(LIBRTLSDR_VERSION))
LIBRTLSDR_LICENSE = GPL-2.0+
LIBRTLSDR_LICENSE_FILES = COPYING
LIBRTLSDR_INSTALL_STAGING = YES
LIBRTLSDR_DEPENDENCIES = libusb

# BUILD_SHARED_LIBS is handled in pkg-cmake.mk as it is a generic cmake variable
ifeq ($(BR2_STATIC_LIBS),y)
LIBRTLSDR_CONF_OPTS += -DBUILD_STATIC_LIBS=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
LIBRTLSDR_CONF_OPTS += -DBUILD_STATIC_LIBS=ON
else ifeq ($(BR2_SHARED_LIBS),y)
LIBRTLSDR_CONF_OPTS += -DBUILD_STATIC_LIBS=OFF
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIBRTLSDR_CONF_OPTS += -DINSTALL_UDEV_RULES=ON
endif

ifeq ($(BR2_PACKAGE_LIBRTLSDR_DETACH_DRIVER),y)
LIBRTLSDR_CONF_OPTS += -DDETACH_KERNEL_DRIVER=1
endif

ifeq ($(BR2_PACKAGE_LIBRTLSDR_ZEROCOPY),y)
LIBRTLSDR_CONF_OPTS += -DENABLE_ZEROCOPY=ON
else
LIBRTLSDR_CONF_OPTS += -DENABLE_ZEROCOPY=OFF
endif

$(eval $(cmake-package))
