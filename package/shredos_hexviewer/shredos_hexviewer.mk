################################################################################
#
# shredos_hexviewer
#
################################################################################

SHREDOS_HEXVIEWER_VERSION = $(call qstrip,$(BR2_PACKAGE_SHREDOS_HEXVIEWER_GIT_REVISION))
SHREDOS_HEXVIEWER_SITE = $(call github,PartialVolume,shredos_hexviewer,$(SHREDOS_HEXVIEWER_VERSION))
SHREDOS_HEXVIEWER_LICENSE = GPL-2.0
SHREDOS_HEXVIEWER_LICENSE_FILES = LICENSE
SHREDOS_HEXVIEWER_AUTORECONF = YES
SHREDOS_HEXVIEWER_DEPENDENCIES = ncurses

$(eval $(autotools-package))
