################################################################################
#
# kodi-audioencoder-flac
#
################################################################################

KODI_AUDIOENCODER_FLAC_VERSION = 3.0.0-Matrix
KODI_AUDIOENCODER_FLAC_SITE = $(call github,xbmc,audioencoder.flac,$(KODI_AUDIOENCODER_FLAC_VERSION))
KODI_AUDIOENCODER_FLAC_LICENSE = GPL-2.0+
KODI_AUDIOENCODER_FLAC_LICENSE_FILES = LICENSE.md
KODI_AUDIOENCODER_FLAC_DEPENDENCIES = flac kodi libogg host-pkgconf

$(eval $(cmake-package))
