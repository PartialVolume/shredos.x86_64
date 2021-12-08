################################################################################
#
# coreutils
#
################################################################################

COREUTILS_VERSION = 8.32
COREUTILS_SITE = $(BR2_GNU_MIRROR)/coreutils
COREUTILS_SOURCE = coreutils-$(COREUTILS_VERSION).tar.xz
COREUTILS_LICENSE = GPL-3.0+
COREUTILS_LICENSE_FILES = COPYING
COREUTILS_CPE_ID_VENDOR = gnu
# Only when including SUSE coreutils-i18n.patch
COREUTILS_IGNORE_CVES = CVE-2013-0221
COREUTILS_IGNORE_CVES += CVE-2013-0222
COREUTILS_IGNORE_CVES += CVE-2013-0223
# We're patching m4/pthread-cond.m4
COREUTILS_AUTORECONF = YES

COREUTILS_CONF_OPTS = --disable-rpath \
	$(if $(BR2_TOOLCHAIN_USES_MUSL),--with-included-regex)

ifeq ($(BR2_PACKAGE_COREUTILS_INDIVIDUAL_BINARIES),y)
COREUTILS_CONF_OPTS += --disable-single-binary
else
COREUTILS_CONF_OPTS += --enable-single-binary=symlinks
endif

COREUTILS_CONF_ENV = ac_cv_c_restrict=no \
	ac_cv_func_chown_works=yes \
	ac_cv_func_euidaccess=no \
	ac_cv_func_fstatat=yes \
	ac_cv_func_getdelim=yes \
	ac_cv_func_getgroups=yes \
	ac_cv_func_getgroups_works=yes \
	ac_cv_func_getloadavg=no \
	ac_cv_func_lstat_dereferences_slashed_symlink=yes \
	ac_cv_func_lstat_empty_string_bug=no \
	ac_cv_func_strerror_r_char_p=no \
	ac_cv_func_strnlen_working=yes \
	ac_cv_func_strtod=yes \
	ac_cv_func_working_mktime=yes \
	ac_cv_have_decl_strerror_r=yes \
	ac_cv_have_decl_strnlen=yes \
	ac_cv_lib_getloadavg_getloadavg=no \
	ac_cv_lib_util_getloadavg=no \
	ac_fsusage_space=yes \
	ac_use_included_regex=no \
	am_cv_func_working_getline=yes \
	fu_cv_sys_stat_statfs2_bsize=yes \
	gl_cv_func_getcwd_null=yes \
	gl_cv_func_getcwd_path_max=yes \
	gl_cv_func_gettimeofday_clobber=no \
	gl_cv_func_fstatat_zero_flag=no \
	gl_cv_func_link_follows_symlink=no \
	gl_cv_func_re_compile_pattern_working=yes \
	gl_cv_func_svid_putenv=yes \
	gl_cv_func_tzset_clobber=no \
	gl_cv_func_working_mkstemp=yes \
	gl_cv_func_working_utimes=yes \
	gl_getline_needs_run_time_check=no \
	gl_cv_have_proc_uptime=yes \
	utils_cv_localtime_cache=no \
	PERL=missing \
	MAKEINFO=true \
	INSTALL_PROGRAM=$(INSTALL)

COREUTILS_BIN_PROGS = base64 cat chgrp chmod chown cp date dd df dir echo false \
	kill link ln ls mkdir mknod mktemp mv nice printenv pwd rm rmdir \
	vdir sleep stty sync touch true uname join

ifeq ($(BR2_PACKAGE_ACL),y)
COREUTILS_DEPENDENCIES += acl
else
COREUTILS_CONF_OPTS += --disable-acl
endif

ifeq ($(BR2_PACKAGE_ATTR),y)
COREUTILS_DEPENDENCIES += attr
else
COREUTILS_CONF_OPTS += --disable-xattr
endif

COREUTILS_DEPENDENCIES += $(TARGET_NLS_DEPENDENCIES)

# It otherwise fails to link properly, not mandatory though
ifeq ($(BR2_PACKAGE_GETTEXT_PROVIDES_LIBINTL),y)
COREUTILS_CONF_OPTS += --with-libintl-prefix=$(STAGING_DIR)/usr
endif

ifeq ($(BR2_PACKAGE_GMP),y)
COREUTILS_DEPENDENCIES += gmp
else
COREUTILS_CONF_OPTS += --without-gmp
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
COREUTILS_DEPENDENCIES += libcap
else
COREUTILS_CONF_OPTS += --disable-libcap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
COREUTILS_CONF_OPTS += --with-openssl=yes
COREUTILS_DEPENDENCIES += openssl
endif

ifeq ($(BR2_ROOTFS_MERGED_USR),)
# We want to move a few binaries from /usr/bin to /bin. In the case of
# coreutils being built as multi-call binary, we do so by re-creating
# the corresponding symlinks. If coreutils is built with individual
# binaries, we actually move the binaries.
ifeq ($(BR2_PACKAGE_COREUTILS_INDIVIDUAL_BINARIES),y)
define COREUTILS_FIX_BIN_LOCATION
	$(foreach f,$(COREUTILS_BIN_PROGS), \
		mv $(TARGET_DIR)/usr/bin/$(f) $(TARGET_DIR)/bin
	)
endef
else
define COREUTILS_FIX_BIN_LOCATION
	# some things go in /bin rather than /usr/bin
	$(foreach f,$(COREUTILS_BIN_PROGS), \
		rm -f $(TARGET_DIR)/usr/bin/$(f) && \
		ln -sf ../usr/bin/coreutils $(TARGET_DIR)/bin/$(f)
	)
endef
endif
COREUTILS_POST_INSTALL_TARGET_HOOKS += COREUTILS_FIX_BIN_LOCATION
endif

ifeq ($(BR2_STATIC_LIBS),y)
COREUTILS_CONF_OPTS += --enable-no-install-program=stdbuf
endif

# link for archaic shells
define COREUTILS_CREATE_TEST_SYMLINK
	ln -fs test $(TARGET_DIR)/usr/bin/[
endef
COREUTILS_POST_INSTALL_TARGET_HOOKS += COREUTILS_CREATE_TEST_SYMLINK

# gnu thinks chroot is in bin, debian thinks it's in sbin
ifeq ($(BR2_PACKAGE_COREUTILS_INDIVIDUAL_BINARIES),y)
define COREUTILS_FIX_CHROOT_LOCATION
	mv $(TARGET_DIR)/usr/bin/chroot $(TARGET_DIR)/usr/sbin
endef
else
define COREUTILS_FIX_CHROOT_LOCATION
	rm -f $(TARGET_DIR)/usr/bin/chroot
	ln -sf ../bin/coreutils $(TARGET_DIR)/usr/sbin/chroot
endef
endif
COREUTILS_POST_INSTALL_TARGET_HOOKS += COREUTILS_FIX_CHROOT_LOCATION

# Explicitly install ln and realpath, which we *are* insterested in.
# A lot of other programs still get installed, however, but disabling
# them does not gain much at build time, and is a loooong list that is
# difficult to maintain... Just avoid overwriting fakedate when creating
# a reproducible build
HOST_COREUTILS_CONF_OPTS = \
	--disable-acl \
	--disable-libcap \
	--disable-rpath \
	--disable-single-binary \
	--disable-xattr \
	--without-gmp \
	--enable-install-program=ln,realpath \
	--enable-no-install-program=date

$(eval $(autotools-package))
$(eval $(host-autotools-package))
