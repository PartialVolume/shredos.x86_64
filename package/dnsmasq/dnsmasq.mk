################################################################################
#
# dnsmasq
#
################################################################################

DNSMASQ_VERSION = 2.85
DNSMASQ_SOURCE = dnsmasq-$(DNSMASQ_VERSION).tar.xz
DNSMASQ_SITE = http://thekelleys.org.uk/dnsmasq
DNSMASQ_MAKE_ENV = $(TARGET_MAKE_ENV) CC="$(TARGET_CC)"
DNSMASQ_MAKE_OPTS = COPTS="$(DNSMASQ_COPTS)" PREFIX=/usr CFLAGS="$(TARGET_CFLAGS)"
DNSMASQ_MAKE_OPTS += DESTDIR=$(TARGET_DIR) LDFLAGS="$(TARGET_LDFLAGS)" \
	LIBS+=$(TARGET_NLS_LIBS)
DNSMASQ_DEPENDENCIES = host-pkgconf $(TARGET_NLS_DEPENDENCIES)
DNSMASQ_LICENSE = GPL-2.0 or GPL-3.0
DNSMASQ_LICENSE_FILES = COPYING COPYING-v3
DNSMASQ_CPE_ID_VENDOR = thekelleys
DNSMASQ_SELINUX_MODULES = dnsmasq

DNSMASQ_I18N = $(if $(BR2_SYSTEM_ENABLE_NLS),-i18n)

ifneq ($(BR2_PACKAGE_DNSMASQ_DHCP),y)
DNSMASQ_COPTS += -DNO_DHCP
endif

ifeq ($(BR2_PACKAGE_DNSMASQ_DNSSEC),y)
DNSMASQ_DEPENDENCIES += gmp nettle
DNSMASQ_COPTS += -DHAVE_DNSSEC
ifeq ($(BR2_STATIC_LIBS),y)
DNSMASQ_COPTS += -DHAVE_DNSSEC_STATIC
endif
endif

ifneq ($(BR2_PACKAGE_DNSMASQ_TFTP),y)
DNSMASQ_COPTS += -DNO_TFTP
endif

ifeq ($(BR2_PACKAGE_DNSMASQ_IDN),y)
ifeq ($(BR2_PACKAGE_LIBIDN2),y)
DNSMASQ_DEPENDENCIES += libidn2
DNSMASQ_COPTS += -DHAVE_LIBIDN2
else
DNSMASQ_DEPENDENCIES += libidn
DNSMASQ_COPTS += -DHAVE_IDN
endif
endif

ifeq ($(BR2_PACKAGE_DNSMASQ_CONNTRACK),y)
DNSMASQ_DEPENDENCIES += libnetfilter_conntrack
DNSMASQ_COPTS += -DHAVE_CONNTRACK
endif

ifeq ($(BR2_PACKAGE_DNSMASQ_LUA),y)
DNSMASQ_DEPENDENCIES += lua
DNSMASQ_COPTS += -DHAVE_LUASCRIPT

# liblua uses dlopen when dynamically linked
ifneq ($(BR2_STATIC_LIBS),y)
DNSMASQ_MAKE_OPTS += LIBS+="-ldl"
endif

define DNSMASQ_TWEAK_LIBLUA
	$(SED) 's/lua5.2/lua/g' $(DNSMASQ_DIR)/Makefile
endef
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
DNSMASQ_DEPENDENCIES += dbus
DNSMASQ_COPTS += -DHAVE_DBUS

define DNSMASQ_INSTALL_DBUS
	$(INSTALL) -m 0644 -D $(@D)/dbus/dnsmasq.conf \
		$(TARGET_DIR)/etc/dbus-1/system.d/dnsmasq.conf
endef
endif

ifeq ($(BR2_PACKAGE_UBUS),y)
DNSMASQ_DEPENDENCIES += ubus
DNSMASQ_COPTS += -DHAVE_UBUS
endif

define DNSMASQ_BUILD_CMDS
	$(DNSMASQ_TWEAK_LIBLUA)
	$(DNSMASQ_MAKE_ENV) $(MAKE) -C $(@D) $(DNSMASQ_MAKE_OPTS) all$(DNSMASQ_I18N)
endef

define DNSMASQ_INSTALL_TARGET_CMDS
	$(DNSMASQ_MAKE_ENV) $(MAKE) -C $(@D) $(DNSMASQ_MAKE_OPTS) install$(DNSMASQ_I18N)
	mkdir -p $(TARGET_DIR)/var/lib/misc/
	$(DNSMASQ_INSTALL_DBUS)
endef

define DNSMASQ_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/dnsmasq/S80dnsmasq \
		$(TARGET_DIR)/etc/init.d/S80dnsmasq
endef

$(eval $(generic-package))
