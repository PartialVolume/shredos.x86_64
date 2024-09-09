################################################################################
#
# nwipe
#
################################################################################

# Clones the nwipe master branch to external/nwipe auf der master branch
NWIPE_VERSION = master
NWIPE_SITE = NO_SITE
NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils

# The path for git init
NWIPE_SUBMODULE_PATH = $(TOPDIR)/external/nwipe

define NWIPE_INITSH
	(cd $(NWIPE_SUBMODULE_PATH) && cp ../../../package/nwipe/002-nwipe-banner-patch.sh $(NWIPE_SUBMODULE_PATH) && ./002-nwipe-banner-patch.sh && PATH="../../host/bin:${PATH}" ./autogen.sh);
endef

NWIPE_POST_PATCH_HOOKS += NWIPE_INITSH

# Disables download procedure
define DOWNLOAD_NWIPE
	true
endef

# Copies the source out of the source path
define NWIPE_EXTRACT_CMDS
	rsync -a $(NWIPE_SUBMODULE_PATH)/ $(@D)/
endef

$(eval $(autotools-package))

