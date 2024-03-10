################################################################################
#
# kernel_cmdline_extractor 
#
################################################################################

KERNEL_CMDLINE_EXTRACTOR_VERSION = v1.04
KERNEL_CMDLINE_EXTRACTOR_SITE = $(call github,PartialVolume,kernel_cmdline_extractor,$(KERNEL_CMDLINE_EXTRACTOR_VERSION))
KERNEL_CMDLINE_EXTRACTOR_AUTORECONF = YES

$(eval $(autotools-package))
