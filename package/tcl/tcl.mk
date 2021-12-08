################################################################################
#
# tcl
#
################################################################################

TCL_VERSION_MAJOR = 8.6
TCL_VERSION = $(TCL_VERSION_MAJOR).9
TCL_SOURCE = tcl$(TCL_VERSION)-src.tar.gz
TCL_SITE = http://downloads.sourceforge.net/project/tcl/Tcl/$(TCL_VERSION)
TCL_LICENSE = TCL
TCL_LICENSE_FILES = license.terms
TCL_CPE_ID_VENDOR = tcl
TCL_SUBDIR = unix
TCL_INSTALL_STAGING = YES
TCL_AUTORECONF = YES

TCL_CONF_OPTS = \
	--disable-symbols \
	--disable-langinfo \
	--disable-framework

HOST_TCL_CONF_OPTS = \
	--disable-symbols \
	--disable-langinfo \
	--disable-framework

# I haven't found a good way to force pkgs to not build
# or configure without just removing the entire pkg directory.
define HOST_TCL_REMOVE_PACKAGES
	rm -fr $(@D)/pkgs/sqlite3* $(@D)/pkgs/tdbc*
endef
HOST_TCL_PRE_CONFIGURE_HOOKS += HOST_TCL_REMOVE_PACKAGES

# We remove the bundled sqlite as we prefer to not use bundled stuff at all.
define TCL_REMOVE_PACKAGES
	rm -fr $(@D)/pkgs/sqlite3* \
		$(if $(BR2_PACKAGE_MYSQL),,$(@D)/pkgs/tdbcmysql*) \
		$(@D)/pkgs/tdbcodbc* \
		$(if $(BR2_PACKAGE_POSTGRESQL),,$(@D)/pkgs/tdbcpostgres*) \
		$(if $(BR2_PACKAGE_SQLITE),,$(@D)/pkgs/tdbcsqlite3*)
endef
TCL_PRE_CONFIGURE_HOOKS += TCL_REMOVE_PACKAGES

ifeq ($(BR2_PACKAGE_TCL_DEL_ENCODINGS),y)
define TCL_REMOVE_ENCODINGS
	rm -rf $(TARGET_DIR)/usr/lib/tcl$(TCL_VERSION_MAJOR)/encoding/*
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_REMOVE_ENCODINGS
endif

ifeq ($(BR2_PACKAGE_TCL_SHLIB_ONLY),y)
define TCL_REMOVE_TCLSH
	rm -f $(TARGET_DIR)/usr/bin/tclsh$(TCL_VERSION_MAJOR)
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_REMOVE_TCLSH
else
define TCL_SYMLINK_TCLSH
	ln -sf tclsh$(TCL_VERSION_MAJOR) $(TARGET_DIR)/usr/bin/tclsh
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_SYMLINK_TCLSH
endif

# Until someone needs it, we don't handle locale installation.  tcl has
# a complicated method of translating LANG-style locale names into its internal
# .msg name which makes it difficult to save the correct locales per the
# configured whitelist.
define TCL_REMOVE_EXTRA
	rm -fr $(TARGET_DIR)/usr/lib/tclConfig.sh \
		$(TARGET_DIR)/usr/lib/tclooConfig.sh \
		$(TARGET_DIR)/usr/lib/tcl$(TCL_VERSION_MAJOR)/tclAppInit.c \
		$(TARGET_DIR)/usr/lib/tcl$(TCL_VERSION_MAJOR)/msgs
endef
TCL_POST_INSTALL_TARGET_HOOKS += TCL_REMOVE_EXTRA

TCL_DEPENDENCIES = $(if $(BR2_PACKAGE_SQLITE),sqlite) \
	$(if $(BR2_PACKAGE_MYSQL),mysql) \
	$(if $(BR2_PACKAGE_POSTGRESQL),postgresql)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
