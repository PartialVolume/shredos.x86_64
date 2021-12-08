################################################################################
#
# zeromq
#
################################################################################

ZEROMQ_VERSION = 4.3.4
ZEROMQ_SITE = https://github.com/zeromq/libzmq/releases/download/v$(ZEROMQ_VERSION)
ZEROMQ_INSTALL_STAGING = YES
ZEROMQ_DEPENDENCIES = util-linux
ZEROMQ_CONF_OPTS = --disable-Werror --without-documentation
ZEROMQ_LICENSE = LGPL-3.0+ with exceptions
ZEROMQ_LICENSE_FILES = COPYING COPYING.LESSER
ZEROMQ_CPE_ID_VENDOR = zeromq
ZEROMQ_CPE_ID_PRODUCT = libzmq

# Assume these flags are always available. It is true, at least for
# SOCK_CLOEXEC, since linux v2.6.27.
# Note: the flag TCP_KEEPALIVE is NOT available so we do not include it.
ZEROMQ_CONF_ENV = libzmq_cv_sock_cloexec=yes \
	libzmq_cv_so_keepalive=yes \
	libzmq_cv_tcp_keepcnt=yes \
	libzmq_cv_tcp_keepidle=yes \
	libzmq_cv_tcp_keepintvl=yes

# Internal error, aborting at dwarf2cfi.c:2752 in connect_traces
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58864
ifeq ($(BR2_m68k_cf),y)
ZEROMQ_CONF_OPTS += CXXFLAGS="$(TARGET_CXXFLAGS) -fno-defer-pop"
endif

# Only tools/curve_keygen.c needs this, but it doesn't hurt to pass it
# for the rest of the build as well (which automatically includes stdc++).
ifeq ($(BR2_STATIC_LIBS),y)
ZEROMQ_CONF_OPTS += LIBS=-lstdc++
endif

ifeq ($(BR2_PACKAGE_ZEROMQ_NORM),y)
ZEROMQ_CONF_OPTS += --with-norm
ZEROMQ_DEPENDENCIES += norm
else
ZEROMQ_CONF_OPTS += --without-norm
endif

ifeq ($(BR2_PACKAGE_ZEROMQ_PGM),y)
ZEROMQ_DEPENDENCIES += host-pkgconf openpgm
ZEROMQ_CONF_OPTS += --with-pgm
else
ZEROMQ_CONF_OPTS += --without-pgm
endif

ifeq ($(BR2_PACKAGE_ZEROMQ_DRAFTS),y)
ZEROMQ_CONF_OPTS += --enable-drafts
else
ZEROMQ_CONF_OPTS += --disable-drafts
endif

ifeq ($(BR2_PACKAGE_ZEROMQ_WEBSOCKET),y)
ZEROMQ_CONF_OPTS += --enable-ws
else
ZEROMQ_CONF_OPTS += --disable-ws
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
ZEROMQ_DEPENDENCIES += host-pkgconf gnutls
ZEROMQ_CONF_OPTS += --with-tls
else
ZEROMQ_CONF_OPTS += --without-tls
endif

ifeq ($(BR2_PACKAGE_LIBBSD),y)
ZEROMQ_DEPENDENCIES += host-pkgconf libbsd
ZEROMQ_CONF_OPTS += --enable-libbsd
else
ZEROMQ_CONF_OPTS += --disable-libbsd
endif

ifeq ($(BR2_PACKAGE_LIBNSS),y)
ZEROMQ_DEPENDENCIES += host-pkgconf libnss
ZEROMQ_CONF_OPTS += --with-nss
else
ZEROMQ_CONF_OPTS += --without-nss
endif

# ZeroMQ uses libsodium if it's available.
ifeq ($(BR2_PACKAGE_LIBSODIUM),y)
ZEROMQ_DEPENDENCIES += libsodium
ZEROMQ_CONF_OPTS += --with-libsodium="$(STAGING_DIR)/usr"
else
ZEROMQ_CONF_OPTS += --without-libsodium
endif

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
ZEROMQ_DEPENDENCIES += libunwind
ZEROMQ_CONF_OPTS += --enable-libunwind
else
ZEROMQ_CONF_OPTS += --disable-libunwind
endif

$(eval $(autotools-package))
