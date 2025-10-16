################################################################################
#
# nwipe
#
################################################################################

NWIPE_VERSION = 0.39
NWIPE_SITE = $(call github,martijnvanbrummelen,nwipe,$(NWIPE_VERSION))
NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils

define NWIPE_INITSH
	cd $(NWIPE_SRCDIR) && \
	cp $(NWIPE_PKGDIR)/002-nwipe-banner-patch.sh . && \
	./002-nwipe-banner-patch.sh && \
	PATH="$(HOST_DIR)/bin:$$PATH" ./autogen.sh
endef

#NWIPE_POST_PATCH_HOOKS += NWIPE_INITSH
NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_INITSH

$(eval $(autotools-package))
