################################################################################
#
# lz4
#
################################################################################

LZ4_VERSION = 1.9.3
LZ4_SITE = $(call github,lz4,lz4,v$(LZ4_VERSION))
LZ4_INSTALL_STAGING = YES
LZ4_LICENSE = BSD-2-Clause (library), GPL-2.0+ (programs)
LZ4_LICENSE_FILES = lib/LICENSE programs/COPYING
LZ4_CPE_ID_VENDOR = yann_collet

# CVE-2014-4715 is misclassified (by our CVE tracker) as affecting version
# 1.9.2, while in fact this issue has been fixed since lz4-r130:
# https://github.com/lz4/lz4/commit/140e6e72ddb6fc5f7cd28ce0c8ec3812ef4a9c08
# See https://github.com/lz4/lz4/issues/818
LZ4_IGNORE_CVES += CVE-2014-4715

# 0001-Fix-potential-memory-corruption-with-negative-memmov.patch
LZ4_IGNORE_CVES += CVE-2021-3520

ifeq ($(BR2_STATIC_LIBS),y)
LZ4_MAKE_OPTS += BUILD_SHARED=no
else ifeq ($(BR2_SHARED_LIBS),y)
LZ4_MAKE_OPTS += BUILD_STATIC=no
endif

define HOST_LZ4_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) lib
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) lz4
endef

define HOST_LZ4_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) PREFIX=$(HOST_DIR) \
		install -C $(@D)
endef

LZ4_DIRS = lib

ifeq ($(BR2_PACKAGE_LZ4_PROGS),y)
LZ4_DIRS += programs
endif

define LZ4_BUILD_CMDS
	$(foreach dir,$(LZ4_DIRS),\
		$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) $(LZ4_MAKE_OPTS) \
			-C $(@D)/$(dir)
	)
endef

define LZ4_INSTALL_STAGING_CMDS
	$(foreach dir,$(LZ4_DIRS),\
		$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(STAGING_DIR) \
			PREFIX=/usr $(LZ4_MAKE_OPTS) -C $(@D)/$(dir) install
	)
endef

define LZ4_INSTALL_TARGET_CMDS
	$(foreach dir,$(LZ4_DIRS),\
		$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(TARGET_DIR) \
			PREFIX=/usr $(LZ4_MAKE_OPTS) -C $(@D)/$(dir) install
	)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
