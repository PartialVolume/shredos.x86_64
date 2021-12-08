################################################################################
#
# kodi-visualisation-shadertoy
#
################################################################################

KODI_VISUALISATION_SHADERTOY_VERSION = 19.0.0-Matrix
KODI_VISUALISATION_SHADERTOY_SITE = $(call github,xbmc,visualization.shadertoy,$(KODI_VISUALISATION_SHADERTOY_VERSION))
KODI_VISUALISATION_SHADERTOY_LICENSE = GPL-2.0+
KODI_VISUALISATION_SHADERTOY_LICENSE_FILES = LICENSE.md
KODI_VISUALISATION_SHADERTOY_DEPENDENCIES = glm kodi

$(eval $(cmake-package))
