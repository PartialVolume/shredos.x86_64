################################################################################
#
# shellinabox
#
################################################################################

SHELLINABOX_VERSION = 2.20
SHELLINABOX_SITE = $(call github,shellinabox,shellinabox,v$(SHELLINABOX_VERSION))
SHELLINABOX_LICENSE = GPL-2.0 with OpenSSL exception
SHELLINABOX_LICENSE_FILES = COPYING GPL-2
SHELLINABOX_CPE_ID_VENDOR = shellinabox_project

# 0002-CVE-2018-16789-fix-for-broken-multipart-form-data.patch
SHELLINABOX_IGNORE_CVES += CVE-2018-16789

# Fetching from Github, and patching Makefile.am, so we need to autoreconf
SHELLINABOX_AUTORECONF = YES

# The OpenSSL support is supposed to be optional, but in practice,
# with OpenSSL disabled, it fails to build. See
# https://github.com/shellinabox/shellinabox/issues/385.
SHELLINABOX_DEPENDENCIES = zlib openssl
SHELLINABOX_CONF_OPTS = \
	--disable-runtime-loading \
	--enable-ssl

# musl's implementation of utmpx is a dummy one, and some aspects of
# it cause build failures in shellinabox
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
SHELLINABOX_CONF_OPTS += --disable-utmp
endif

$(eval $(autotools-package))
