################################################################################
#
# xdriver_xf86-video-nouveau
#
################################################################################

XDRIVER_XF86_VIDEO_NOUVEAU_VERSION = 1.0.17
XDRIVER_XF86_VIDEO_NOUVEAU_SOURCE = xf86-video-nouveau-$(XDRIVER_XF86_VIDEO_NOUVEAU_VERSION).tar.bz2
XDRIVER_XF86_VIDEO_NOUVEAU_SITE = http://xorg.freedesktop.org/releases/individual/driver
XDRIVER_XF86_VIDEO_NOUVEAU_LICENSE = MIT
XDRIVER_XF86_VIDEO_NOUVEAU_LICENSE_FILES = COPYING
XDRIVER_XF86_VIDEO_NOUVEAU_DEPENDENCIES = \
	host-pkgconf \
	libdrm \
	xorgproto \
	xserver_xorg-server

# xdriver_xf86-video-nouveau requires O_CLOEXEC
XDRIVER_XF86_VIDEO_NOUVEAU_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

$(eval $(autotools-package))
