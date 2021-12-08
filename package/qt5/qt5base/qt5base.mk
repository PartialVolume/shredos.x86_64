################################################################################
#
# qt5base
#
################################################################################

QT5BASE_VERSION = $(QT5_VERSION)
QT5BASE_SITE = $(QT5_SITE)
QT5BASE_SOURCE = qtbase-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5BASE_VERSION).tar.xz

QT5BASE_DEPENDENCIES = host-pkgconf pcre2 zlib
QT5BASE_INSTALL_STAGING = YES

# A few comments:
#  * -no-pch to workaround the issue described at
#     http://comments.gmane.org/gmane.comp.lib.qt.devel/5933.
#  * -system-zlib because zlib is mandatory for Qt build, and we
#     want to use the Buildroot packaged zlib
#  * -system-pcre because pcre is mandatory to build Qt, and we
#    want to use the one packaged in Buildroot
#  * -no-feature-relocatable to work around path mismatch
#     while searching qml files and buildroot BR2_ROOTFS_MERGED_USR
#     feature enabled
QT5BASE_CONFIGURE_OPTS += \
	-optimized-qmake \
	-no-iconv \
	-system-zlib \
	-system-pcre \
	-no-pch \
	-shared \
	-no-feature-relocatable

# starting from version 5.9.0, -optimize-debug is enabled by default
# for debug builds and it overrides -O* with -Og which is not what we
# want.
QT5BASE_CONFIGURE_OPTS += -no-optimize-debug

QT5BASE_CFLAGS = $(TARGET_CFLAGS)
QT5BASE_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_90620),y)
QT5BASE_CFLAGS += -O0
QT5BASE_CXXFLAGS += -O0
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),)
QT5BASE_CONFIGURE_OPTS += -no-sse2
else ifeq ($(BR2_X86_CPU_HAS_SSE3),)
QT5BASE_CONFIGURE_OPTS += -no-sse3
else ifeq ($(BR2_X86_CPU_HAS_SSSE3),)
QT5BASE_CONFIGURE_OPTS += -no-ssse3
else ifeq ($(BR2_X86_CPU_HAS_SSE4),)
QT5BASE_CONFIGURE_OPTS += -no-sse4.1
else ifeq ($(BR2_X86_CPU_HAS_SSE42),)
QT5BASE_CONFIGURE_OPTS += -no-sse4.2
else ifeq ($(BR2_X86_CPU_HAS_AVX),)
QT5BASE_CONFIGURE_OPTS += -no-avx
else ifeq ($(BR2_X86_CPU_HAS_AVX2),)
QT5BASE_CONFIGURE_OPTS += -no-avx2
else
# no buildroot BR2_X86_CPU_HAS_AVX512 option yet for qt configure
# option '-no-avx512'
endif

ifeq ($(BR2_PACKAGE_LIBDRM),y)
QT5BASE_CONFIGURE_OPTS += -kms
QT5BASE_DEPENDENCIES += libdrm
else
QT5BASE_CONFIGURE_OPTS += -no-kms
endif

# Uses libgbm from mesa3d
ifeq ($(BR2_PACKAGE_MESA3D_OPENGL_EGL),y)
QT5BASE_CONFIGURE_OPTS += -gbm
QT5BASE_DEPENDENCIES += mesa3d
else ifeq ($(BR2_PACKAGE_GCNANO_BINARIES),y)
QT5BASE_CONFIGURE_OPTS += -gbm
QT5BASE_DEPENDENCIES += gcnano-binaries
else ifeq ($(BR2_PACKAGE_TI_SGX_UM),y)
QT5BASE_CONFIGURE_OPTS += -gbm
QT5BASE_DEPENDENCIES += ti-sgx-um
else ifeq ($(BR2_PACKAGE_IMX_GPU_VIV_OUTPUT_WL),y)
QT5BASE_CONFIGURE_OPTS += -gbm
QT5BASE_DEPENDENCIES += imx-gpu-viv
else
QT5BASE_CONFIGURE_OPTS += -no-gbm
endif

ifeq ($(BR2_ENABLE_RUNTIME_DEBUG),y)
QT5BASE_CONFIGURE_OPTS += -debug
else
QT5BASE_CONFIGURE_OPTS += -release
endif

QT5BASE_CONFIGURE_OPTS += -opensource -confirm-license
QT5BASE_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5BASE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPLv3 LICENSE.FDL
ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
QT5BASE_LICENSE += , BSD-3-Clause (examples)
endif

QT5BASE_CONFIG_FILE = $(call qstrip,$(BR2_PACKAGE_QT5BASE_CONFIG_FILE))

ifneq ($(QT5BASE_CONFIG_FILE),)
QT5BASE_CONFIGURE_OPTS += -qconfig buildroot
endif

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
QT5BASE_DEPENDENCIES += udev
endif

ifeq ($(BR2_PACKAGE_CUPS), y)
QT5BASE_DEPENDENCIES += cups
QT5BASE_CONFIGURE_OPTS += -cups
else
QT5BASE_CONFIGURE_OPTS += -no-cups
endif

# Qt5 SQL Plugins
ifeq ($(BR2_PACKAGE_QT5BASE_SQL),y)
ifeq ($(BR2_PACKAGE_QT5BASE_MYSQL),y)
QT5BASE_CONFIGURE_OPTS += -plugin-sql-mysql -mysql_config $(STAGING_DIR)/usr/bin/mysql_config
QT5BASE_DEPENDENCIES   += mysql
else
QT5BASE_CONFIGURE_OPTS += -no-sql-mysql
endif

ifeq ($(BR2_PACKAGE_QT5BASE_PSQL),y)
QT5BASE_CONFIGURE_OPTS += -plugin-sql-psql -psql_config $(STAGING_DIR)/usr/bin/pg_config
QT5BASE_DEPENDENCIES   += postgresql
else
QT5BASE_CONFIGURE_OPTS += -no-sql-psql
endif

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_QT),-plugin-sql-sqlite)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_SYSTEM),-system-sqlite)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_SYSTEM),sqlite)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_SQLITE_NONE),-no-sql-sqlite)
endif

ifeq ($(BR2_PACKAGE_QT5BASE_GUI),y)
QT5BASE_CONFIGURE_OPTS += -gui -system-freetype
QT5BASE_DEPENDENCIES += freetype
else
QT5BASE_CONFIGURE_OPTS += -no-gui -no-freetype
endif

ifeq ($(BR2_PACKAGE_QT5BASE_HARFBUZZ),y)
ifeq ($(BR2_TOOLCHAIN_HAS_SYNC_4),y)
# system harfbuzz in case __sync for 4 bytes is supported
QT5BASE_CONFIGURE_OPTS += -system-harfbuzz
QT5BASE_DEPENDENCIES += harfbuzz
else
# qt harfbuzz otherwise (using QAtomic instead)
QT5BASE_CONFIGURE_OPTS += -qt-harfbuzz
QT5BASE_LICENSE += , MIT (harfbuzz)
QT5BASE_LICENSE_FILES += src/3rdparty/harfbuzz-ng/COPYING
endif
else
QT5BASE_CONFIGURE_OPTS += -no-harfbuzz
endif

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_WIDGETS),-widgets,-no-widgets)
# We have to use --enable-linuxfb, otherwise Qt thinks that -linuxfb
# is to add a link against the "inuxfb" library.
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_LINUXFB),--enable-linuxfb,-no-linuxfb)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_DIRECTFB),-directfb,-no-directfb)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_DIRECTFB),directfb)

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5BASE_CONFIGURE_OPTS += -xcb
QT5BASE_CONFIGURE_OPTS += -xkbcommon

QT5BASE_DEPENDENCIES   += \
	libxcb \
	xcb-util-wm \
	xcb-util-image \
	xcb-util-keysyms \
	xcb-util-renderutil \
	xlib_libX11 \
	libxkbcommon
ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS),y)
QT5BASE_DEPENDENCIES   += xlib_libXext
endif
else
QT5BASE_CONFIGURE_OPTS += -no-xcb
endif

ifeq ($(BR2_PACKAGE_QT5BASE_OPENGL_DESKTOP),y)
QT5BASE_CONFIGURE_OPTS += -opengl desktop
QT5BASE_DEPENDENCIES   += libgl
else ifeq ($(BR2_PACKAGE_QT5BASE_OPENGL_ES2),y)
QT5BASE_CONFIGURE_OPTS += -opengl es2
QT5BASE_DEPENDENCIES   += libgles
else
QT5BASE_CONFIGURE_OPTS += -no-opengl
endif

QT5BASE_DEFAULT_QPA = $(call qstrip,$(BR2_PACKAGE_QT5BASE_DEFAULT_QPA))
QT5BASE_CONFIGURE_OPTS += $(if $(QT5BASE_DEFAULT_QPA),-qpa $(QT5BASE_DEFAULT_QPA))

ifeq ($(BR2_PACKAGE_QT5BASE_EGLFS),y)
QT5BASE_CONFIGURE_OPTS += -eglfs
QT5BASE_DEPENDENCIES   += libegl
else
QT5BASE_CONFIGURE_OPTS += -no-eglfs
endif

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_OPENSSL),-openssl,-no-openssl)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_OPENSSL),openssl)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_FONTCONFIG),-fontconfig,-no-fontconfig)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_FONTCONFIG),fontconfig)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_GIF),,-no-gif)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_JPEG),-system-libjpeg,-no-libjpeg)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_JPEG),jpeg)
QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_PNG),-system-libpng,-no-libpng)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_PNG),libpng)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_DBUS),-dbus,-no-dbus)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_DBUS),dbus)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_TSLIB),-tslib,-no-tslib)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_TSLIB),tslib)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_LIBGLIB2),-glib,-no-glib)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_LIBGLIB2),libglib2)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_ICU),-icu,-no-icu)
QT5BASE_DEPENDENCIES   += $(if $(BR2_PACKAGE_QT5BASE_ICU),icu)

QT5BASE_CONFIGURE_OPTS += $(if $(BR2_PACKAGE_QT5BASE_EXAMPLES),-make,-nomake) examples

ifeq ($(BR2_PACKAGE_LIBINPUT),y)
QT5BASE_CONFIGURE_OPTS += -libinput
QT5BASE_DEPENDENCIES += libinput
else
QT5BASE_CONFIGURE_OPTS += -no-libinput
endif

# only enable gtk support if libgtk3 X11 backend is enabled
ifeq ($(BR2_PACKAGE_LIBGTK3)$(BR2_PACKAGE_LIBGTK3_X11),yy)
QT5BASE_CONFIGURE_OPTS += -gtk
QT5BASE_DEPENDENCIES += libgtk3
else
QT5BASE_CONFIGURE_OPTS += -no-gtk
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
QT5BASE_CONFIGURE_OPTS += -journald
QT5BASE_DEPENDENCIES += systemd
else
QT5BASE_CONFIGURE_OPTS += -no-journald
endif

ifeq ($(BR2_PACKAGE_QT5BASE_SYSLOG),y)
QT5BASE_CONFIGURE_OPTS += -syslog
else
QT5BASE_CONFIGURE_OPTS += -no-syslog
endif

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV),y)
# use vivante backend
QT5BASE_EGLFS_DEVICE = EGLFS_DEVICE_INTEGRATION = eglfs_viv
else ifeq ($(BR2_PACKAGE_SUNXI_MALI_MAINLINE),y)
# use mali backend
QT5BASE_EGLFS_DEVICE = EGLFS_DEVICE_INTEGRATION = eglfs_mali
endif

ifneq ($(QT5BASE_CONFIG_FILE),)
define QT5BASE_CONFIGURE_CONFIG_FILE
	cp $(QT5BASE_CONFIG_FILE) $(@D)/src/corelib/global/qconfig-buildroot.h
endef
endif

QT5BASE_ARCH_CONFIG_FILE = $(@D)/mkspecs/devices/linux-buildroot-g++/arch.conf
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
# Qt 5.8 needs atomics, which on various architectures are in -latomic
define QT5BASE_CONFIGURE_ARCH_CONFIG
	printf '!host_build { \n LIBS += -latomic\n }' >$(QT5BASE_ARCH_CONFIG_FILE)
endef
endif

# This allows to use ccache when available
define QT5BASE_CONFIGURE_HOSTCC
	$(SED) 's,^QMAKE_CC\s*=.*,QMAKE_CC = $(HOSTCC),' $(@D)/mkspecs/common/g++-base.conf
	$(SED) 's,^QMAKE_CXX\s*=.*,QMAKE_CXX = $(HOSTCXX),' $(@D)/mkspecs/common/g++-base.conf
endef

# Must be last so can override all options set by Buildroot
QT5BASE_CONFIGURE_OPTS += $(call qstrip,$(BR2_PACKAGE_QT5BASE_CUSTOM_CONF_OPTS))

define QT5BASE_CONFIGURE_CMDS
	mkdir -p $(@D)/mkspecs/devices/linux-buildroot-g++/
	sed 's/@EGLFS_DEVICE@/$(QT5BASE_EGLFS_DEVICE)/g' \
		$(QT5BASE_PKGDIR)/qmake.conf.in > \
		$(@D)/mkspecs/devices/linux-buildroot-g++/qmake.conf
	$(INSTALL) -m 0644 -D $(QT5BASE_PKGDIR)/qplatformdefs.h \
		$(@D)/mkspecs/devices/linux-buildroot-g++/qplatformdefs.h
	$(QT5BASE_CONFIGURE_CONFIG_FILE)
	touch $(QT5BASE_ARCH_CONFIG_FILE)
	$(QT5BASE_CONFIGURE_ARCH_CONFIG)
	$(QT5BASE_CONFIGURE_HOSTCC)
	(cd $(@D); \
		$(TARGET_MAKE_ENV) \
		PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
		MAKEFLAGS="-j$(PARALLEL_JOBS) $(MAKEFLAGS)" \
		./configure \
		-v \
		-prefix /usr \
		-hostprefix $(HOST_DIR) \
		-headerdir /usr/include/qt5 \
		-sysroot $(STAGING_DIR) \
		-plugindir /usr/lib/qt/plugins \
		-examplesdir /usr/lib/qt/examples \
		-no-rpath \
		-nomake tests \
		-device buildroot \
		-device-option CROSS_COMPILE="$(TARGET_CROSS)" \
		-device-option BR_COMPILER_CFLAGS="$(QT5BASE_CFLAGS)" \
		-device-option BR_COMPILER_CXXFLAGS="$(QT5BASE_CXXFLAGS)" \
		$(QT5BASE_CONFIGURE_OPTS) \
	)
endef

QT5BASE_POST_INSTALL_STAGING_HOOKS += QT5_INSTALL_QT_CONF

$(eval $(qmake-package))
