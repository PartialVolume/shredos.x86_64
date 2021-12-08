################################################################################
#
# paho-mqtt-cpp
#
################################################################################

PAHO_MQTT_CPP_VERSION = 1.1
PAHO_MQTT_CPP_SITE = $(call github,eclipse,paho.mqtt.cpp,v$(PAHO_MQTT_CPP_VERSION))
PAHO_MQTT_CPP_LICENSE = EPL-1.0 or BSD-3-Clause
PAHO_MQTT_CPP_LICENSE_FILES = epl-v10 edl-v10
PAHO_MQTT_CPP_INSTALL_STAGING = YES
PAHO_MQTT_CPP_DEPENDENCIES = paho-mqtt-c

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PAHO_MQTT_CPP_DEPENDENCIES += openssl
PAHO_MQTT_CPP_CONF_OPTS += -DPAHO_WITH_SSL=TRUE
else
PAHO_MQTT_CPP_CONF_OPTS += -DPAHO_WITH_SSL=FALSE
endif

ifeq ($(BR2_SHARED_LIBS),y)
PAHO_MQTT_CPP_CONF_OPTS += \
	-DPAHO_BUILD_SHARED=TRUE \
	-DPAHO_BUILD_STATIC=FALSE
else ifeq ($(BR2_STATIC_LIBS),y)
PAHO_MQTT_CPP_CONF_OPTS += \
	-DPAHO_BUILD_SHARED=FALSE \
	-DPAHO_BUILD_STATIC=TRUE
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
PAHO_MQTT_CPP_CONF_OPTS += \
	-DPAHO_BUILD_SHARED=TRUE \
	-DPAHO_BUILD_STATIC=TRUE
endif

$(eval $(cmake-package))
