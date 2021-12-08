################################################################################
#
# log4cxx
#
################################################################################

LOG4CXX_VERSION = 0.11.0
LOG4CXX_SITE = http://archive.apache.org/dist/logging/log4cxx/$(LOG4CXX_VERSION)
LOG4CXX_SOURCE = apache-log4cxx-$(LOG4CXX_VERSION).tar.gz
LOG4CXX_INSTALL_STAGING = YES
LOG4CXX_LICENSE = Apache-2.0
LOG4CXX_LICENSE_FILES = LICENSE
# error: required file './compile' not found
LOG4CXX_AUTORECONF = YES

LOG4CXX_CONF_OPTS = \
	--with-apr=$(STAGING_DIR)/usr/bin/apr-1-config \
	--with-apr-util=$(STAGING_DIR)/usr/bin/apu-1-config \
	--disable-dot \
	--disable-doxygen \
	--disable-html-docs

LOG4CXX_DEPENDENCIES = apr apr-util

$(eval $(autotools-package))
