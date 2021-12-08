################################################################################
#
# rsyslog
#
################################################################################

RSYSLOG_VERSION = 8.2010.0
RSYSLOG_SITE = http://rsyslog.com/files/download/rsyslog
RSYSLOG_LICENSE = GPL-3.0, LGPL-3.0, Apache-2.0
RSYSLOG_LICENSE_FILES = COPYING COPYING.LESSER COPYING.ASL20
RSYSLOG_CPE_ID_VENDOR = rsyslog
# rsyslog uses weak permissions for generating log files.
# Ignoring this CVE as Buildroot normally doesn't have local users and a build
# could customize the rsyslog.conf to be more restrictive ($FileCreateMode 0640)
RSYSLOG_IGNORE_CVES += CVE-2015-3243
RSYSLOG_DEPENDENCIES = zlib libestr liblogging libfastjson host-pkgconf
RSYSLOG_CONF_ENV = ac_cv_prog_cc_c99='-std=c99'
RSYSLOG_PLUGINS = imdiag imfile impstats imptcp \
	mmanon mmaudit mmfields mmjsonparse mmpstrucdata mmsequence mmutf8fix \
	mail omprog omruleset omstdout omuxsock \
	pmaixforwardedfrom pmciscoios pmcisconames pmlastmsg pmsnare

ifeq ($(BR2_PACKAGE_LIBRELP),y)
RSYSLOG_DEPENDENCIES += librelp
RSYSLOG_PLUGINS += relp
endif

RSYSLOG_CONF_OPTS = --disable-generate-man-pages \
	$(foreach x,$(call qstrip,$(RSYSLOG_PLUGINS)),--enable-$(x))

# Disable items requiring libcurl
RSYSLOG_CONF_OPTS += --disable-elasticsearch \
	--disable-clickhouse \
	--disable-omhttp \
	--disable-fmhttp \
	--disable-imdocker \
	--disable-omhttpfs \
	--disable-mmkubernetes

ifeq ($(BR2_PACKAGE_CIVETWEB_LIB),y)
RSYSLOG_DEPENDENCIES += civetweb
RSYSLOG_CONF_OPTS += --enable-imhttp
else
RSYSLOG_CONF_OPTS += --disable-imhttp
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
RSYSLOG_DEPENDENCIES += gnutls
RSYSLOG_CONF_OPTS += --enable-gnutls
else
RSYSLOG_CONF_OPTS += --disable-gnutls
endif

ifeq ($(BR2_PACKAGE_LIBEE),y)
RSYSLOG_DEPENDENCIES += libee
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
RSYSLOG_DEPENDENCIES += libgcrypt
RSYSLOG_CONF_ENV += LIBGCRYPT_CONFIG=$(STAGING_DIR)/usr/bin/libgcrypt-config
RSYSLOG_CONF_OPTS += --enable-libgcrypt
else
RSYSLOG_CONF_OPTS += --disable-libgcrypt
endif

ifeq ($(BR2_PACKAGE_LIBPCAP),y)
RSYSLOG_DEPENDENCIES += libpcap
RSYSLOG_CONF_OPTS += --enable-impcap
else
RSYSLOG_CONF_OPTS += --disable-impcap
endif

ifeq ($(BR2_PACKAGE_MYSQL),y)
RSYSLOG_DEPENDENCIES += mysql
RSYSLOG_CONF_OPTS += --enable-mysql
RSYSLOG_CONF_ENV += ac_cv_prog_MYSQL_CONFIG=$(STAGING_DIR)/usr/bin/mysql_config
else
RSYSLOG_CONF_OPTS += --disable-mysql
endif

ifeq ($(BR2_PACKAGE_POSTGRESQL),y)
RSYSLOG_DEPENDENCIES += postgresql
RSYSLOG_CONF_OPTS += --enable-pgsql
RSYSLOG_CONF_ENV += ac_cv_prog_PG_CONFIG=$(STAGING_DIR)/usr/bin/pg_config
else
RSYSLOG_CONF_OPTS += --disable-pgsql
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
RSYSLOG_DEPENDENCIES += util-linux
RSYSLOG_CONF_OPTS += --enable-uuid
else
RSYSLOG_CONF_OPTS += --disable-uuid
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
RSYSLOG_CONF_OPTS += \
	--enable-imjournal \
	--enable-omjournal \
	--with-systemdsystemunitdir=/usr/lib/systemd/system
RSYSLOG_DEPENDENCIES += systemd
else
RSYSLOG_CONF_OPTS += \
	--disable-imjournal \
	--disable-omjournal
endif

define RSYSLOG_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0755 -D package/rsyslog/rsyslog.service \
		$(TARGET_DIR)/usr/lib/systemd/system/rsyslog.service
endef

define RSYSLOG_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/rsyslog/S01rsyslogd \
		$(TARGET_DIR)/etc/init.d/S01rsyslogd
endef

define RSYSLOG_INSTALL_CONF
	$(INSTALL) -m 0644 -D $(@D)/platform/redhat/rsyslog.conf \
		$(TARGET_DIR)/etc/rsyslog.conf
	mkdir -p $(TARGET_DIR)/etc/rsyslog.d
endef

RSYSLOG_POST_INSTALL_TARGET_HOOKS += RSYSLOG_INSTALL_CONF

$(eval $(autotools-package))
