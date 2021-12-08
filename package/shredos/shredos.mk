 ################################################################################
#
# The ShredOS user and developer manual
#
################################################################################

MANUAL_SOURCES = $(sort $(wildcard  $(pkgdir)/*.txt))
MANUAL_RESOURCES = $(TOPDIR)/images

$(eval $(call asciidoc-document))
