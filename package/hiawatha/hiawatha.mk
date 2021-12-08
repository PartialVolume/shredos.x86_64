################################################################################
#
# hiawatha
#
################################################################################

HIAWATHA_VERSION = 10.11
HIAWATHA_SITE = https://www.hiawatha-webserver.org/files
HIAWATHA_DEPENDENCIES = zlib
HIAWATHA_LICENSE = GPL-2.0
HIAWATHA_LICENSE_FILES = LICENSE

HIAWATHA_CONF_OPTS = \
	-DENABLE_TOOLKIT=OFF \
	-DCONFIG_DIR=/etc/hiawatha \
	-DLOG_DIR=/var/log \
	-DPID_DIR=/var/run \
	-DWEBROOT_DIR=/var/www/hiawatha \
	-DWORK_DIR=/var/lib/hiawatha

ifeq ($(BR2_PACKAGE_HIAWATHA_SSL),y)
HIAWATHA_CONF_OPTS += -DUSE_SYSTEM_MBEDTLS=ON
HIAWATHA_DEPENDENCIES += mbedtls
else
HIAWATHA_CONF_OPTS += -DENABLE_TLS=OFF
endif

ifeq ($(BR2_PACKAGE_LIBXSLT),y)
HIAWATHA_CONF_OPTS += -DENABLE_XSLT=ON
HIAWATHA_DEPENDENCIES += libxslt
else
HIAWATHA_CONF_OPTS += -DENABLE_XSLT=OFF
endif

$(eval $(cmake-package))
