################################################################################
#
# python
#
################################################################################

PYTHON_VERSION_MAJOR = 2.7
PYTHON_VERSION = $(PYTHON_VERSION_MAJOR).18
PYTHON_SOURCE = Python-$(PYTHON_VERSION).tar.xz
PYTHON_SITE = https://python.org/ftp/python/$(PYTHON_VERSION)
PYTHON_LICENSE = Python-2.0, others
PYTHON_LICENSE_FILES = LICENSE
PYTHON_CPE_ID_VENDOR = python
PYTHON_LIBTOOL_PATCH = NO

# Python needs itself to be built, so in order to cross-compile
# Python, we need to build a host Python first. This host Python is
# also installed in $(HOST_DIR), as it is needed when cross-compiling
# third-party Python modules.

HOST_PYTHON_CONF_OPTS += \
	--enable-static \
	--without-cxx-main \
	--disable-sqlite3 \
	--disable-tk \
	--with-expat=system \
	--with-system-ffi \
	--disable-curses \
	--disable-codecs-cjk \
	--disable-nis \
	--enable-unicodedata \
	--disable-dbm \
	--disable-gdbm \
	--disable-bsddb \
	--disable-test-modules \
	--disable-bz2 \
	--disable-ossaudiodev \
	--disable-pyo-build

# Make sure that LD_LIBRARY_PATH overrides -rpath.
# This is needed because libpython may be installed at the same time that
# python is called.
# Make python believe we don't have 'hg' and 'svn', so that it doesn't
# try to communicate over the network during the build.
HOST_PYTHON_CONF_ENV += \
	LDFLAGS="$(HOST_LDFLAGS) -Wl,--enable-new-dtags" \
	ac_cv_prog_HAS_HG=/bin/false \
	ac_cv_prog_SVNVERSION=/bin/false

# Building host python in parallel sometimes triggers a "Bus error"
# during the execution of "./python setup.py build" in the
# installation step. It is probably due to the installation of a
# shared library taking place in parallel to the execution of
# ./python, causing spurious Bus error. Building host-python with
# MAKE1 has shown to workaround the problem.
HOST_PYTHON_MAKE = $(MAKE1)

PYTHON_DEPENDENCIES = host-python libffi $(TARGET_NLS_DEPENDENCIES)

HOST_PYTHON_DEPENDENCIES = host-expat host-libffi host-zlib

ifeq ($(BR2_PACKAGE_HOST_PYTHON_SSL),y)
HOST_PYTHON_DEPENDENCIES += host-openssl
else
HOST_PYTHON_CONF_OPTS += --disable-ssl
endif

PYTHON_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_PYTHON_READLINE),y)
PYTHON_DEPENDENCIES += readline
else
PYTHON_CONF_OPTS += --disable-readline
endif

ifeq ($(BR2_PACKAGE_PYTHON_CURSES),y)
PYTHON_DEPENDENCIES += ncurses
else
PYTHON_CONF_OPTS += --disable-curses
endif

ifeq ($(BR2_PACKAGE_PYTHON_PYEXPAT),y)
PYTHON_DEPENDENCIES += expat
PYTHON_CONF_OPTS += --with-expat=system
else
PYTHON_CONF_OPTS += --with-expat=none
endif

ifeq ($(BR2_PACKAGE_PYTHON_BSDDB),y)
PYTHON_DEPENDENCIES += berkeleydb
else
PYTHON_CONF_OPTS += --disable-bsddb
endif

ifeq ($(BR2_PACKAGE_PYTHON_SQLITE),y)
PYTHON_DEPENDENCIES += sqlite
else
PYTHON_CONF_OPTS += --disable-sqlite3
endif

ifeq ($(BR2_PACKAGE_PYTHON_SSL),y)
PYTHON_DEPENDENCIES += openssl
else
PYTHON_CONF_OPTS += --disable-ssl
endif

ifneq ($(BR2_PACKAGE_PYTHON_CODECSCJK),y)
PYTHON_CONF_OPTS += --disable-codecs-cjk
endif

ifneq ($(BR2_PACKAGE_PYTHON_UNICODEDATA),y)
PYTHON_CONF_OPTS += --disable-unicodedata
endif

# Default is UCS2 w/o a conf opt
ifeq ($(BR2_PACKAGE_PYTHON_UCS4),y)
# host-python must have the same UCS2/4 configuration as the target
# python
HOST_PYTHON_CONF_OPTS += --enable-unicode=ucs4
PYTHON_CONF_OPTS += --enable-unicode=ucs4
endif

ifeq ($(BR2_PACKAGE_PYTHON_2TO3),y)
PYTHON_CONF_OPTS += --enable-lib2to3
else
PYTHON_CONF_OPTS += --disable-lib2to3
endif

ifeq ($(BR2_PACKAGE_PYTHON_BZIP2),y)
PYTHON_DEPENDENCIES += bzip2
else
PYTHON_CONF_OPTS += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_PYTHON_ZLIB),y)
PYTHON_DEPENDENCIES += zlib
else
PYTHON_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_PYTHON_HASHLIB),y)
PYTHON_DEPENDENCIES += openssl
else
PYTHON_CONF_OPTS += --disable-hashlib
endif

ifeq ($(BR2_PACKAGE_PYTHON_OSSAUDIODEV),y)
PYTHON_CONF_OPTS += --enable-ossaudiodev
else
PYTHON_CONF_OPTS += --disable-ossaudiodev
endif

# Make python believe we don't have 'hg' and 'svn', so that it doesn't
# try to communicate over the network during the build.
PYTHON_CONF_ENV += \
	ac_cv_have_long_long_format=yes \
	ac_cv_file__dev_ptmx=yes \
	ac_cv_file__dev_ptc=yes \
	ac_cv_working_tzset=yes \
	ac_cv_prog_HAS_HG=/bin/false \
	ac_cv_prog_SVNVERSION=/bin/false

# GCC is always compliant with IEEE754
ifeq ($(BR2_ENDIAN),"LITTLE")
PYTHON_CONF_ENV += ac_cv_little_endian_double=yes
else
PYTHON_CONF_ENV += ac_cv_big_endian_double=yes
endif

PYTHON_CONF_OPTS += \
	--without-cxx-main \
	--without-doc-strings \
	--with-system-ffi \
	--disable-pydoc \
	--disable-test-modules \
	--disable-gdbm \
	--disable-tk \
	--disable-nis \
	--disable-dbm \
	--disable-pyo-build \
	--disable-pyc-build

# This is needed to make sure the Python build process doesn't try to
# regenerate those files with the pgen program. Otherwise, it builds
# pgen for the target, and tries to run it on the host.

define PYTHON_TOUCH_GRAMMAR_FILES
	touch $(@D)/Include/graminit.h $(@D)/Python/graminit.c
endef

PYTHON_POST_PATCH_HOOKS += PYTHON_TOUCH_GRAMMAR_FILES

#
# Remove useless files. In the config/ directory, only the Makefile
# and the pyconfig.h files are needed at runtime.
#
# idle & smtpd.py have bad shebangs and are mostly samples
#
define PYTHON_REMOVE_USELESS_FILES
	rm -f $(TARGET_DIR)/usr/bin/python$(PYTHON_VERSION_MAJOR)-config
	rm -f $(TARGET_DIR)/usr/bin/python2-config
	rm -f $(TARGET_DIR)/usr/bin/python-config
	rm -f $(TARGET_DIR)/usr/bin/smtpd.py
	rm -f $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/distutils/command/wininst*.exe
	for i in `find $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/config/ \
		-type f -not -name pyconfig.h -a -not -name Makefile` ; do \
		rm -f $$i ; \
	done
endef

PYTHON_POST_INSTALL_TARGET_HOOKS += PYTHON_REMOVE_USELESS_FILES

#
# Make sure libpython gets stripped out on target
#
define PYTHON_ENSURE_LIBPYTHON_STRIPPED
	chmod u+w $(TARGET_DIR)/usr/lib/libpython$(PYTHON_VERSION_MAJOR)*.so
endef

PYTHON_POST_INSTALL_TARGET_HOOKS += PYTHON_ENSURE_LIBPYTHON_STRIPPED

# Always install the python symlink in the target tree
define PYTHON_INSTALL_TARGET_PYTHON_SYMLINK
	ln -sf python2 $(TARGET_DIR)/usr/bin/python
endef

PYTHON_POST_INSTALL_TARGET_HOOKS += PYTHON_INSTALL_TARGET_PYTHON_SYMLINK

# Always install the python-config symlink in the staging tree
define PYTHON_INSTALL_STAGING_PYTHON_CONFIG_SYMLINK
	ln -sf python2-config $(STAGING_DIR)/usr/bin/python-config
endef

PYTHON_POST_INSTALL_STAGING_HOOKS += PYTHON_INSTALL_STAGING_PYTHON_CONFIG_SYMLINK

PYTHON_AUTORECONF = YES

# Some packages may have build scripts requiring python2.
# Only install the python symlink in the host tree if python3 is not enabled
# for the target, otherwise the default python program may be missing.
ifneq ($(BR2_PACKAGE_PYTHON3),y)
define HOST_PYTHON_INSTALL_PYTHON_SYMLINK
	ln -sf python2 $(HOST_DIR)/bin/python
	ln -sf python2-config $(HOST_DIR)/bin/python-config
endef

HOST_PYTHON_POST_INSTALL_HOOKS += HOST_PYTHON_INSTALL_PYTHON_SYMLINK
endif

# Provided to other packages
PYTHON_PATH = $(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/sysconfigdata/

$(eval $(autotools-package))
$(eval $(host-autotools-package))

ifeq ($(BR2_REPRODUCIBLE),y)
define PYTHON_FIX_TIME
	find $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR) -name '*.py' -print0 | \
		xargs -0 --no-run-if-empty touch -d @$(SOURCE_DATE_EPOCH)
endef
endif

define PYTHON_CREATE_PYC_FILES
	$(PYTHON_FIX_TIME)
	PYTHONPATH="$(PYTHON_PATH)" \
	$(HOST_DIR)/bin/python$(PYTHON_VERSION_MAJOR) \
		$(TOPDIR)/support/scripts/pycompile.py \
		$(if $(VERBOSE),--verbose) \
		--strip-root $(TARGET_DIR) \
		$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)
endef

ifeq ($(BR2_PACKAGE_PYTHON_PYC_ONLY)$(BR2_PACKAGE_PYTHON_PY_PYC),y)
PYTHON_TARGET_FINALIZE_HOOKS += PYTHON_CREATE_PYC_FILES
endif

ifeq ($(BR2_PACKAGE_PYTHON_PYC_ONLY),y)
define PYTHON_REMOVE_PY_FILES
	find $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR) -name '*.py' \
		$(if $(strip $(KEEP_PYTHON_PY_FILES)),-not \( $(call finddirclauses,$(TARGET_DIR),$(KEEP_PYTHON_PY_FILES)) \) ) \
		-print0 | \
		xargs -0 --no-run-if-empty rm -f
endef
PYTHON_TARGET_FINALIZE_HOOKS += PYTHON_REMOVE_PY_FILES
endif

# Normally, *.pyc files should not have been compiled, but just in
# case, we make sure we remove all of them.
ifeq ($(BR2_PACKAGE_PYTHON_PY_ONLY),y)
define PYTHON_REMOVE_PYC_FILES
	find $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR) -name '*.pyc' -print0 | \
		xargs -0 --no-run-if-empty rm -f
endef
PYTHON_TARGET_FINALIZE_HOOKS += PYTHON_REMOVE_PYC_FILES
endif

# In all cases, we don't want to keep the optimized .pyo files
define PYTHON_REMOVE_PYO_FILES
	find $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR) -name '*.pyo' -print0 | \
		xargs -0 --no-run-if-empty rm -f
endef
PYTHON_TARGET_FINALIZE_HOOKS += PYTHON_REMOVE_PYO_FILES
