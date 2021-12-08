################################################################################
#
# ngircd
#
################################################################################

NGIRCD_VERSION = 26.1
NGIRCD_SOURCE = ngircd-$(NGIRCD_VERSION).tar.xz
NGIRCD_SITE = https://arthur.barton.de/pub/ngircd
NGIRCD_LICENSE = GPL-2.0+
NGIRCD_LICENSE_FILES = COPYING
NGIRCD_CPE_ID_VENDOR = barton

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
NGIRCD_CONF_OPTS += --with-pam=$(STAGING_DIR)/usr
NGIRCD_DEPENDENCIES += linux-pam
else
NGIRCD_CONF_OPTS += --without-pam
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NGIRCD_CONF_OPTS += --with-openssl
NGIRCD_DEPENDENCIES += host-pkgconf openssl
else
NGIRCD_CONF_OPTS += --without-openssl
ifeq ($(BR2_PACKAGE_GNUTLS),y)
NGIRCD_CONF_OPTS += --with-gnutls=$(STAGING_DIR)/usr
NGIRCD_DEPENDENCIES += gnutls
else
NGIRCD_CONF_OPTS += --without-gnutls
endif
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
NGIRCD_CONF_OPTS += --with-zlib=$(STAGING_DIR)/usr
NGIRCD_DEPENDENCIES += zlib
else
NGIRCD_CONF_OPTS += --without-zlib
endif

$(eval $(autotools-package))
