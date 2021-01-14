################################################################################
#
# kernel_cmdline_extractor 
#
################################################################################

KERNEL_CMDLINE_EXTRACTOR_VERSION = v1.04
KERNEL_CMDLINE_EXTRACTOR_SITE = $(call github,PartialVolume,kernel_cmdline_extractor,$(KERNEL_CMDLINE_EXTRACTOR_VERSION))

define KERNEL_CMDLINE_EXTRACTOR_INITSH
	(cd $(@D) && ./autogen.sh);
endef

KERNEL_CMDLINE_EXTRACTOR_POST_PATCH_HOOKS += KERNEL_CMDLINE_EXTRACTOR_INITSH


$(eval $(autotools-package))
