################################################################################
#
# xserver_xorg-server
#
################################################################################

XSERVER_XORG_SERVER_VERSION = 1.20.13
XSERVER_XORG_SERVER_SOURCE = xorg-server-$(XSERVER_XORG_SERVER_VERSION).tar.xz
XSERVER_XORG_SERVER_SITE = https://xorg.freedesktop.org/archive/individual/xserver
XSERVER_XORG_SERVER_LICENSE = MIT
XSERVER_XORG_SERVER_LICENSE_FILES = COPYING
XSERVER_XORG_SERVER_INSTALL_STAGING = YES
# xfont_font-util is needed only for autoreconf
XSERVER_XORG_SERVER_AUTORECONF = YES
XSERVER_XORG_SERVER_DEPENDENCIES = \
	xfont_font-util \
	xutil_util-macros \
	xlib_libX11 \
	xlib_libXau \
	xlib_libXdmcp \
	xlib_libXext \
	xlib_libXfixes \
	xlib_libXfont2 \
	xlib_libXi \
	xlib_libXrender \
	xlib_libXres \
	xlib_libXft \
	xlib_libXcursor \
	xlib_libXinerama \
	xlib_libXrandr \
	xlib_libXdamage \
	xlib_libXxf86vm \
	xlib_libxkbfile \
	xlib_xtrans \
	xdata_xbitmaps \
	xorgproto \
	xkeyboard-config \
	pixman \
	mcookie \
	host-pkgconf

# We force -O2 regardless of the optimization level chosen by the
# user, as the X.org server is known to trigger some compiler bugs at
# -Os on several architectures.
XSERVER_XORG_SERVER_CONF_OPTS = \
	--disable-config-hal \
	--enable-record \
	--disable-xnest \
	--disable-xephyr \
	--disable-dmx \
	--disable-unit-tests \
	--with-builder-addr=buildroot@buildroot.org \
	CFLAGS="$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include/pixman-1 -O2" \
	--with-fontrootdir=/usr/share/fonts/X11/ \
	--$(if $(BR2_PACKAGE_XSERVER_XORG_SERVER_XVFB),en,dis)able-xvfb

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
XSERVER_XORG_SERVER_CONF_OPTS += \
	--with-systemd-daemon \
	--enable-systemd-logind
XSERVER_XORG_SERVER_DEPENDENCIES += \
	systemd
else
XSERVER_XORG_SERVER_CONF_OPTS += \
	--without-systemd-daemon \
	--disable-systemd-logind
endif

# Xwayland support needs libdrm, libepoxy, wayland and libxcomposite
ifeq ($(BR2_PACKAGE_LIBDRM)$(BR2_PACKAGE_LIBEPOXY)$(BR2_PACKAGE_WAYLAND)$(BR2_PACKAGE_WAYLAND_PROTOCOLS)$(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),yyyyy)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-xwayland
XSERVER_XORG_SERVER_DEPENDENCIES += libdrm libepoxy wayland wayland-protocols xlib_libXcomposite
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-xwayland
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_MODULAR),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-xorg
XSERVER_XORG_SERVER_DEPENDENCIES += libpciaccess
ifeq ($(BR2_PACKAGE_LIBDRM),y)
XSERVER_XORG_SERVER_DEPENDENCIES += libdrm
XSERVER_XORG_SERVER_CONF_OPTS += --enable-libdrm
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-libdrm
endif
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-xorg
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_KDRIVE),y)
XSERVER_XORG_SERVER_CONF_OPTS += \
	--enable-kdrive \
	--disable-glx \
	--disable-dri

else # modular
XSERVER_XORG_SERVER_CONF_OPTS += --disable-kdrive
endif

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-dri --enable-glx
XSERVER_XORG_SERVER_DEPENDENCIES += libgl
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dri --disable-glx
endif

# Optional packages
ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
XSERVER_XORG_SERVER_DEPENDENCIES += udev
XSERVER_XORG_SERVER_CONF_OPTS += --enable-config-udev
# udev kms support depends on libdrm and dri2
ifeq ($(BR2_PACKAGE_LIBDRM),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-config-udev-kms
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-config-udev-kms
endif
endif

ifeq ($(BR2_PACKAGE_DBUS),y)
XSERVER_XORG_SERVER_DEPENDENCIES += dbus
XSERVER_XORG_SERVER_CONF_OPTS += --enable-config-dbus
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
XSERVER_XORG_SERVER_DEPENDENCIES += freetype
endif

ifeq ($(BR2_PACKAGE_LIBUNWIND),y)
XSERVER_XORG_SERVER_DEPENDENCIES += libunwind
XSERVER_XORG_SERVER_CONF_OPTS += --enable-libunwind
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-libunwind
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBXVMC),y)
XSERVER_XORG_SERVER_CONF_OPTS += --disable-xvmc
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXCOMPOSITE),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libXcomposite
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-composite
endif

ifeq ($(BR2_PACKAGE_XSERVER_XORG_SERVER_MODULAR),y)
XSERVER_XORG_SERVER_CONF_OPTS += --enable-dri2
ifeq ($(BR2_PACKAGE_XLIB_LIBXSHMFENCE),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libxshmfence
XSERVER_XORG_SERVER_CONF_OPTS += --enable-dri3
ifeq ($(BR2_PACKAGE_HAS_LIBEGL)$(BR2_PACKAGE_HAS_LIBGL)$(BR2_PACKAGE_LIBEPOXY),yyy)
XSERVER_XORG_SERVER_DEPENDENCIES += libepoxy
XSERVER_XORG_SERVER_CONF_OPTS += --enable-glamor
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-glamor
endif
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dri3 --disable-glamor
endif
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dri2 --disable-dri3 --disable-glamor
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXSCRNSAVER),y)
XSERVER_XORG_SERVER_DEPENDENCIES += xlib_libXScrnSaver
XSERVER_XORG_SERVER_CONF_OPTS += --enable-screensaver
else
XSERVER_XORG_SERVER_CONF_OPTS += --disable-screensaver
endif

ifneq ($(BR2_PACKAGE_XLIB_LIBDMX),y)
XSERVER_XORG_SERVER_CONF_OPTS += --disable-dmx
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
XSERVER_XORG_SERVER_CONF_OPTS += --with-sha1=libcrypto
XSERVER_XORG_SERVER_DEPENDENCIES += openssl
else ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
XSERVER_XORG_SERVER_CONF_OPTS += --with-sha1=libgcrypt
XSERVER_XORG_SERVER_DEPENDENCIES += libgcrypt
else
XSERVER_XORG_SERVER_CONF_OPTS += --with-sha1=libsha1
XSERVER_XORG_SERVER_DEPENDENCIES += libsha1
endif

define XSERVER_XORG_SERVER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/x11r7/xserver_xorg-server/xorg.service \
		$(TARGET_DIR)/usr/lib/systemd/system/xorg.service
endef

# init script conflicts with S90nodm
ifneq ($(BR2_PACKAGE_NODM),y)
define XSERVER_XORG_SERVER_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/x11r7/xserver_xorg-server/S40xorg \
		$(TARGET_DIR)/etc/init.d/S40xorg
endef
endif

$(eval $(autotools-package))
