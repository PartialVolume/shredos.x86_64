################################################################################
#
# nwipe
#
################################################################################

# Plain URL Download
#NWIPE_VERSION = 0.39
#NWIPE_SOURCE = v$(NWIPE_VERSION).tar.gz
#NWIPE_SITE = https://github.com/martijnvanbrummelen/nwipe/archive/refs/tags

# Plain URL Download - but with git commit hashes
NWIPE_VERSION = ed74492a1d56ec2afd259ee53a1a9758597e137a
NWIPE_SOURCE = $(NWIPE_VERSION).tar.gz
NWIPE_SITE = https://github.com/martijnvanbrummelen/nwipe/archive


NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils

define NWIPE_INITSH
    (cd $(@D) && cp ../../../package/nwipe/002-nwipe-banner-patch.sh $(@D) && ./002-nwipe-banner-patch.sh  && PATH="../../host/bin:${PATH}" ./autogen.sh);
endef

#NWIPE_POST_PATCH_HOOKS += NWIPE_INITSH
NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_INITSH

$(eval $(autotools-package))
