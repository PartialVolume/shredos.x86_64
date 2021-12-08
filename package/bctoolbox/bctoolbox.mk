################################################################################
#
# bctoolbox
#
################################################################################

BCTOOLBOX_VERSION = 4.4.8
BCTOOLBOX_SITE = $(call github,BelledonneCommunications,bctoolbox,$(BCTOOLBOX_VERSION))
BCTOOLBOX_LICENSE = GPL-3.0+
BCTOOLBOX_LICENSE_FILES = LICENSE.txt
BCTOOLBOX_INSTALL_STAGING = YES

# Set CMAKE_SKIP_RPATH to prevent bctoolbox from adding the rpath to
# shared library.
BCTOOLBOX_CONF_OPTS = \
	-DENABLE_POLARSSL=OFF \
	-DENABLE_STRICT=OFF \
	-DENABLE_TESTS_COMPONENT=OFF \
	-DENABLE_TESTS=OFF \
	-DCMAKE_SKIP_RPATH=ON

ifeq ($(BR2_PACKAGE_LIBICONV),y)
BCTOOLBOX_DEPENDENCIES += libiconv
BCTOOLBOX_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -liconv"
endif

ifeq ($(BR2_PACKAGE_MBEDTLS),y)
BCTOOLBOX_DEPENDENCIES += mbedtls
BCTOOLBOX_CONF_OPTS += -DENABLE_MBEDTLS=ON
else
BCTOOLBOX_CONF_OPTS += -DENABLE_MBEDTLS=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=OFF -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=ON
else ifeq ($(BR2_SHARED_LIBS),y)
BCTOOLBOX_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_STATIC=OFF
endif

$(eval $(cmake-package))
