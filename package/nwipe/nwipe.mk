################################################################################
#
# nwipe
#
################################################################################

# Instead of v0.38, we now use the desired commit (e.g., 051e1aa)
NWIPE_VERSION = 051e1aa

# Specify the Git source:
#  - NWIPE_SITE points to the repository
#  - NWIPE_SITE_METHOD = git ensures that Buildroot performs a Git checkout
NWIPE_SITE = https://github.com/martijnvanbrummelen/nwipe.git
NWIPE_SITE_METHOD = git

# Dependencies remain the same (adjust them if you need additional ones)
NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils

# This hook copies your patch script (banner patch) into the source directory
# and runs autogen.sh before the actual configure/make starts.
define NWIPE_INITSH
        (cd $(@D) && cp ../../../package/nwipe/002-nwipe-banner-patch.sh $(@D) \
                && ./002-nwipe-banner-patch.sh \
                && PATH="../../host/bin:${PATH}" ./autogen.sh);
endef

NWIPE_POST_PATCH_HOOKS += NWIPE_INITSH

# Include the Buildroot autotools package framework, 
# which takes care of configure/make/make install.
$(eval $(autotools-package))
