################################################################################
#
# pax-utils
#
################################################################################

PAX_UTILS_VERSION = 1.2.6
PAX_UTILS_SITE = http://distfiles.gentoo.org/distfiles
PAX_UTILS_SOURCE = pax-utils-$(PAX_UTILS_VERSION).tar.xz
PAX_UTILS_LICENSE = GPL-2.0
PAX_UTILS_LICENSE_FILES = COPYING
PAX_UTILS_CPE_ID_VENDOR = gentoo

PAX_UTILS_DEPENDENCIES = host-pkgconf
PAX_UTILS_CONF_OPTS = --without-python

ifeq ($(BR2_PACKAGE_LIBCAP),y)
PAX_UTILS_DEPENDENCIES += libcap
PAX_UTILS_CONF_OPTS += --with-caps
else
PAX_UTILS_CONF_OPTS += --without-caps
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
PAX_UTILS_DEPENDENCIES += libseccomp
PAX_UTILS_CONF_OPTS += --with-seccomp
else
PAX_UTILS_CONF_OPTS += --without-seccomp
endif

# lddtree and symtree need bash
ifeq ($(BR2_PACKAGE_BASH),)
define PAX_UTILS_REMOVE_BASH_TOOLS
	rm -f $(TARGET_DIR)/usr/bin/{lddtree,symtree}
endef
endif
PAX_UTILS_POST_INSTALL_TARGET_HOOKS += PAX_UTILS_REMOVE_BASH_TOOLS

$(eval $(autotools-package))
$(eval $(host-autotools-package))
