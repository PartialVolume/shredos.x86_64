################################################################################
#
# gnupg
#
################################################################################

GNUPG_VERSION = 1.4.23
GNUPG_SOURCE = gnupg-$(GNUPG_VERSION).tar.bz2
GNUPG_SITE = https://gnupg.org/ftp/gcrypt/gnupg
GNUPG_LICENSE = GPL-3.0+
GNUPG_LICENSE_FILES = COPYING
GNUPG_DEPENDENCIES = zlib $(if $(BR2_PACKAGE_LIBICONV),libiconv)
GNUPG_CPE_ID_VENDOR = gnupg
GNUPG_CONF_ENV = ac_cv_sys_symbol_underscore=no
GNUPG_CONF_OPTS = \
	--disable-rpath \
	--enable-minimal \
	--disable-regex \
	--enable-sha256 \
	--enable-sha512

HOST_GNUPG_DEPENDENCIES = host-zlib
HOST_GNUPG_CONF_OPTS = \
	--disable-rpath \
	--enable-minimal \
	--disable-regex \
	--enable-sha256 \
	--enable-sha512 \
	--enable-aes \
	--enable-rsa \
	--without-libcurl \
	--without-readline

# gnupg doesn't support assembly for coldfire
ifeq ($(BR2_m68k_cf),y)
GNUPG_CONF_OPTS += --disable-asm
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
GNUPG_CONF_OPTS += --enable-bzip2
GNUPG_DEPENDENCIES += bzip2
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
GNUPG_CONF_ENV += ac_cv_path__libcurl_config=$(STAGING_DIR)/usr/bin/curl-config
GNUPG_DEPENDENCIES += libcurl
else
GNUPG_CONF_OPTS += --without-libcurl
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
GNUPG_DEPENDENCIES += readline
else
GNUPG_CONF_OPTS += --without-readline
endif

ifeq ($(BR2_PACKAGE_GNUPG_AES),y)
GNUPG_CONF_OPTS += --enable-aes
else
GNUPG_CONF_OPTS += --disable-aes
endif

ifeq ($(BR2_PACKAGE_GNUPG_RSA),y)
GNUPG_CONF_OPTS += --enable-rsa
else
GNUPG_CONF_OPTS += --disable-rsa
endif

ifneq ($(BR2_PACKAGE_GNUPG_GPGV),y)
define GNUPG_REMOVE_GPGV
	rm -f $(TARGET_DIR)/usr/bin/gpgv
endef
GNUPG_POST_INSTALL_TARGET_HOOKS += GNUPG_REMOVE_GPGV
endif

ifneq ($(BR2_PACKAGE_GNUPG_GPGSPLIT),y)
define GNUPG_REMOVE_GPGSPLIT
	rm -f $(TARGET_DIR)/usr/bin/gpgsplit
endef
GNUPG_POST_INSTALL_TARGET_HOOKS += GNUPG_REMOVE_GPGSPLIT
endif

define GNUPG_FIXUP_GPG_ZIP
	test -f $(TARGET_DIR)/usr/bin/gpg-zip && \
		$(SED) 's%^TAR=.*%TAR=/bin/tar%' $(TARGET_DIR)/usr/bin/gpg-zip
endef
GNUPG_POST_INSTALL_TARGET_HOOKS += GNUPG_FIXUP_GPG_ZIP

$(eval $(autotools-package))
$(eval $(host-autotools-package))
