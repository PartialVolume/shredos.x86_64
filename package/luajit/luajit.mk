################################################################################
#
# luajit
#
################################################################################

LUAJIT_VERSION = 2.1.2
LUAJIT_SITE = $(call github,moonjit,moonjit,$(LUAJIT_VERSION))
LUAJIT_LICENSE = MIT
LUAJIT_LICENSE_FILES = COPYRIGHT

LUAJIT_INSTALL_STAGING = YES

LUAJIT_PROVIDES = luainterpreter

ifeq ($(BR2_PACKAGE_LUAJIT_COMPAT52),y)
LUAJIT_XCFLAGS += -DLUAJIT_ENABLE_LUA52COMPAT
endif

# The luajit build procedure requires the host compiler to have the
# same bitness as the target compiler. Therefore, on a x86 build
# machine, we can't build luajit for x86_64, which is checked in
# Config.in. When the target is a 32 bits target, we pass -m32 to
# ensure that even on 64 bits build machines, a compiler of the same
# bitness is used. Of course, this assumes that the 32 bits multilib
# libraries are installed.
ifeq ($(BR2_ARCH_IS_64),y)
LUAJIT_HOST_CC = $(HOSTCC)
else
LUAJIT_HOST_CC = $(HOSTCC) -m32
endif

# We unfortunately can't use TARGET_CONFIGURE_OPTS, because the luajit
# build system uses non conventional variable names.
define LUAJIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX="/usr" \
		STATIC_CC="$(TARGET_CC)" \
		DYNAMIC_CC="$(TARGET_CC) -fPIC" \
		TARGET_LD="$(TARGET_CC)" \
		TARGET_AR="$(TARGET_AR) rcus" \
		TARGET_STRIP=true \
		TARGET_CFLAGS="$(TARGET_CFLAGS)" \
		TARGET_LDFLAGS="$(TARGET_LDFLAGS)" \
		HOST_CC="$(LUAJIT_HOST_CC)" \
		HOST_CFLAGS="$(HOST_CFLAGS)" \
		HOST_LDFLAGS="$(HOST_LDFLAGS)" \
		BUILDMODE=dynamic \
		XCFLAGS=$(LUAJIT_XCFLAGS) \
		-C $(@D) amalg
endef

define LUAJIT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX="/usr" DESTDIR="$(STAGING_DIR)" LDCONFIG=true -C $(@D) install
endef

define LUAJIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) PREFIX="/usr" DESTDIR="$(TARGET_DIR)" LDCONFIG=true -C $(@D) install
endef

define LUAJIT_INSTALL_SYMLINK
	ln -fs luajit $(TARGET_DIR)/usr/bin/lua
endef
LUAJIT_POST_INSTALL_TARGET_HOOKS += LUAJIT_INSTALL_SYMLINK

# host-efl package needs host-luajit to be linked dynamically.
define HOST_LUAJIT_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) PREFIX="$(HOST_DIR)" BUILDMODE=dynamic \
		TARGET_LDFLAGS="$(HOST_LDFLAGS)" \
		XCFLAGS=$(LUAJIT_XCFLAGS) \
		-C $(@D) amalg
endef

define HOST_LUAJIT_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) PREFIX="$(HOST_DIR)" LDCONFIG=true -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
