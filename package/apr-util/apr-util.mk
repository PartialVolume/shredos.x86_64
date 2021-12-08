################################################################################
#
# apr-util
#
################################################################################

APR_UTIL_VERSION = 1.6.1
APR_UTIL_SOURCE = apr-util-$(APR_UTIL_VERSION).tar.bz2
APR_UTIL_SITE = http://archive.apache.org/dist/apr
APR_UTIL_LICENSE = Apache-2.0
APR_UTIL_LICENSE_FILES = LICENSE
APR_UTIL_CPE_ID_VENDOR = apache
APR_UTIL_CPE_ID_PRODUCT = portable_runtime_utility
APR_UTIL_INSTALL_STAGING = YES
APR_UTIL_DEPENDENCIES = apr expat
APR_UTIL_CONF_OPTS = \
	--with-apr=$(STAGING_DIR)/usr/bin/apr-1-config
APR_UTIL_CONFIG_SCRIPTS = apu-1-config

ifeq ($(BR2_PER_PACKAGE_DIRECTORIES),y)
define APR_UTIL_FIX_LIBTOOL
	$(SED) 's,$(PER_PACKAGE_DIR)/apr/,$(PER_PACKAGE_DIR)/apr-util/,g' \
		$(STAGING_DIR)/usr/build-1/libtool
endef
APR_UTIL_POST_PREPARE_HOOKS += APR_UTIL_FIX_LIBTOOL

define APR_UTIL_FIX_RULES_MK
	$(SED) 's,$(PER_PACKAGE_DIR)/apr/,$(PER_PACKAGE_DIR)/apr-util/,g' \
		$(@D)/build/rules.mk
endef
APR_UTIL_POST_CONFIGURE_HOOKS += APR_UTIL_FIX_RULES_MK
endif

# When iconv is available, then use it to provide charset conversion
# features.
APR_UTIL_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
APR_UTIL_CONF_OPTS += --with-dbm=db53 --with-berkeley-db="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += berkeleydb
else
APR_UTIL_CONF_OPTS += --without-berkeley-db
endif

ifeq ($(BR2_PACKAGE_GDBM),y)
APR_UTIL_CONF_OPTS += --with-gdbm="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += gdbm
else
APR_UTIL_CONF_OPTS += --without-gdbm
endif

ifeq ($(BR2_PACKAGE_MYSQL),y)
APR_UTIL_CONF_OPTS += --with-mysql="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += mysql
else
APR_UTIL_CONF_OPTS += --without-mysql
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
APR_UTIL_CONF_OPTS += --with-sqlite3="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += sqlite
else
APR_UTIL_CONF_OPTS += --without-sqlite3
endif

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
APR_UTIL_CONF_ENV += ac_cv_ldap_set_rebind_proc_style=three
APR_UTIL_CONF_OPTS += \
	--with-ldap \
	--with-ldap-include="$(STAGING_DIR)/usr/include/" \
	--with-ldap-lib="$(STAGING_DIR)/usr/lib"
APR_UTIL_DEPENDENCIES += openldap
else
APR_UTIL_CONF_OPTS += --without-ldap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
APR_UTIL_CONF_OPTS += --with-crypto --with-openssl="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += openssl
else
APR_UTIL_CONF_OPTS += --without-crypto
endif

ifeq ($(BR2_PACKAGE_POSTGRESQL),y)
APR_UTIL_CONF_OPTS += --with-pgsql="$(STAGING_DIR)/usr"
APR_UTIL_DEPENDENCIES += postgresql
else
APR_UTIL_CONF_OPTS += --without-pgsql
endif

ifeq ($(BR2_PACKAGE_UNIXODBC),y)
APR_UTIL_CONF_OPTS += --with-odbc="$(STAGING_DIR)/usr"
# avoid using target binary $(STAGING_DIR)/usr/bin/odbc_config
APR_UTIL_CONF_ENV += ac_cv_path_ODBC_CONFIG=""
APR_UTIL_DEPENDENCIES += unixodbc
else
APR_UTIL_CONF_OPTS += --without-odbc
endif

$(eval $(autotools-package))
