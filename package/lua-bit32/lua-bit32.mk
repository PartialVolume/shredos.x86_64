################################################################################
#
# lua-bit32
#
################################################################################

LUA_BIT32_VERSION = 5.3.5.1-1
LUA_BIT32_NAME_UPSTREAM = bit32
LUA_BIT32_SUBDIR = lua-compat-5.3-0.10
LUA_BIT32_LICENSE = MIT
LUA_BIT32_LICENSE_FILES = $(LUA_BIT32_SUBDIR)/LICENSE

$(eval $(luarocks-package))
