################################################################################
#
# luasec
#
################################################################################

LUASEC_VERSION = 1.0-1
LUASEC_SUBDIR = luasec
LUASEC_LICENSE = MIT
LUASEC_LICENSE_FILES = $(LUASEC_SUBDIR)/LICENSE
LUASEC_DEPENDENCIES = openssl

$(eval $(luarocks-package))
