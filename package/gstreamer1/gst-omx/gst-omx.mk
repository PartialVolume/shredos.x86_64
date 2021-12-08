################################################################################
#
# gst-omx
#
################################################################################

GST_OMX_VERSION = 1.18.5
GST_OMX_SOURCE = gst-omx-$(GST_OMX_VERSION).tar.xz
GST_OMX_SITE = https://gstreamer.freedesktop.org/src/gst-omx

GST_OMX_LICENSE = LGPL-2.1
GST_OMX_LICENSE_FILES = COPYING

GST_OMX_CONF_OPTS = \
	-Dexamples=disabled \
	-Dtests=disabled \
	-Dtools=disabled \
	-Ddoc=disabled

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
GST_OMX_VARIANT = rpi
GST_OMX_CONF_OPTS += -Dheader_path=$(STAGING_DIR)/usr/include/IL
else
GST_OMX_VARIANT = generic
endif

GST_OMX_CONF_OPTS += -Dtarget=$(GST_OMX_VARIANT)

GST_OMX_DEPENDENCIES = gstreamer1 gst1-plugins-base libopenmax

# adjust library paths to where buildroot installs them
define GST_OMX_FIXUP_CONFIG_PATHS
	find $(@D)/config -name gstomx.conf | \
		xargs $(SED) 's|/usr/local|/usr|g' -e 's|/opt/vc|/usr|g'
endef

GST_OMX_POST_PATCH_HOOKS += GST_OMX_FIXUP_CONFIG_PATHS

$(eval $(meson-package))
