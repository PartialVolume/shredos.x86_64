################################################################################
#
# pixman
#
################################################################################

PIXMAN_VERSION = 0.40.0
PIXMAN_SOURCE = pixman-$(PIXMAN_VERSION).tar.xz
PIXMAN_SITE = https://xorg.freedesktop.org/releases/individual/lib
PIXMAN_LICENSE = MIT
PIXMAN_LICENSE_FILES = COPYING
PIXMAN_CPE_ID_VENDOR = pixman

PIXMAN_INSTALL_STAGING = YES
PIXMAN_DEPENDENCIES = host-pkgconf
HOST_PIXMAN_DEPENDENCIES = host-pkgconf

# For 0001-Disable-tests.patch
PIXMAN_AUTORECONF = YES

# don't build gtk based demos
PIXMAN_CONF_OPTS = --disable-gtk

# The ARM SIMD code from pixman requires a recent enough ARM core, but
# there is a runtime CPU check that makes sure it doesn't get used if
# the HW doesn't support it. The only case where the ARM SIMD code
# cannot be *built* at all is when the platform doesn't support ARM
# instructions at all, so we have to disable that explicitly.
ifeq ($(BR2_ARM_CPU_HAS_ARM),y)
PIXMAN_CONF_OPTS += --enable-arm-simd
else
PIXMAN_CONF_OPTS += --disable-arm-simd
endif

ifeq ($(BR2_ARM_CPU_HAS_ARM)$(BR2_ARM_CPU_HAS_NEON),yy)
PIXMAN_CONF_OPTS += --enable-arm-neon
else
PIXMAN_CONF_OPTS += --disable-arm-neon
endif

# disable iwmmxt support for CPU's that don't have
# this feature
ifneq ($(BR2_iwmmxt),y)
PIXMAN_CONF_OPTS += --disable-arm-iwmmxt
endif

PIXMAN_CFLAGS = $(TARGET_CFLAGS)

# toolchain gets confused about TLS access through GOT (PIC), so disable TLS
# movhi	r4, %got_hiadj(%tls_ldo(fast_path_cache))
# {standard input}:172: Error: bad expression
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_NIOSII),y)
PIXMAN_CFLAGS += -DPIXMAN_NO_TLS
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_101737),y)
PIXMAN_CFLAGS += -O0
endif

PIXMAN_CONF_OPTS += CFLAGS="$(PIXMAN_CFLAGS)"

$(eval $(autotools-package))
$(eval $(host-autotools-package))
