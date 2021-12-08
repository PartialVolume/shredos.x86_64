################################################################################
#
# wpewebkit
#
################################################################################

WPEWEBKIT_VERSION = 2.32.4
WPEWEBKIT_SITE = http://www.wpewebkit.org/releases
WPEWEBKIT_SOURCE = wpewebkit-$(WPEWEBKIT_VERSION).tar.xz
WPEWEBKIT_INSTALL_STAGING = YES
WPEWEBKIT_LICENSE = LGPL-2.1+, BSD-2-Clause
WPEWEBKIT_LICENSE_FILES = \
	Source/WebCore/LICENSE-APPLE \
	Source/WebCore/LICENSE-LGPL-2.1
WPEWEBKIT_CPE_ID_VENDOR = wpewebkit
WPEWEBKIT_CPE_ID_PRODUCT = wpe_webkit
WPEWEBKIT_DEPENDENCIES = host-gperf host-python host-ruby \
	harfbuzz cairo icu jpeg libepoxy libgcrypt libgles libsoup libtasn1 \
	libpng libxslt openjpeg wayland-protocols webp wpebackend-fdo

WPEWEBKIT_CONF_OPTS = \
	-DPORT=WPE \
	-DENABLE_ACCESSIBILITY=OFF \
	-DENABLE_API_TESTS=OFF \
	-DENABLE_MINIBROWSER=OFF \
	-DSILENCE_CROSS_COMPILATION_NOTICES=ON

ifeq ($(BR2_PACKAGE_WPEWEBKIT_SANDBOX),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_BUBBLEWRAP_SANDBOX=ON \
	-DBWRAP_EXECUTABLE=/usr/bin/bwrap \
	-DDBUS_PROXY_EXECUTABLE=/usr/bin/xdg-dbus-proxy
WPEWEBKIT_DEPENDENCIES += libseccomp
else
WPEWEBKIT_CONF_OPTS += -DENABLE_BUBBLEWRAP_SANDBOX=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_MULTIMEDIA),y)
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=ON \
	-DENABLE_WEB_AUDIO=ON
WPEWEBKIT_DEPENDENCIES += gstreamer1 gst1-libav gst1-plugins-base gst1-plugins-good
else
WPEWEBKIT_CONF_OPTS += \
	-DENABLE_VIDEO=OFF \
	-DENABLE_WEB_AUDIO=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_MEDIA_STREAM),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_MEDIA_STREAM=ON
WPEWEBKIT_DEPENDENCIES += gst1-plugins-bad
else
WPEWEBKIT_CONF_OPTS += -DENABLE_MEDIA_STREAM=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_USE_GSTREAMER_GL),y)
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=ON
else
WPEWEBKIT_CONF_OPTS += -DUSE_GSTREAMER_GL=OFF
endif

ifeq ($(BR2_PACKAGE_WPEWEBKIT_WEBDRIVER),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=ON
else
WPEWEBKIT_CONF_OPTS += -DENABLE_WEBDRIVER=OFF
endif

ifeq ($(BR2_PACKAGE_WOFF2),y)
WPEWEBKIT_CONF_OPTS += -DUSE_WOFF2=ON
WPEWEBKIT_DEPENDENCIES += woff2
else
WPEWEBKIT_CONF_OPTS += -DUSE_WOFF2=OFF
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
WPEWEBKIT_CONF_OPTS += -DUSE_SYSTEMD=ON
WPEWEBKIT_DEPENDENCIES += systemd
else
WPEWEBKIT_CONF_OPTS += -DUSE_SYSTEMD=OFF
endif

# JIT is not supported for MIPS r6, but the WebKit build system does not
# have a check for these processors. The same goes for ARMv5 and ARMv6.
# Disable JIT forcibly here and use the CLoop interpreter instead.
#
# Also, we have to disable the sampling profiler, which does NOT work
# with ENABLE_C_LOOP.
#
# Upstream bugs: https://bugs.webkit.org/show_bug.cgi?id=191258
#                https://bugs.webkit.org/show_bug.cgi?id=172765
#
ifeq ($(BR2_ARM_CPU_ARMV5)$(BR2_ARM_CPU_ARMV6)$(BR2_MIPS_CPU_MIPS32R6)$(BR2_MIPS_CPU_MIPS64R6),y)
WPEWEBKIT_CONF_OPTS += -DENABLE_JIT=OFF -DENABLE_C_LOOP=ON -DENABLE_SAMPLING_PROFILER=OFF
endif

$(eval $(cmake-package))
