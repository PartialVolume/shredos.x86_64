################################################################################
#
# janus-gateway
#
################################################################################

JANUS_GATEWAY_VERSION = 0.10.10
JANUS_GATEWAY_SITE = $(call github,meetecho,janus-gateway,v$(JANUS_GATEWAY_VERSION))
JANUS_GATEWAY_LICENSE = GPL-3.0 with OpenSSL exception
JANUS_GATEWAY_LICENSE_FILES = COPYING
JANUS_GATEWAY_CPE_ID_VENDOR = meetecho
JANUS_GATEWAY_CPE_ID_PRODUCT = janus

# ding-libs provides the ini_config library
JANUS_GATEWAY_DEPENDENCIES = host-pkgconf jansson libnice \
	libsrtp host-gengetopt libglib2 openssl libconfig \
	$(if $(BR2_PACKAGE_LIBOGG),libogg)

# Straight out of the repository, no ./configure, and we also patch
# configure.ac.
JANUS_GATEWAY_AUTORECONF = YES

JANUS_GATEWAY_CONF_OPTS = \
	--disable-data-channels \
	--disable-sample-event-handler

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_DEMOS),)
define JANUS_GATEWAY_REMOVE_DEMOS
	$(RM) -fr $(TARGET_DIR)/usr/share/janus/demos/
endef
JANUS_GATEWAY_POST_INSTALL_TARGET_HOOKS += JANUS_GATEWAY_REMOVE_DEMOS
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_AUDIO_BRIDGE),y)
JANUS_GATEWAY_DEPENDENCIES += opus
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-audiobridge
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-audiobridge
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_ECHO_TEST),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-echotest
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-echotest
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_RECORDPLAY),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-recordplay
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-recordplay
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_SIP_GATEWAY),y)
JANUS_GATEWAY_DEPENDENCIES += sofia-sip
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-sip
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-sip
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_STREAMING),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-streaming
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-streaming
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_TEXT_ROOM),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-textroom
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-textroom
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_VIDEO_CALL),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-videocall
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-videocall
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_VIDEO_ROOM),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-videoroom
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-videoroom
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_VOICE_MAIL),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-voicemail
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-voicemail
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_MQTT),y)
JANUS_GATEWAY_DEPENDENCIES += paho-mqtt-c
JANUS_GATEWAY_CONF_OPTS += --enable-mqtt
else
JANUS_GATEWAY_CONF_OPTS += --disable-mqtt
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_RABBITMQ),y)
JANUS_GATEWAY_DEPENDENCIES += rabbitmq-c
JANUS_GATEWAY_CONF_OPTS += --enable-rabbitmq
else
JANUS_GATEWAY_CONF_OPTS += --disable-rabbitmq
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_REST),y)
JANUS_GATEWAY_DEPENDENCIES += libmicrohttpd
JANUS_GATEWAY_CONF_OPTS += --enable-rest
else
JANUS_GATEWAY_CONF_OPTS += --disable-rest
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_UNIX_SOCKETS),y)
JANUS_GATEWAY_CONF_OPTS += --enable-unix-sockets
else
JANUS_GATEWAY_CONF_OPTS += --disable-unix-sockets
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_WEBSOCKETS),y)
JANUS_GATEWAY_DEPENDENCIES += libwebsockets
JANUS_GATEWAY_CONF_OPTS += --enable-websockets
else
JANUS_GATEWAY_CONF_OPTS += --disable-websockets
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
JANUS_GATEWAY_DEPENDENCIES += systemd
JANUS_GATEWAY_CONF_OPTS += --enable-systemd-sockets
else
JANUS_GATEWAY_CONF_OPTS += --disable-systemd-sockets
endif

$(eval $(autotools-package))
