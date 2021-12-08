################################################################################
#
# liburiparser
#
################################################################################

LIBURIPARSER_VERSION = 0.9.5
LIBURIPARSER_SOURCE = uriparser-$(LIBURIPARSER_VERSION).tar.bz2
LIBURIPARSER_SITE = https://github.com/uriparser/uriparser/releases/download/uriparser-$(LIBURIPARSER_VERSION)
LIBURIPARSER_LICENSE = BSD-3-Clause
LIBURIPARSER_LICENSE_FILES = COPYING
LIBURIPARSER_CPE_ID_VENDOR = uriparser_project
LIBURIPARSER_CPE_ID_PRODUCT = uriparser
LIBURIPARSER_INSTALL_STAGING = YES
LIBURIPARSER_CONF_OPTS = -DURIPARSER_BUILD_DOCS=OFF -DURIPARSER_BUILD_TESTS=OFF

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
LIBURIPARSER_CONF_OPTS += -DBUILD_SHARED_LIBS=ON
else
LIBURIPARSER_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF
endif

ifeq ($(BR2_USE_WCHAR),)
LIBURIPARSER_CONF_OPTS += -DURIPARSER_BUILD_WCHAR_T=OFF
endif

$(eval $(cmake-package))
