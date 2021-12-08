################################################################################
#
# libtool
#
################################################################################

LIBTOOL_VERSION = 2.4.6
LIBTOOL_SOURCE = libtool-$(LIBTOOL_VERSION).tar.xz
LIBTOOL_SITE = $(BR2_GNU_MIRROR)/libtool
LIBTOOL_CPE_ID_VENDOR = gnu

# For the target variant, we only want to build/install libltdl
LIBTOOL_SUBDIR = libltdl
HOST_LIBTOOL_SUBDIR = .

LIBTOOL_INSTALL_STAGING = YES

LIBTOOL_CONF_OPTS = --enable-ltdl-install

LIBTOOL_DEPENDENCIES = host-m4
HOST_LIBTOOL_DEPENDENCIES = host-m4

LIBTOOL_LICENSE = LGPL-2.1+
LIBTOOL_LICENSE_FILES = $(LIBTOOL_SUBDIR)/COPYING.LIB
HOST_LIBTOOL_LICENSE = GPL-2.0+ (libtool), LGPL-2.1+ (libltdl)
HOST_LIBTOOL_LICENSE_FILES = COPYING $(LIBTOOL_SUBDIR)/COPYING.LIB

HOST_LIBTOOL_CONF_ENV = MAKEINFO=true
HOST_LIBTOOL_LIBTOOL_PATCH = NO

# We have a patch that affects libtool.m4, which triggers an autoreconf
# in the build step. Normally we would set AUTORECONF = YES, but this
# doesn't work for host-libtool because that creates a circular
# dependency. Instead, touch the generated files so autoreconf is not
# triggered in the build step. Note that aclocal.m4 has to be touched
# first since the rest depends on it. Note that we don't need the changes
# in libtool.m4 in our configure script, because we're not actually
# running it on the target.
# For the target, we would normally be able to use AUTORECONF, but it
# fails on libltdl/Makefile.inc. Rather than trying to fix that failure,
# just use the same hack as on the host.
define LIBTOOL_AVOID_AUTORECONF_HOOK
	find $(@D) -name aclocal.m4 -exec touch '{}' \;
	find $(@D) -name config-h.in -exec touch '{}' \;
	find $(@D) -name configure -exec touch '{}' \;
	find $(@D) -name Makefile.in -exec touch '{}' \;
endef
LIBTOOL_PRE_CONFIGURE_HOOKS += LIBTOOL_AVOID_AUTORECONF_HOOK
HOST_LIBTOOL_PRE_CONFIGURE_HOOKS += LIBTOOL_AVOID_AUTORECONF_HOOK

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# variables used by other packages
LIBTOOL = $(HOST_DIR)/bin/libtool
LIBTOOLIZE = $(HOST_DIR)/bin/libtoolize
