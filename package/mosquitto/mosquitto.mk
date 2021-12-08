################################################################################
#
# mosquitto
#
################################################################################

MOSQUITTO_VERSION = 2.0.12
MOSQUITTO_SITE = https://mosquitto.org/files/source
MOSQUITTO_LICENSE = EPL-2.0 or EDLv1.0
MOSQUITTO_LICENSE_FILES = LICENSE.txt epl-v20 edl-v10
MOSQUITTO_CPE_ID_VENDOR = eclipse
MOSQUITTO_INSTALL_STAGING = YES

MOSQUITTO_MAKE_OPTS = \
	CLIENT_STATIC_LDADD="$(MOSQUITTO_STATIC_LIBS)" \
	UNAME=Linux \
	STRIP=true \
	prefix=/usr \
	WITH_WRAP=no \
	WITH_DOCS=no

ifeq ($(BR2_SHARED_LIBS),y)
MOSQUITTO_MAKE_OPTS += WITH_STATIC_LIBRARIES=no
else
MOSQUITTO_MAKE_OPTS += WITH_STATIC_LIBRARIES=yes
endif

ifeq ($(BR2_STATIC_LIBS),y)
MOSQUITTO_MAKE_OPTS += WITH_SHARED_LIBRARIES=no
else
MOSQUITTO_MAKE_OPTS += WITH_SHARED_LIBRARIES=yes
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
MOSQUITTO_MAKE_OPTS += WITH_SYSTEMD=yes
MOSQUITTO_DEPENDENCIES += systemd
endif

# adns uses getaddrinfo_a
ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),y)
MOSQUITTO_MAKE_OPTS += WITH_ADNS=yes
else
MOSQUITTO_MAKE_OPTS += WITH_ADNS=no
endif

# threaded API uses pthread_setname_np
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS_NPTL),y)
MOSQUITTO_MAKE_OPTS += WITH_THREADING=yes
else
MOSQUITTO_MAKE_OPTS += WITH_THREADING=no
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MOSQUITTO_DEPENDENCIES += host-pkgconf openssl
MOSQUITTO_MAKE_OPTS += WITH_TLS=yes
MOSQUITTO_STATIC_LIBS += `$(PKG_CONFIG_HOST_BINARY) --libs openssl`
else
MOSQUITTO_MAKE_OPTS += WITH_TLS=no
endif

ifeq ($(BR2_PACKAGE_CJSON),y)
MOSQUITTO_DEPENDENCIES += cjson
MOSQUITTO_MAKE_OPTS += WITH_CJSON=yes
MOSQUITTO_STATIC_LIBS += -lcjson
else
MOSQUITTO_MAKE_OPTS += WITH_CJSON=no
endif

ifeq ($(BR2_PACKAGE_C_ARES),y)
MOSQUITTO_DEPENDENCIES += c-ares
MOSQUITTO_MAKE_OPTS += WITH_SRV=yes
else
MOSQUITTO_MAKE_OPTS += WITH_SRV=no
endif

ifeq ($(BR2_PACKAGE_LIBWEBSOCKETS),y)
MOSQUITTO_DEPENDENCIES += libwebsockets
MOSQUITTO_MAKE_OPTS += WITH_WEBSOCKETS=yes
else
MOSQUITTO_MAKE_OPTS += WITH_WEBSOCKETS=no
endif

# C++ support is only used to create a wrapper library
ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
define MOSQUITTO_DISABLE_CPP
	$(SED) '/-C cpp/d' $(@D)/lib/Makefile
endef

MOSQUITTO_POST_PATCH_HOOKS += MOSQUITTO_DISABLE_CPP
endif

MOSQUITTO_MAKE_DIRS = lib client
ifeq ($(BR2_PACKAGE_MOSQUITTO_BROKER),y)
MOSQUITTO_MAKE_DIRS += src
endif

define MOSQUITTO_BUILD_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) DIRS="$(MOSQUITTO_MAKE_DIRS)" \
		$(MOSQUITTO_MAKE_OPTS)
endef

define MOSQUITTO_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) DIRS="$(MOSQUITTO_MAKE_DIRS)" \
		$(MOSQUITTO_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
endef

define MOSQUITTO_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS) DIRS="$(MOSQUITTO_MAKE_DIRS)" \
		$(MOSQUITTO_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
	rm -f $(TARGET_DIR)/etc/mosquitto/*.example
	$(INSTALL) -D -m 0644 $(@D)/mosquitto.conf \
		$(TARGET_DIR)/etc/mosquitto/mosquitto.conf
endef

ifeq ($(BR2_PACKAGE_MOSQUITTO_BROKER),y)
define MOSQUITTO_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/mosquitto/S50mosquitto \
		$(TARGET_DIR)/etc/init.d/S50mosquitto
endef

define MOSQUITTO_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 $(@D)/service/systemd/mosquitto.service.notify \
		$(TARGET_DIR)/usr/lib/systemd/system/mosquitto.service
endef

define MOSQUITTO_USERS
	mosquitto -1 nobody -1 * - - - Mosquitto user
endef
endif

$(eval $(generic-package))
