################################################################################
#
# pulseview
#
################################################################################

PULSEVIEW_VERSION = 0.4.2
PULSEVIEW_SITE = http://sigrok.org/download/source/pulseview
PULSEVIEW_LICENSE = GPL-3.0+
PULSEVIEW_LICENSE_FILES = COPYING
PULSEVIEW_DEPENDENCIES = libsigrok qt5base qt5svg qt5tools boost
PULSEVIEW_CONF_OPTS = -DDISABLE_WERROR=TRUE

ifeq ($(BR2_PACKAGE_BOOST_TEST),y)
PULSEVIEW_CONF_OPTS += -DENABLE_TESTS=TRUE
else
PULSEVIEW_CONF_OPTS += -DENABLE_TESTS=FALSE
endif

ifeq ($(BR2_PACKAGE_LIBSIGROKDECODE),y)
PULSEVIEW_CONF_OPTS += -DENABLE_DECODE=TRUE
PULSEVIEW_DEPENDENCIES += libsigrokdecode
else
PULSEVIEW_CONF_OPTS += -DENABLE_DECODE=FALSE
endif

$(eval $(cmake-package))
