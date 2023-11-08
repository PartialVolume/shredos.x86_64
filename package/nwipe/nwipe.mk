################################################################################
#
# nwipe
#
################################################################################

NWIPE_VERSION = v0.35
NWIPE_SITE = $(call github,martijnvanbrummelen,nwipe,$(NWIPE_VERSION))
NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils

define NWIPE_INITSH
	(cd $(@D) && cp ../../../package/nwipe/002-nwipe-banner-patch.sh $(@D) && ./002-nwipe-banner-patch.sh  && PATH="../../host/bin:${PATH}" ./autogen.sh);
endef

NWIPE_POST_PATCH_HOOKS += NWIPE_INITSH


$(eval $(autotools-package))
