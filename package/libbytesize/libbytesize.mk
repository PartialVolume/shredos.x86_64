################################################################################
#
# libbytesize
#
################################################################################

LIBBYTESIZE_VERSION = 2.5
LIBBYTESIZE_SITE = https://github.com/storaged-project/libbytesize/releases/download/$(LIBBYTESIZE_VERSION)
LIBBYTESIZE_LICENSE = LGPL-2.1+
LIBBYTESIZE_LICENSE_FILES = LICENSE
LIBBYTESIZE_INSTALL_STAGING = YES

LIBBYTESIZE_DEPENDENCIES = \
	host-pkgconf \
	host-gettext \
	gmp \
	mpfr \
	pcre2

LIBBYTESIZE_CONF_OPTS += \
	--without-python3 \
	--without-tools

$(eval $(autotools-package))
