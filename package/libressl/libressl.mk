################################################################################
#
# libressl
#
################################################################################

LIBRESSL_VERSION = 3.3.5
LIBRESSL_SITE = https://ftp.openbsd.org/pub/OpenBSD/LibreSSL
LIBRESSL_LICENSE = ISC (new additions), OpenSSL or SSLeay (original OpenSSL code)
LIBRESSL_LICENSE_FILES = COPYING
LIBRESSL_CPE_ID_VENDOR = openbsd
LIBRESSL_INSTALL_STAGING = YES
LIBRESSL_CONF_OPTS = -DOPENSSLDIR="/etc/ssl"

ifeq ($(BR2_PACKAGE_LIBRESSL_BIN),)
define LIBRESSL_REMOVE_BIN
	$(RM) -f $(TARGET_DIR)/usr/bin/openssl
endef
LIBRESSL_POST_INSTALL_TARGET_HOOKS += LIBRESSL_REMOVE_BIN
endif

$(eval $(cmake-package))
