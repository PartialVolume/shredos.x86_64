################################################################################
#
# lua
#
################################################################################

ifeq ($(BR2_PACKAGE_LUA_5_4),y)
LUA_VERSION = 5.4.3
else ifeq ($(BR2_PACKAGE_LUA_5_3),y)
LUA_VERSION = 5.3.6
else
LUA_VERSION = 5.1.5
endif
LUA_SITE = https://www.lua.org/ftp
LUA_INSTALL_STAGING = YES
LUA_LICENSE = MIT
ifeq ($(BR2_PACKAGE_LUA_5_3)$(BR2_PACKAGE_LUA_5_4),y)
LUA_LICENSE_FILES = doc/readme.html
else
LUA_LICENSE_FILES = COPYRIGHT
endif
LUA_CPE_ID_VENDOR = lua

LUA_PROVIDES = luainterpreter

LUA_CFLAGS = -Wall -fPIC -DLUA_USE_POSIX

ifeq ($(BR2_PACKAGE_LUA_5_4),y)
LUA_CFLAGS += -DLUA_COMPAT_5_3
else ifeq ($(BR2_PACKAGE_LUA_5_3),y)
LUA_CFLAGS += -DLUA_COMPAT_5_2
endif

ifeq ($(BR2_STATIC_LIBS),y)
LUA_BUILDMODE = static
else
LUA_BUILDMODE = dynamic
LUA_CFLAGS += -DLUA_USE_DLOPEN
LUA_MYLIBS += -ldl
endif

ifeq ($(BR2_PACKAGE_LUA_READLINE),y)
LUA_DEPENDENCIES += readline ncurses
LUA_MYLIBS += -lreadline -lhistory -lncurses
LUA_CFLAGS += -DLUA_USE_READLINE
else
ifeq ($(BR2_PACKAGE_LUA_LINENOISE),y)
LUA_DEPENDENCIES += linenoise
LUA_MYLIBS += -llinenoise
LUA_CFLAGS += -DLUA_USE_LINENOISE
endif
endif

ifeq ($(BR2_PACKAGE_LUA_32BITS),y)
define LUA_32BITS_LUACONF
	$(SED) 's/\/\* #define LUA_32BITS \*\//#define LUA_32BITS/' $(@D)/src/luaconf.h
endef

LUA_POST_PATCH_HOOKS += LUA_32BITS_LUACONF
endif

define HOST_LUA_LUACONF
	$(SED) 's|#define LUA_ROOT.*|#define LUA_ROOT "$(HOST_DIR)/usr/"|' $(@D)/src/luaconf.h
endef
HOST_LUA_POST_PATCH_HOOKS += HOST_LUA_LUACONF

HOST_LUA_CFLAGS = -Wall -fPIC -DLUA_USE_DLOPEN -DLUA_USE_POSIX
ifeq ($(BR2_PACKAGE_LUA_5_3),y)
HOST_LUA_CFLAGS += -DLUA_COMPAT_5_2
endif
HOST_LUA_MYLIBS = -ldl

define LUA_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
	CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" \
	CFLAGS="$(TARGET_CFLAGS) $(LUA_CFLAGS)" \
	MYLIBS="$(LUA_MYLIBS)" AR="$(TARGET_CROSS)ar rcu" \
	MYLDFLAGS="$(TARGET_LDFLAGS)" \
	BUILDMODE=$(LUA_BUILDMODE) \
	PKG_VERSION=$(LUA_VERSION) -C $(@D)/src all
	sed -e "s/@VERSION@/$(LUA_VERSION)/;s/@ABI@/$(LUAINTERPRETER_ABIVER)/;s/@MYLIBS@/$(LUA_MYLIBS)/" \
		package/lua/lua.pc.in > $(@D)/lua.pc
endef

define HOST_LUA_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) \
	CFLAGS="$(HOST_LUA_CFLAGS)" \
	MYLDFLAGS="$(HOST_LDFLAGS)" \
	MYLIBS="$(HOST_LUA_MYLIBS)" \
	BUILDMODE=dynamic \
	PKG_VERSION=$(LUA_VERSION) -C $(@D)/src all
	sed -e "s/@VERSION@/$(LUA_VERSION)/;s/@ABI@/$(LUAINTERPRETER_ABIVER)/;s/@MYLIBS@/$(HOST_LUA_MYLIBS)/" \
		package/lua/lua.pc.in > $(@D)/lua.pc
endef

define LUA_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) INSTALL_TOP="$(STAGING_DIR)/usr" -C $(@D) install
	$(INSTALL) -m 0644 -D $(@D)/lua.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/lua.pc
endef

define LUA_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) INSTALL_TOP="$(TARGET_DIR)/usr" -C $(@D) install
endef

define HOST_LUA_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) INSTALL_TOP="$(HOST_DIR)" -C $(@D) install
	$(INSTALL) -m 0644 -D $(@D)/lua.pc \
		$(HOST_DIR)/lib/pkgconfig/lua.pc
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
