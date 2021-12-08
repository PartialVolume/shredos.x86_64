################################################################################
#
# p7zip
#
################################################################################

P7ZIP_VERSION = 17.04
P7ZIP_SITE = $(call github,jinfeihan57,p7zip,v$(P7ZIP_VERSION))
P7ZIP_LICENSE = LGPL-2.1+ with unRAR restriction
P7ZIP_LICENSE_FILES = DOC/License.txt
P7ZIP_CPE_ID_VENDOR = 7-zip

# p7zip buildsystem is a mess: it plays dirty tricks with CFLAGS and
# CXXFLAGS, so we can't pass them. Instead, it accepts ALLFLAGS_C
# and ALLFLAGS_CPP as variables to pass the CFLAGS and CXXFLAGS.
define P7ZIP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" ALLFLAGS_C="$(TARGET_CFLAGS)" \
		CXX="$(TARGET_CXX)" ALLFLAGS_CPP="$(TARGET_CXXFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" \
		-C $(@D) 7zr
endef

define P7ZIP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/7zr $(TARGET_DIR)/usr/bin/7zr
endef

$(eval $(generic-package))
