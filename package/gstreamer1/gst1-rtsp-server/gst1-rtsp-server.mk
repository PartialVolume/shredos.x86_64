################################################################################
#
# gst1-rtsp-server
#
################################################################################

GST1_RTSP_SERVER_VERSION = 1.18.5
GST1_RTSP_SERVER_SOURCE = gst-rtsp-server-$(GST1_RTSP_SERVER_VERSION).tar.xz
GST1_RTSP_SERVER_SITE = http://gstreamer.freedesktop.org/src/gst-rtsp-server
GST1_RTSP_SERVER_LICENSE = LGPL-2.0+
GST1_RTSP_SERVER_LICENSE_FILES = COPYING COPYING.LIB
GST1_RTSP_SERVER_CPE_ID_VENDOR = gstreamer_project
GST1_RTSP_SERVER_CPE_ID_PRODUCT = gst-rtsp-server
GST1_RTSP_SERVER_INSTALL_STAGING = YES
GST1_RTSP_SERVER_DEPENDENCIES = \
	host-pkgconf \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-good

GST1_RTSP_SERVER_LDFLAGS = $(TARGET_LDFLAGS) $(TARGET_NLS_LIBS)

GST1_RTSP_SERVER_CONF_OPTS = \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Ddoc=disabled

GST1_RTSP_SERVER_CONF_OPTS += \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dgobject-cast-checks=disabled \
	-Dglib-asserts=disabled \
	-Dglib-checks=disabled

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
GST1_RTSP_SERVER_CONF_OPTS += -Dintrospection=enabled
GST1_RTSP_SERVER_DEPENDENCIES += gobject-introspection
else
GST1_RTSP_SERVER_CONF_OPTS += -Dintrospection=disabled
endif

ifeq ($(BR2_PACKAGE_LIBCGROUP),y)
GST1_RTSP_SERVER_DEPENDENCIES += libcgroup
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD),y)
GST1_RTSP_SERVER_DEPENDENCIES += gst1-plugins-bad
endif

$(eval $(meson-package))
