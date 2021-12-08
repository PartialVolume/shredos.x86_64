################################################################################
#
# gst1-vaapi
#
################################################################################

GST1_VAAPI_VERSION = 1.18.5
GST1_VAAPI_SITE = https://gstreamer.freedesktop.org/src/gstreamer-vaapi
GST1_VAAPI_SOURCE = gstreamer-vaapi-$(GST1_VAAPI_VERSION).tar.xz
GST1_VAAPI_LICENSE = LGPL-2.1+
GST1_VAAPI_LICENSE_FILES = COPYING.LIB

GST1_VAAPI_DEPENDENCIES += \
	gstreamer1 \
	gst1-plugins-base \
	gst1-plugins-bad \
	libva \
	libdrm

GST1_VAAPI_CONF_OPTS += \
	-Dwith_drm=yes \
	-Dwith_x11=no \
	-Dwith_glx=no \
	-Dwith_wayland=no \
	-Dwith_egl=no \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Ddoc=disabled

ifeq ($(BR2_PACKAGE_GST1_VAAPI_ENCODERS),y)
GST1_VAAPI_CONF_OPTS += -Dwith_encoders=yes
else
GST1_VAAPI_CONF_OPTS += -Dwith_encoders=no
endif

$(eval $(meson-package))
