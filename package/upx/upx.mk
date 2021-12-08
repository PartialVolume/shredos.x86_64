################################################################################
#
# upx
#
################################################################################

UPX_VERSION = 3.96
UPX_SITE = https://github.com/upx/upx/releases/download/v$(UPX_VERSION)
UPX_SOURCE = upx-$(UPX_VERSION)-src.tar.xz
UPX_LICENSE = GPL-2.0+
UPX_LICENSE_FILES = COPYING
UPX_CPE_ID_VENDOR = upx_project

# 0001-Check-DT_REL-DT_RELA-DT_RELSZ-DT_RELASZ.patch
UPX_IGNORE_CVES += CVE-2021-20285

HOST_UPX_DEPENDENCIES = host-ucl host-zlib

# We need to specify all, otherwise the default target only prints a message
# stating to "please choose a target for 'make'"... :-(
define HOST_UPX_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) \
		UPX_UCLDIR=$(HOST_DIR) CXXFLAGS_WERROR= -C $(@D) all
endef

# UPX has no install procedure, so install it manually.
define HOST_UPX_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/src/upx.out $(HOST_DIR)/bin/upx
endef

$(eval $(host-generic-package))
