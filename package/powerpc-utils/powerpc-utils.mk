################################################################################
#
# powerpc-utils
#
################################################################################

POWERPC_UTILS_VERSION = 1.3.8
POWERPC_UTILS_SITE = $(call github,ibm-power-utilities,powerpc-utils,v$(POWERPC_UTILS_VERSION))
POWERPC_UTILS_DEPENDENCIES = zlib
POWERPC_UTILS_AUTORECONF = YES
POWERPC_UTILS_LICENSE = GPL-2.0+
POWERPC_UTILS_LICENSE_FILES = COPYING
POWERPC_UTILS_CPE_ID_VENDOR = powerpc-utils_project

POWERPC_UTILS_CONF_ENV = \
	ax_cv_check_cflags___fstack_protector_all=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)
POWERPC_UTILS_CONF_OPTS = --disable-werror

ifeq ($(BR2_PACKAGE_POWERPC_UTILS_RTAS),y)
POWERPC_UTILS_DEPENDENCIES += librtas
POWERPC_UTILS_CONF_OPTS += --with-librtas
else
POWERPC_UTILS_CONF_OPTS += --without-librtas
endif

$(eval $(autotools-package))
