################################################################################
#
# php-imagick
#
################################################################################

PHP_IMAGICK_VERSION = 3.5.0
PHP_IMAGICK_SOURCE = imagick-$(PHP_IMAGICK_VERSION).tgz
PHP_IMAGICK_SITE = http://pecl.php.net/get
PHP_IMAGICK_CONF_OPTS = --with-php-config=$(STAGING_DIR)/usr/bin/php-config \
	--with-imagick=$(STAGING_DIR)/usr
# phpize does the autoconf magic
PHP_IMAGICK_DEPENDENCIES = imagemagick php host-autoconf
PHP_IMAGICK_LICENSE = PHP-3.01
PHP_IMAGICK_LICENSE_FILES = LICENSE
PHP_IMAGICK_CPE_ID_VENDOR = php
PHP_IMAGICK_CPE_ID_PRODUCT = imagick

define PHP_IMAGICK_PHPIZE
	(cd $(@D); \
		PHP_AUTOCONF=$(HOST_DIR)/bin/autoconf \
		PHP_AUTOHEADER=$(HOST_DIR)/bin/autoheader \
		$(STAGING_DIR)/usr/bin/phpize)
endef

PHP_IMAGICK_PRE_CONFIGURE_HOOKS += PHP_IMAGICK_PHPIZE

$(eval $(autotools-package))
