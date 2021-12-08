 ################################################################################
#
# The ShredOS user and developer manual
#
################################################################################

MANUAL_SOURCES = $(sort $(wildcard shredos_manual/*.txt) $(wildcard images/*))
MANUAL_RESOURCES = $(TOPDIR)/images

$(eval $(call asciidoc-document))
