################################################################################
#
# kodi-pvr-hdhomerun
#
################################################################################

KODI_PVR_HDHOMERUN_VERSION = 7.1.1-Matrix
KODI_PVR_HDHOMERUN_SITE = $(call github,kodi-pvr,pvr.hdhomerun,$(KODI_PVR_HDHOMERUN_VERSION))
KODI_PVR_HDHOMERUN_LICENSE = GPL-2.0+
KODI_PVR_HDHOMERUN_LICENSE_FILES = LICENSE.md
KODI_PVR_HDHOMERUN_DEPENDENCIES = jsoncpp kodi libhdhomerun

$(eval $(cmake-package))
