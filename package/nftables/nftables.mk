################################################################################
#
# nftables
#
################################################################################

NFTABLES_VERSION = 0.9.6
NFTABLES_SOURCE = nftables-$(NFTABLES_VERSION).tar.bz2
NFTABLES_SITE = https://www.netfilter.org/projects/nftables/files
NFTABLES_DEPENDENCIES = libmnl libnftnl host-pkgconf $(TARGET_NLS_DEPENDENCIES)
NFTABLES_LICENSE = GPL-2.0
NFTABLES_LICENSE_FILES = COPYING
NFTABLES_CONF_OPTS = --disable-man-doc --disable-pdf-doc
NFTABLES_SELINUX_MODULES = iptables

ifeq ($(BR2_PACKAGE_GMP),y)
NFTABLES_DEPENDENCIES += gmp
NFTABLES_CONF_OPTS += --without-mini-gmp
else
NFTABLES_CONF_OPTS += --with-mini-gmp
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
NFTABLES_DEPENDENCIES += readline
NFTABLES_LIBS += -lncurses
else
NFTABLES_CONF_OPTS += --without-cli
endif

ifeq ($(BR2_PACKAGE_JANSSON),y)
NFTABLES_DEPENDENCIES += jansson
NFTABLES_CONF_OPTS += --with-json
else
NFTABLES_CONF_OPTS += --without-json
endif

ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
NFTABLES_CONF_OPTS += --enable-python
NFTABLES_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON),python,python3)
else
NFTABLES_CONF_OPTS += --disable-python
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_PACKAGE_LIBNFTNL_JSON),yy)
NFTABLES_LIBS += -ljansson -lm
endif

NFTABLES_CONF_ENV = LIBS="$(NFTABLES_LIBS)"

define NFTABLES_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_NETFILTER)
	$(call KCONFIG_ENABLE_OPT,CONFIG_NF_TABLES)
	$(call KCONFIG_ENABLE_OPT,CONFIG_NF_TABLES_INET)
endef

$(eval $(autotools-package))
