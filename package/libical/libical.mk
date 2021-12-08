################################################################################
#
# libical
#
################################################################################

LIBICAL_VERSION = 1.0.1
LIBICAL_SITE = https://github.com/libical/libical/releases/download/v$(LIBICAL_VERSION)
LIBICAL_INSTALL_STAGING = YES
LIBICAL_LICENSE = MPL-1.0 or LGPL-2.1
LIBICAL_LICENSE_FILES = LICENSE
LIBICAL_CPE_ID_VENDOR = libical_project

# 0002-icaltypes-c-icalreqstattype_from_string-copy-the-reqstattype.patch
LIBICAL_IGNORE_CVES += CVE-2016-9584

# building without this option is broken, it is used by
# Gentoo/alpinelinux as well
LIBICAL_CONF_OPTS = -DSHARED_ONLY=true
# never build time zone info, always use system's tzinfo
LIBICAL_CONF_OPTS += -DUSE_BUILTIN_TZDATA=false

$(eval $(cmake-package))
