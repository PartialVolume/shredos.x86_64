################################################################################
#
# gensio
#
################################################################################

GENSIO_VERSION = 2.2.4
GENSIO_SITE = http://downloads.sourceforge.net/project/ser2net/ser2net
GENSIO_LICENSE = LGPL-2.1+ (library), GPL-2.0+ (tools)
GENSIO_LICENSE_FILES = COPYING.LIB COPYING
GENSIO_INSTALL_STAGING = YES
GENSIO_CONF_OPTS = \
	--without-openipmi \
	--without-swig \
	--without-python

ifeq ($(BR2_PACKAGE_OPENSSL),y)
GENSIO_DEPENDENCIES += host-pkgconf openssl
GENSIO_CONF_OPTS += --with-openssl
else
GENSIO_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GENSIO_CONF_ENV += LIBS=-latomic
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
GENSIO_CONF_OPTS += --with-pthreads
else
GENSIO_CONF_OPTS += --without-pthreads
endif

$(eval $(autotools-package))
