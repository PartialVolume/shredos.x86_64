################################################################################
#
# i2pd
#
################################################################################

I2PD_VERSION = 2.38.0
I2PD_SITE = $(call github,PurpleI2P,i2pd,$(I2PD_VERSION))
I2PD_LICENSE = BSD-3-Clause
I2PD_LICENSE_FILES = LICENSE
I2PD_SUBDIR = build
I2PD_DEPENDENCIES = \
	boost \
	openssl \
	zlib

I2PD_CONF_OPTS += -DWITH_GUI=OFF

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
I2PD_CONF_OPTS += \
	-DHAVE_CXX_ATOMICS_WITHOUT_LIB=OFF \
	-DHAVE_CXX_ATOMICS64_WITHOUT_LIB=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
I2PD_CONF_OPTS += -DWITH_STATIC=ON
else
I2PD_CONF_OPTS += -DWITH_STATIC=OFF
endif

ifeq ($(BR2_PACKAGE_LIBMINIUPNPC),y)
I2PD_DEPENDENCIES += libminiupnpc
I2PD_CONF_OPTS += -DWITH_UPNP=ON
else
I2PD_CONF_OPTS += -DWITH_UPNP=OFF
endif

define I2PD_INSTALL_CONFIGURATION_FILES
	$(INSTALL) -D -m 644 $(@D)/contrib/i2pd.conf \
		$(TARGET_DIR)/etc/i2pd/i2pd.conf
	$(INSTALL) -D -m 644 $(@D)/contrib/tunnels.conf \
		$(TARGET_DIR)/etc/i2pd/tunnels.conf
	mkdir -p $(TARGET_DIR)/var/lib/i2pd
	cp -a $(@D)/contrib/certificates $(TARGET_DIR)/var/lib/i2pd
endef

define I2PD_USERS
	i2pd -1 i2pd -1 * /var/lib/i2pd - - I2P Daemon
endef

define I2PD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/i2pd/S99i2pd \
		$(TARGET_DIR)/etc/init.d/S99i2pd
endef

define I2PD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/i2pd/i2pd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/i2pd.service
endef

$(eval $(cmake-package))
