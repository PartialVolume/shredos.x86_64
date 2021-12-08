################################################################################
#
# luarocks
#
################################################################################

LUAROCKS_VERSION = 3.7.0
LUAROCKS_SITE = http://luarocks.org/releases
LUAROCKS_LICENSE = MIT
LUAROCKS_LICENSE_FILES = COPYING

HOST_LUAROCKS_DEPENDENCIES = host-luainterpreter

LUAROCKS_CONFIG_DIR = $(HOST_DIR)/etc
LUAROCKS_CONFIG_FILE_DEFAULT = $(LUAROCKS_CONFIG_DIR)/luarocks/config-$(LUAINTERPRETER_ABIVER).lua
LUAROCKS_CONFIG_FILE = $(LUAROCKS_CONFIG_DIR)/luarocks/config.lua
HOST_LUAROCKS_CONFIG_FILE = $(LUAROCKS_CONFIG_DIR)/luarocks/host-config.lua

define LUAROCKS_ADDON_EXTRACT
	$(INSTALL) -D -m 0644 package/luarocks/buildroot.lua $(@D)/src/luarocks/cmd/external/buildroot.lua
endef
HOST_LUAROCKS_POST_EXTRACT_HOOKS += LUAROCKS_ADDON_EXTRACT

HOST_LUAROCKS_CONF_OPTS = \
	--prefix=$(HOST_DIR) \
	--sysconfdir=$(LUAROCKS_CONFIG_DIR) \
	--with-lua=$(HOST_DIR)

define HOST_LUAROCKS_CONFIGURE_CMDS
	cd $(@D) && ./configure $(HOST_LUAROCKS_CONF_OPTS)
endef

define HOST_LUAROCKS_INSTALL_CMDS
	rm -f $(LUAROCKS_CONFIG_FILE_DEFAULT)
	$(MAKE1) -C $(@D) install
	cp $(LUAROCKS_CONFIG_FILE_DEFAULT) $(LUAROCKS_CONFIG_FILE)
	echo "-- BR cross-compilation"  >> $(LUAROCKS_CONFIG_FILE)
	echo "gcc_rpath = false"        >> $(LUAROCKS_CONFIG_FILE)
	echo "wrap_bin_scripts = false" >> $(LUAROCKS_CONFIG_FILE)
	cp $(LUAROCKS_CONFIG_FILE_DEFAULT) $(HOST_LUAROCKS_CONFIG_FILE)
	rm -f $(LUAROCKS_CONFIG_FILE_DEFAULT)
endef

$(eval $(host-generic-package))

define LUAROCKS_FINALIZE_TARGET
	rm -rf $(TARGET_DIR)/usr/lib/luarocks
endef

# Apply to global variable directly, as pkg-generic does not
ifneq ($(BR2_PACKAGE_LUAJIT)$(BR2_PACKAGE_LUA),)
TARGET_FINALIZE_HOOKS += LUAROCKS_FINALIZE_TARGET
endif
