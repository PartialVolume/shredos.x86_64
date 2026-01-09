################################################################################
#
# opeseachest
#
################################################################################

OPENSEACHEST_VERSION = 25.05.3
OPENSEACHEST_SOURCE = SourceCode_With_Submodules.tar.xz
OPENSEACHEST_SITE = https://github.com/Seagate/openSeaChest/releases/download/v25.05.3
OPENSEACHEST_LICENSE = MPL-2.0
OPENSEACHEST_LICENSE_FILES = COPYING
OPENSEACHEST_INSTALL_STAGING = YES

OPENSEACHEST_DEPENDENCIES = host-pkgconf

$(eval $(meson-package))
