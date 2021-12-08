################################################################################
#
# mkpimage
#
################################################################################

HOST_MKPIMAGE_LICENSE = GPL-2.0

# source included in the package
# came from barebox's repository:
# https://git.pengutronix.de/cgit/barebox/tree/scripts/socfpga_mkimage.c?id=55d29525146dcd280987dfd565bfd34f08858fb3
define HOST_MKPIMAGE_EXTRACT_CMDS
	cp $(HOST_MKPIMAGE_PKGDIR)/mkpimage.c $(@D)
endef

define HOST_MKPIMAGE_BUILD_CMDS
	$(HOSTCC) $(HOST_CFLAGS) $(HOST_LDFLAGS) \
		$(@D)/mkpimage.c -o $(@D)/mkpimage
endef

define HOST_MKPIMAGE_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/mkpimage $(HOST_DIR)/bin/mkpimage
endef

$(eval $(host-generic-package))
