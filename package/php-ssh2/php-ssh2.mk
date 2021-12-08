################################################################################
#
# php-ssh2
#
################################################################################

PHP_SSH2_VERSION = 1.3.1
PHP_SSH2_SOURCE = ssh2-$(PHP_SSH2_VERSION).tgz
PHP_SSH2_SITE = https://pecl.php.net/get
PHP_SSH2_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-ssh2=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_SSH2_DEPENDENCIES = libssh2 php host-autoconf
PHP_SSH2_LICENSE = PHP-3.01
PHP_SSH2_LICENSE_FILES = LICENSE

define PHP_SSH2_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_SSH2_PRE_CONFIGURE_HOOKS += PHP_SSH2_PHPIZE

$(eval $(autotools-package))
