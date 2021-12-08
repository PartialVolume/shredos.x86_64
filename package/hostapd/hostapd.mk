################################################################################
#
# hostapd
#
################################################################################

HOSTAPD_VERSION = 2.9
HOSTAPD_SITE = http://w1.fi/releases
HOSTAPD_SUBDIR = hostapd
HOSTAPD_CONFIG = $(HOSTAPD_DIR)/$(HOSTAPD_SUBDIR)/.config
HOSTAPD_PATCH = \
	https://w1.fi/security/2020-1/0001-WPS-UPnP-Do-not-allow-event-subscriptions-with-URLs-.patch \
	https://w1.fi/security/2020-1/0002-WPS-UPnP-Fix-event-message-generation-using-a-long-U.patch \
	https://w1.fi/security/2020-1/0003-WPS-UPnP-Handle-HTTP-initiation-failures-for-events-.patch \
	https://w1.fi/security/2021-1/0001-P2P-Fix-a-corner-case-in-peer-addition-based-on-PD-R.patch
HOSTAPD_DEPENDENCIES = host-pkgconf
HOSTAPD_CFLAGS = $(TARGET_CFLAGS)
HOSTAPD_LICENSE = BSD-3-Clause
HOSTAPD_LICENSE_FILES = README

# 0001-AP-Silently-ignore-management-frame-from-unexpected-.patch
HOSTAPD_IGNORE_CVES += CVE-2019-16275

# 0001-WPS-UPnP-Do-not-allow-event-subscriptions-with-URLs-.patch
HOSTAPD_IGNORE_CVES += CVE-2020-12695

# 0002-ASN.1-Validate-DigestAlgorithmIdentifier-parameters.patch
HOSTAPD_IGNORE_CVES += CVE-2021-30004

# 0001-P2P-Fix-a-corner-case-in-peer-addition-based-on-PD-R.patch
HOSTAPD_IGNORE_CVES += CVE-2021-27803

HOSTAPD_CPE_ID_VENDOR = w1.fi
HOSTAPD_CONFIG_SET =

HOSTAPD_CONFIG_ENABLE = \
	CONFIG_INTERNAL_LIBTOMMATH \
	CONFIG_DEBUG_FILE \
	CONFIG_DEBUG_SYSLOG

HOSTAPD_CONFIG_DISABLE =

# Try to use openssl if it's already available
ifeq ($(BR2_PACKAGE_LIBOPENSSL),y)
HOSTAPD_DEPENDENCIES += host-pkgconf libopenssl
HOSTAPD_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs openssl`
HOSTAPD_CONFIG_EDITS += 's/\#\(CONFIG_TLS=openssl\)/\1/'
else
HOSTAPD_CONFIG_DISABLE += CONFIG_EAP_PWD CONFIG_EAP_TEAP
HOSTAPD_CONFIG_EDITS += 's/\#\(CONFIG_TLS=\).*/\1internal/'
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_HOSTAP),)
HOSTAPD_CONFIG_DISABLE += CONFIG_DRIVER_HOSTAP
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_NL80211),)
HOSTAPD_CONFIG_DISABLE += CONFIG_DRIVER_NL80211
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_WIRED),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_DRIVER_WIRED
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_DRIVER_NONE),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_DRIVER_NONE
endif

# Add options for wireless drivers
ifeq ($(BR2_PACKAGE_HOSTAPD_HAS_WIFI_DRIVERS),y)
HOSTAPD_CONFIG_ENABLE += \
	CONFIG_HS20 \
	CONFIG_IEEE80211AC \
	CONFIG_IEEE80211N \
	CONFIG_IEEE80211R \
	CONFIG_INTERWORKING
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_ACS),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_ACS
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_EAP),y)
HOSTAPD_CONFIG_ENABLE += \
	CONFIG_EAP \
	CONFIG_RADIUS_SERVER

# Enable both TLS v1.1 (CONFIG_TLSV11) and v1.2 (CONFIG_TLSV12)
HOSTAPD_CONFIG_ENABLE += CONFIG_TLSV1
else
HOSTAPD_CONFIG_DISABLE += CONFIG_EAP
HOSTAPD_CONFIG_ENABLE += \
	CONFIG_NO_ACCOUNTING \
	CONFIG_NO_RADIUS
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_WPS),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_WPS
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_WPA3),y)
HOSTAPD_CONFIG_SET += \
	CONFIG_DPP \
	CONFIG_SAE
HOSTAPD_CONFIG_ENABLE += \
	CONFIG_OWE
else
HOSTAPD_CONFIG_DISABLE += \
	CONFIG_OWE
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_VLAN),)
HOSTAPD_CONFIG_ENABLE += CONFIG_NO_VLAN
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_VLAN_DYNAMIC),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_FULL_DYNAMIC_VLAN
HOSTAPD_CONFIG_SET += NEED_LINUX_IOCTL
endif

ifeq ($(BR2_PACKAGE_HOSTAPD_VLAN_NETLINK),y)
HOSTAPD_CONFIG_ENABLE += CONFIG_VLAN_NETLINK
endif

# Options for building with libnl
ifeq ($(BR2_PACKAGE_LIBNL),y)
HOSTAPD_DEPENDENCIES += libnl
HOSTAPD_CFLAGS += -I$(STAGING_DIR)/usr/include/libnl3/
HOSTAPD_CONFIG_ENABLE += CONFIG_LIBNL32
# libnl-3 needs -lm (for rint) and -lpthread if linking statically
# And library order matters hence stick -lnl-3 first since it's appended
# in the hostapd Makefiles as in LIBS+=-lnl-3 ... thus failing
ifeq ($(BR2_STATIC_LIBS),y)
HOSTAPD_LIBS += -lnl-3 -lm -lpthread
endif
endif

define HOSTAPD_CONFIGURE_CMDS
	cp $(@D)/hostapd/defconfig $(HOSTAPD_CONFIG)
	sed -i $(patsubst %,-e 's/^#\(%\)/\1/',$(HOSTAPD_CONFIG_ENABLE)) \
		$(patsubst %,-e 's/^\(%\)/#\1/',$(HOSTAPD_CONFIG_DISABLE)) \
		$(patsubst %,-e '1i%=y',$(HOSTAPD_CONFIG_SET)) \
		$(patsubst %,-e %,$(HOSTAPD_CONFIG_EDITS)) \
		$(HOSTAPD_CONFIG)
endef

define HOSTAPD_BUILD_CMDS
	$(TARGET_MAKE_ENV) CFLAGS="$(HOSTAPD_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" LIBS="$(HOSTAPD_LIBS)" \
		$(MAKE) CC="$(TARGET_CC)" -C $(@D)/$(HOSTAPD_SUBDIR)
endef

define HOSTAPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd \
		$(TARGET_DIR)/usr/sbin/hostapd
	$(INSTALL) -m 0755 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd_cli \
		$(TARGET_DIR)/usr/bin/hostapd_cli
	$(INSTALL) -m 0644 -D $(@D)/$(HOSTAPD_SUBDIR)/hostapd.conf \
		$(TARGET_DIR)/etc/hostapd.conf
endef

$(eval $(generic-package))
