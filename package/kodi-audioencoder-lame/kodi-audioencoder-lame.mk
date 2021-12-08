################################################################################
#
# kodi-audioencoder-lame
#
################################################################################

KODI_AUDIOENCODER_LAME_VERSION = 3.0.2-Matrix
KODI_AUDIOENCODER_LAME_SITE = $(call github,xbmc,audioencoder.lame,$(KODI_AUDIOENCODER_LAME_VERSION))
KODI_AUDIOENCODER_LAME_LICENSE = GPL-2.0+
KODI_AUDIOENCODER_LAME_LICENSE_FILES = LICENSE.md
KODI_AUDIOENCODER_LAME_DEPENDENCIES = kodi lame
KODI_AUDIOENCODER_LAME_CONF_OPTS += \
	-DLAME_INCLUDE_DIRS=$(STAGING_DIR)/usr/include

$(eval $(cmake-package))
