################################################################################
#
# libgpgme
#
################################################################################

LIBGPGME_VERSION = 1.15.1
LIBGPGME_SITE = https://gnupg.org/ftp/gcrypt/gpgme
LIBGPGME_SOURCE = gpgme-$(LIBGPGME_VERSION).tar.bz2
LIBGPGME_LICENSE = LGPL-2.1+
LIBGPGME_LICENSE_FILES = COPYING.LESSER
LIBGPGME_CPE_ID_VENDOR = gnupg
LIBGPGME_CPE_ID_PRODUCT = gpgpme
LIBGPGME_INSTALL_STAGING = YES
LIBGPGME_DEPENDENCIES = libassuan libgpg-error
LIBGPGME_CONFIG_SCRIPTS = gpgme-config

LIBGPGME_LANGUAGE_BINDINGS = cl
# C++ bindings require a C++11 capable gcc, and -Wsuggest-override support
ifeq ($(BR2_INSTALL_LIBSTDCPP)$(BR2_TOOLCHAIN_GCC_AT_LEAST_5),yy)
LIBGPGME_LANGUAGE_BINDINGS += cpp
endif

LIBGPGME_CONF_OPTS = \
	--with-gpg-error-prefix=$(STAGING_DIR)/usr \
	--with-libassuan-prefix=$(STAGING_DIR)/usr \
	--disable-gpgsm-test \
	--disable-gpgconf-test \
	--disable-g13-test \
	--disable-gpg-test \
	--enable-languages=$(subst $(space),$(comma),$(LIBGPGME_LANGUAGE_BINDINGS))

# Handle argp-standalone or it errors out during build
ifeq ($(BR2_PACKAGE_ARGP_STANDALONE),y)
# musl libc does not define error_t in errno.h, but argp.h does.
# Assume we have error_t to avoid collision with the argp.h error_t.
LIBGPGME_CONF_ENV += LIBS="-largp" ac_cv_type_error_t=yes
LIBGPGME_DEPENDENCIES += argp-standalone
endif

# MIPS N64 (re)introduced getdents64 in kernel version 3.10
ifeq ($(BR2_MIPS_NABI64)x$(BR2_TOOLCHAIN_HEADERS_AT_LEAST_3_10),yx)
LIBGPGME_CONF_OPTS += --disable-linux-getdents
endif

$(eval $(autotools-package))
