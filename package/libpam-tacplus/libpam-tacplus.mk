################################################################################
#
# libpam-tacplus
#
################################################################################

LIBPAM_TACPLUS_VERSION = 1.6.1
LIBPAM_TACPLUS_SITE = $(call github,jeroennijhof,pam_tacplus,v$(LIBPAM_TACPLUS_VERSION))
LIBPAM_TACPLUS_LICENSE = GPL-2.0+
LIBPAM_TACPLUS_LICENSE_FILES = COPYING
LIBPAM_TACPLUS_CPE_ID_VENDOR = pam_tacplus_project
LIBPAM_TACPLUS_CPE_ID_PRODUCT = pam_tacplus
LIBPAM_TACPLUS_DEPENDENCIES = \
	linux-pam \
	$(if $(BR2_PACKAGE_OPENSSL),openssl)
# Fetching from github, we need to generate the configure script
# 0001-Add-an-option-to-disable-Werror.patch
LIBPAM_TACPLUS_AUTORECONF = YES
LIBPAM_TACPLUS_INSTALL_STAGING = YES
LIBPAM_TACPLUS_CONF_ENV = \
	ax_cv_check_cflags___fstack_protector_all=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)
LIBPAM_TACPLUS_CONF_OPTS = --disable-werror

$(eval $(autotools-package))
