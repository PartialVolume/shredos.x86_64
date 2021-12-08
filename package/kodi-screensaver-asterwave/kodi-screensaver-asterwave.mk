################################################################################
#
# kodi-screensaver-asterwave
#
################################################################################

KODI_SCREENSAVER_ASTERWAVE_VERSION = 3.3.0-Matrix
KODI_SCREENSAVER_ASTERWAVE_SITE = $(call github,xbmc,screensaver.asterwave,$(KODI_SCREENSAVER_ASTERWAVE_VERSION))
KODI_SCREENSAVER_ASTERWAVE_LICENSE = GPL-2.0+
KODI_SCREENSAVER_ASTERWAVE_LICENSE_FILES = LICENSE.md
KODI_SCREENSAVER_ASTERWAVE_DEPENDENCIES = glm kodi

KODI_SCREENSAVER_ASTERWAVE_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(TARGET_CFLAGS) $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)" \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(shell $(PKG_CONFIG_HOST_BINARY) --cflags egl)"

$(eval $(cmake-package))
