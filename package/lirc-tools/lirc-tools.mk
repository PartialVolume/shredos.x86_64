################################################################################
#
# lirc-tools
#
################################################################################

LIRC_TOOLS_VERSION = 0.10.1
LIRC_TOOLS_SOURCE = lirc-$(LIRC_TOOLS_VERSION).tar.bz2
LIRC_TOOLS_SITE = http://downloads.sourceforge.net/project/lirc/LIRC/$(LIRC_TOOLS_VERSION)
LIRC_TOOLS_LICENSE = GPL-2.0+
LIRC_TOOLS_LICENSE_FILES = COPYING
LIRC_TOOLS_SELINUX_MODULES = lircd
LIRC_TOOLS_DEPENDENCIES = host-libxslt host-pkgconf host-python3
LIRC_TOOLS_INSTALL_STAGING = YES
# Patching configure.ac and Makefile.am
LIRC_TOOLS_AUTORECONF = YES

LIRC_TOOLS_CONF_ENV = XSLTPROC=yes HAVE_WORKING_POLL=yes
LIRC_TOOLS_CONF_OPTS = --without-x --enable-devinput --enable-uinput

ifeq ($(BR2_TOOLCHAIN_HEADERS_AT_LEAST_4_4),y)
LIRC_TOOLS_CONF_ENV += \
	DEVINPUT_HEADER=$(STAGING_DIR)/usr/include/linux/input-event-codes.h
else
LIRC_TOOLS_CONF_ENV += \
	DEVINPUT_HEADER=$(STAGING_DIR)/usr/include/linux/input.h
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
LIRC_TOOLS_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
LIRC_TOOLS_DEPENDENCIES += alsa-lib
endif

ifeq ($(BR2_PACKAGE_LIBUSB_COMPAT),y)
LIRC_TOOLS_DEPENDENCIES += libusb-compat
endif

ifeq ($(BR2_PACKAGE_PORTAUDIO),y)
LIRC_TOOLS_DEPENDENCIES += portaudio
endif

ifeq ($(BR2_PACKAGE_LIBFTDI1),y)
LIRC_TOOLS_DEPENDENCIES += libftdi1
endif

ifeq ($(BR2_PACKAGE_PYTHON3),y)
LIRC_TOOLS_DEPENDENCIES += python3 host-python3-setuptools
LIRC_TOOLS_MAKE_ENV += SETUPTOOLS_ENV='$(PKG_PYTHON_SETUPTOOLS_ENV)'
endif

define LIRC_TOOLS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/lirc-tools/S25lircd \
		$(TARGET_DIR)/etc/init.d/S25lircd
endef

$(eval $(autotools-package))
