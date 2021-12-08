################################################################################
#
# cramfs
#
################################################################################

CRAMFS_VERSION = 2.1
CRAMFS_SITE = $(call github,npitre,cramfs-tools,v$(CRAMFS_VERSION))
CRAMFS_LICENSE = GPL-2.0+
CRAMFS_LICENSE_FILES = COPYING

CRAMFS_DEPENDENCIES = zlib
HOST_CRAMFS_DEPENDENCIES = host-zlib

define CRAMFS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D)
endef

define CRAMFS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/mkcramfs $(TARGET_DIR)/usr/bin/mkcramfs
	$(INSTALL) -D -m 755 $(@D)/cramfsck $(TARGET_DIR)/usr/bin/cramfsck
endef

define HOST_CRAMFS_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) CFLAGS="$(HOST_CFLAGS) -Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64" LDFLAGS="$(HOST_LDFLAGS)" -C $(@D)
endef

define HOST_CRAMFS_INSTALL_CMDS
	$(INSTALL) -D -m 755 $(@D)/mkcramfs $(HOST_DIR)/bin/mkcramfs
	$(INSTALL) -D -m 755 $(@D)/cramfsck $(HOST_DIR)/bin/cramfsck
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
