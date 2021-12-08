################################################################################
#
# guile
#
################################################################################

GUILE_VERSION = 3.0.4
GUILE_SOURCE = guile-$(GUILE_VERSION).tar.xz
GUILE_SITE = $(BR2_GNU_MIRROR)/guile
GUILE_INSTALL_STAGING = YES
# For 0002-calculate-csqrt_manually.patch and
# 0003-Makefile.am-fix-build-without-makeinfo.patch
GUILE_AUTORECONF = YES
GUILE_LICENSE = LGPL-3.0+
GUILE_LICENSE_FILES = LICENSE COPYING COPYING.LESSER

# libtool dependency is needed because guile uses libltdl
GUILE_DEPENDENCIES = host-guile libunistring libffi gmp bdwgc host-pkgconf libtool
HOST_GUILE_DEPENDENCIES = host-libunistring host-libffi host-gmp host-bdwgc host-flex host-pkgconf host-gettext

# The HAVE_GC* CFLAGS specify that we will use internal callbacks
# instead of the ones provided by
# bdwgc. Eg. HAVE_GC_SET_FINALIZER_NOTIFIER specifies that we won't
# use bdwgc's GC_finalizer_notifier callback.  Trying to use these
# specific bdwgc's callbacks breaks guile's building.
GUILE_CFLAGS = \
	-DHAVE_GC_SET_FINALIZER_NOTIFIER \
	-DHAVE_GC_GET_HEAP_USAGE_SAFE \
	-DHAVE_GC_GET_FREE_SPACE_DIVISOR \
	-DHAVE_GC_SET_FINALIZE_ON_DEMAND

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GUILE_CONF_ENV += LIBS=-latomic
endif

ifeq ($(BR2_STATIC_LIBS),y)
GUILE_CFLAGS += -DGC_NO_DLOPEN
endif

# Triggers assembler error with -Os
ifeq ($(BR2_TOOLCHAIN_EXTERNAL_CODESOURCERY_ARM)$(BR2_OPTIMIZE_S),yy)
GUILE_CFLAGS += -O2
endif

# jit triggers build failures with gcc < 5
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_5),)
GUILE_CONF_OPTS += --disable-jit
endif
ifeq ($(BR2_HOST_GCC_AT_LEAST_5),)
HOST_GUILE_CONF_OPTS += --disable-jit
endif

# It can use readline, but on the condition that it was build against
# ncurses. If both aren't present disable readline support since the
# host readline/ncurses support can poison the build.
ifeq ($(BR2_PACKAGE_NCURSES)$(BR2_PACKAGE_READLINE),yy)
GUILE_CONF_OPTS += --with-libreadline-prefix=$(STAGING_DIR)/usr
GUILE_DEPENDENCIES += readline
else
GUILE_CONF_OPTS += --without-libreadline-prefix
endif

GUILE_CONF_ENV += GUILE_FOR_BUILD=$(HOST_DIR)/bin/guile \
	CFLAGS="$(TARGET_CFLAGS) $(GUILE_CFLAGS)"

GUILE_CONF_OPTS += \
	--with-libltdl-prefix=$(STAGING_DIR)/usr/lib \
	--with-libgmp-prefix=$(STAGING_DIR)/usr/lib \
	--with-libunistring-prefix=$(STAGING_DIR)/usr/lib

$(eval $(autotools-package))
$(eval $(host-autotools-package))
