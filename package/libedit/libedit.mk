################################################################################
#
# libedit
#
################################################################################

LIBEDIT_VERSION = 20191231-3.1
LIBEDIT_SITE = http://www.thrysoee.dk/editline
LIBEDIT_INSTALL_STAGING = YES
LIBEDIT_DEPENDENCIES = ncurses
LIBEDIT_LICENSE = BSD-3-Clause
LIBEDIT_LICENSE_FILES = COPYING

# We're patching configure.ac
LIBEDIT_AUTORECONF = YES

# musl is ISO 10646 compliant but doesn't define __STDC_ISO_10646__,
# so let's define it manually
ifeq ($(BR2_TOOLCHAIN_USES_MUSL),y)
LIBEDIT_CONF_OPTS += CFLAGS="$(TARGET_CFLAGS) -D__STDC_ISO_10646__=201103L"
endif

# Note: libbsd required for *vis functions, but works only with a toolchain
# with __progname; otherwise, some features are disabled, as if libbsd was
# missing entirely.
ifeq ($(BR2_PACKAGE_LIBBSD),y)
LIBEDIT_DEPENDENCIES += libbsd
endif

$(eval $(autotools-package))
