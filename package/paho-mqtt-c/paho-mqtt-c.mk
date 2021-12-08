################################################################################
#
# paho-mqtt-c
#
################################################################################

PAHO_MQTT_C_VERSION = 1.3.9
PAHO_MQTT_C_SITE = $(call github,eclipse,paho.mqtt.c,v$(PAHO_MQTT_C_VERSION))
PAHO_MQTT_C_LICENSE = EPL-2.0 or BSD-3-Clause
PAHO_MQTT_C_LICENSE_FILES = epl-v20 edl-v10 LICENSE
PAHO_MQTT_C_INSTALL_STAGING = YES

PAHO_MQTT_C_CONF_OPTS = \
	-DPAHO_ENABLE_TESTING=FALSE \
	-DPAHO_ENABLE_CPACK=FALSE \
	-DPAHO_HIGH_PERFORMANCE=TRUE

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PAHO_MQTT_C_DEPENDENCIES += openssl
PAHO_MQTT_C_CONF_OPTS += -DPAHO_WITH_SSL=TRUE
else
PAHO_MQTT_C_CONF_OPTS += -DPAHO_WITH_SSL=FALSE
endif

ifeq ($(BR2_SHARED_LIBS),y)
PAHO_MQTT_C_CONF_OPTS += \
	-DPAHO_BUILD_SHARED=TRUE \
	-DPAHO_BUILD_STATIC=FALSE
else ifeq ($(BR2_STATIC_LIBS),y)
PAHO_MQTT_C_CONF_OPTS += \
	-DPAHO_BUILD_SHARED=FALSE \
	-DPAHO_BUILD_STATIC=TRUE
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
PAHO_MQTT_C_CONF_OPTS += \
	-DPAHO_BUILD_SHARED=TRUE \
	-DPAHO_BUILD_STATIC=TRUE
endif

$(eval $(cmake-package))
