################################################################################
#
# jsoncpp
#
################################################################################

JSONCPP_VERSION = 1.9.4
JSONCPP_SITE = $(call github,open-source-parsers,jsoncpp,$(JSONCPP_VERSION))
JSONCPP_LICENSE = Public Domain or MIT
JSONCPP_LICENSE_FILES = LICENSE
JSONCPP_CPE_ID_VENDOR = jsoncpp_project
JSONCPP_INSTALL_STAGING = YES
JSONCPP_CONF_OPTS = -Dtests=false

$(eval $(meson-package))
