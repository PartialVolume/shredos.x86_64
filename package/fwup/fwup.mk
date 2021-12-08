################################################################################
#
# fwup
#
################################################################################

FWUP_VERSION = 1.8.0
FWUP_SITE = $(call github,fhunleth,fwup,v$(FWUP_VERSION))
FWUP_LICENSE = Apache-2.0
FWUP_LICENSE_FILES = LICENSE
FWUP_DEPENDENCIES = host-pkgconf libconfuse libarchive
HOST_FWUP_DEPENDENCIES = host-pkgconf host-libconfuse host-libarchive
FWUP_AUTORECONF = YES
FWUP_CONF_ENV = ac_cv_path_HELP2MAN=""

$(eval $(autotools-package))
$(eval $(host-autotools-package))
