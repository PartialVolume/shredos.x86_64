################################################################################
#
# xz
#
################################################################################

XZ_VERSION = 5.2.5
XZ_SOURCE = xz-$(XZ_VERSION).tar.bz2
XZ_SITE = https://tukaani.org/xz
XZ_INSTALL_STAGING = YES
XZ_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
XZ_LICENSE = Public Domain, GPL-2.0+, GPL-3.0+, LGPL-2.1+
XZ_LICENSE_FILES = COPYING COPYING.GPLv2 COPYING.GPLv3 COPYING.LGPLv2.1
XZ_CPE_ID_VENDOR = tukaani

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
XZ_CONF_OPTS = --enable-threads
else
XZ_CONF_OPTS = --disable-threads
endif

# we are built before ccache
HOST_XZ_CONF_ENV = \
	CC="$(HOSTCC_NOCCACHE)" \
	CXX="$(HOSTCXX_NOCCACHE)"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
