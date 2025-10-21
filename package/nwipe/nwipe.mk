################################################################################
#
# nwipe
#
################################################################################

NWIPE_VERSION = ed74492

# Specify the Git source:
#  - NWIPE_SITE points to the repository
#  - NWIPE_SITE_METHOD = git ensures that Buildroot performs a Git checkout
NWIPE_SITE = https://github.com/martijnvanbrummelen/nwipe.git
NWIPE_SITE_METHOD = git

# Dependencies remain the same (adjust them if you need additional ones)
NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils

define NWIPE_INITSH
        (cd $(@D) && cp ../../../package/nwipe/002-nwipe-banner-patch.sh $(@D) \
                && ./002-nwipe-banner-patch.sh \
                && PATH="../../host/bin:${PATH}" ./autogen.sh);
endef

NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_INITSH

$(eval $(autotools-package))
