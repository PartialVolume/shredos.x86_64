################################################################################
#
# libsigrokdecode
#
################################################################################

LIBSIGROKDECODE_VERSION = 0.5.3
LIBSIGROKDECODE_SITE = http://sigrok.org/download/source/libsigrokdecode
LIBSIGROKDECODE_LICENSE = GPL-3.0+
LIBSIGROKDECODE_LICENSE_FILES = COPYING
LIBSIGROKDECODE_INSTALL_STAGING = YES
LIBSIGROKDECODE_DEPENDENCIES = host-pkgconf libglib2 python3
# We're patching configure.ac
LIBSIGROKDECODE_AUTORECONF = YES

$(eval $(autotools-package))
