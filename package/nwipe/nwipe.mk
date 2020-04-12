################################################################################
#
# nwipe
#
################################################################################

NWIPE_VERSION = v0.29.001
NWIPE_SITE = $(call github,PartialVolume,nwipe,$(NWIPE_VERSION))
NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils

define NWIPE_INITSH
	(cd $(@D) && ./init.sh);
endef

NWIPE_POST_PATCH_HOOKS += NWIPE_INITSH


$(eval $(autotools-package))
