################################################################################
#
# glibc
#
################################################################################

ifeq ($(BR2_csky),y)
GLIBC_VERSION = 7630ed2fa60caea98f500e4a7a51b88f9bf1e176
GLIBC_SITE = $(call github,c-sky,glibc,$(GLIBC_VERSION))
else
# Generate version string using:
#   git describe --match 'glibc-*' --abbrev=40 origin/release/MAJOR.MINOR/master | cut -d '-' -f 2-
# When updating the version, please also update localedef
GLIBC_VERSION = 2.33-46-gedfd11197ecf3629bbb4b66c5814da09a61a7f9f
# Upstream doesn't officially provide an https download link.
# There is one (https://sourceware.org/git/glibc.git) but it's not reliable,
# sometimes the connection times out. So use an unofficial github mirror.
# When updating the version, check it on the official repository;
# *NEVER* decide on a version string by looking at the mirror.
# Then check that the mirror has been synced already (happens once a day.)
GLIBC_SITE = $(call github,bminor,glibc,$(GLIBC_VERSION))
endif

GLIBC_LICENSE = GPL-2.0+ (programs), LGPL-2.1+, BSD-3-Clause, MIT (library)
GLIBC_LICENSE_FILES = COPYING COPYING.LIB LICENSES
GLIBC_CPE_ID_VENDOR = gnu

# glibc is part of the toolchain so disable the toolchain dependency
GLIBC_ADD_TOOLCHAIN_DEPENDENCY = NO

# Before glibc is configured, we must have the first stage
# cross-compiler and the kernel headers
GLIBC_DEPENDENCIES = host-gcc-initial linux-headers host-bison host-gawk \
	$(BR2_MAKE_HOST_DEPENDENCY) $(BR2_PYTHON3_HOST_DEPENDENCY)

GLIBC_SUBDIR = build

GLIBC_INSTALL_STAGING = YES

GLIBC_INSTALL_STAGING_OPTS = install_root=$(STAGING_DIR) install

# Thumb build is broken, build in ARM mode
ifeq ($(BR2_ARM_INSTRUCTIONS_THUMB),y)
GLIBC_EXTRA_CFLAGS += -marm
endif

# MIPS64 defaults to n32 so pass the correct -mabi if
# we are using a different ABI. OABI32 is also used
# in MIPS so we pass -mabi=32 in this case as well
# even though it's not strictly necessary.
ifeq ($(BR2_MIPS_NABI64),y)
GLIBC_EXTRA_CFLAGS += -mabi=64
else ifeq ($(BR2_MIPS_OABI32),y)
GLIBC_EXTRA_CFLAGS += -mabi=32
endif

ifeq ($(BR2_ENABLE_DEBUG),y)
GLIBC_EXTRA_CFLAGS += -g
endif

# The stubs.h header is not installed by install-headers, but is
# needed for the gcc build. An empty stubs.h will work, as explained
# in http://gcc.gnu.org/ml/gcc/2002-01/msg00900.html. The same trick
# is used by Crosstool-NG.
ifeq ($(BR2_TOOLCHAIN_BUILDROOT_GLIBC),y)
define GLIBC_ADD_MISSING_STUB_H
	mkdir -p $(STAGING_DIR)/usr/include/gnu
	touch $(STAGING_DIR)/usr/include/gnu/stubs.h
endef
endif

GLIBC_CONF_ENV = \
	ac_cv_path_BASH_SHELL=/bin/$(if $(BR2_PACKAGE_BASH),bash,sh) \
	libc_cv_forced_unwind=yes \
	libc_cv_ssp=no

# POSIX shell does not support localization, so remove the corresponding
# syntax from ldd if bash is not selected.
ifeq ($(BR2_PACKAGE_BASH),)
define GLIBC_LDD_NO_BASH
	$(SED) 's/$$"/"/g' $(@D)/elf/ldd.bash.in
endef
GLIBC_POST_PATCH_HOOKS += GLIBC_LDD_NO_BASH
endif

# Override the default library locations of /lib64/<abi> and
# /usr/lib64/<abi>/ for RISC-V.
ifeq ($(BR2_riscv),y)
ifeq ($(BR2_RISCV_64),y)
GLIBC_CONF_ENV += libc_cv_slibdir=/lib64 libc_cv_rtlddir=/lib
else
GLIBC_CONF_ENV += libc_cv_slibdir=/lib32 libc_cv_rtlddir=/lib
endif
endif

# glibc requires make >= 4.0 since 2.28 release.
# https://www.sourceware.org/ml/libc-alpha/2018-08/msg00003.html
GLIBC_MAKE = $(BR2_MAKE)
GLIBC_CONF_ENV += ac_cv_prog_MAKE="$(BR2_MAKE)"

# Even though we use the autotools-package infrastructure, we have to
# override the default configure commands for several reasons:
#
#  1. We have to build out-of-tree, but we can't use the same
#     'symbolic link to configure' used with the gcc packages.
#
#  2. We have to execute the configure script with bash and not sh.
#
# Note that as mentionned in
# http://patches.openembedded.org/patch/38849/, glibc must be
# built with -O2, so we pass our own CFLAGS and CXXFLAGS below.
define GLIBC_CONFIGURE_CMDS
	mkdir -p $(@D)/build
	# Do the configuration
	(cd $(@D)/build; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="-O2 $(GLIBC_EXTRA_CFLAGS)" CPPFLAGS="" \
		CXXFLAGS="-O2 $(GLIBC_EXTRA_CFLAGS)" \
		$(GLIBC_CONF_ENV) \
		$(SHELL) $(@D)/configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--enable-shared \
		$(if $(BR2_x86_64),--enable-lock-elision) \
		--with-pkgversion="Buildroot" \
		--disable-profile \
		--disable-werror \
		--without-gd \
		--enable-kernel=$(call qstrip,$(BR2_TOOLCHAIN_HEADERS_AT_LEAST)) \
		--with-headers=$(STAGING_DIR)/usr/include)
	$(GLIBC_ADD_MISSING_STUB_H)
endef

#
# We also override the install to target commands since we only want
# to install the libraries, and nothing more.
#

GLIBC_LIBS_LIB = \
	ld*.so.* libanl.so.* libc.so.* libcrypt.so.* libdl.so.* libgcc_s.so.* \
	libm.so.* libpthread.so.* libresolv.so.* librt.so.* \
	libutil.so.* libnss_files.so.* libnss_dns.so.* libmvec.so.*

ifeq ($(BR2_PACKAGE_GDB),y)
GLIBC_LIBS_LIB += libthread_db.so.*
endif

ifeq ($(BR2_PACKAGE_GLIBC_UTILS),y)
GLIBC_TARGET_UTILS_USR_BIN = posix/getconf elf/ldd
GLIBC_TARGET_UTILS_SBIN = elf/ldconfig
ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
GLIBC_TARGET_UTILS_USR_BIN += locale/locale
endif
endif

define GLIBC_INSTALL_TARGET_CMDS
	for libpattern in $(GLIBC_LIBS_LIB); do \
		$(call copy_toolchain_lib_root,$$libpattern) ; \
	done
	$(foreach util,$(GLIBC_TARGET_UTILS_USR_BIN), \
		$(INSTALL) -D -m 0755 $(@D)/build/$(util) $(TARGET_DIR)/usr/bin/$(notdir $(util))
	)
	$(foreach util,$(GLIBC_TARGET_UTILS_SBIN), \
		$(INSTALL) -D -m 0755 $(@D)/build/$(util) $(TARGET_DIR)/sbin/$(notdir $(util))
	)
endef

$(eval $(autotools-package))
