################################################################################
#
# proftpd
#
################################################################################

PROFTPD_VERSION = 1.3.6e
PROFTPD_SITE = $(call github,proftpd,proftpd,v$(PROFTPD_VERSION))
PROFTPD_LICENSE = GPL-2.0+
PROFTPD_LICENSE_FILES = COPYING
PROFTPD_CPE_ID_VENDOR = proftpd
PROFTPD_SELINUX_MODULES = ftp

PROFTPD_CONF_ENV = \
	ac_cv_func_setpgrp_void=yes \
	ac_cv_func_setgrent_void=yes

PROFTPD_CONF_OPTS = \
	--localstatedir=/var/run \
	--disable-static \
	--disable-curses \
	--disable-ncurses \
	--disable-facl \
	--disable-dso \
	--enable-sendfile \
	--enable-shadow \
	--with-gnu-ld \
	--without-openssl-cmdline

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_CAP),y)
PROFTPD_CONF_OPTS += --enable-cap
PROFTPD_DEPENDENCIES += libcap
else
PROFTPD_CONF_OPTS += --disable-cap
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_REWRITE),y)
PROFTPD_MODULES += mod_rewrite
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_REDIS),y)
PROFTPD_CONF_OPTS += --enable-redis
PROFTPD_DEPENDENCIES += hiredis
else
PROFTPD_CONF_OPTS += --disable-redis
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_SFTP),y)
PROFTPD_CONF_OPTS += --enable-openssl
PROFTPD_MODULES += mod_sftp
PROFTPD_DEPENDENCIES += openssl
else
PROFTPD_CONF_OPTS += --disable-openssl
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_SQL),y)
PROFTPD_MODULES += mod_sql
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_SQL_SQLITE),y)
PROFTPD_MODULES += mod_sql_sqlite
PROFTPD_DEPENDENCIES += sqlite
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_SFTP_SQL),y)
PROFTPD_MODULES += mod_sftp_sql
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_QUOTATAB),y)
PROFTPD_MODULES += mod_quotatab
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_QUOTATAB_FILE),y)
PROFTPD_MODULES += mod_quotatab_file
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_QUOTATAB_LDAP),y)
PROFTPD_MODULES += mod_quotatab_ldap
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_QUOTATAB_RADIUS),y)
PROFTPD_MODULES += mod_quotatab_radius
endif

ifeq ($(BR2_PACKAGE_PROFTPD_MOD_QUOTATAB_SQL),y)
PROFTPD_MODULES += mod_quotatab_sql
endif

PROFTPD_CONF_OPTS += --with-modules=$(subst $(space),:,$(PROFTPD_MODULES))

# configure script doesn't handle detection of %llu format string
# support for printing the file size when cross compiling, breaking
# access for large files.
# We unfortunately cannot AUTORECONF the package, so instead force it
# on if we know we support it
define PROFTPD_USE_LLU
	$(SED) 's/HAVE_LU/HAVE_LLU/' $(@D)/configure
endef
PROFTPD_PRE_CONFIGURE_HOOKS += PROFTPD_USE_LLU

PROFTPD_MAKE = $(MAKE1)

# install Perl based scripts in target
ifeq ($(BR2_PACKAGE_PERL),y)
ifeq ($(BR2_PACKAGE_PROFTPD_MOD_QUOTATAB),y)
define PROFTPD_INSTALL_FTPQUOTA
	$(INSTALL) -D -m 0755 $(@D)/contrib/ftpquota $(TARGET_DIR)/usr/sbin/ftpquota
endef
endif
define PROFTPD_INSTALL_FTPASSWD
	$(INSTALL) -D -m 0755 $(@D)/contrib/ftpasswd $(TARGET_DIR)/usr/sbin/ftpasswd
endef
endif

define PROFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/proftpd $(TARGET_DIR)/usr/sbin/proftpd
	$(INSTALL) -m 0644 -D $(@D)/sample-configurations/basic.conf $(TARGET_DIR)/etc/proftpd.conf
	$(PROFTPD_INSTALL_FTPQUOTA)
	$(PROFTPD_INSTALL_FTPASSWD)
endef

define PROFTPD_USERS
	ftp -1 ftp -1 * /home/ftp - - Anonymous FTP User
endef

define PROFTPD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/proftpd/S50proftpd $(TARGET_DIR)/etc/init.d/S50proftpd
endef

define PROFTPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/proftpd/proftpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/proftpd.service
endef

ifneq ($(BR2_PACKAGE_PROFTPD_BUFFER_SIZE),0)
PROFTPD_CONF_OPTS += --enable-buffer-size=$(BR2_PACKAGE_PROFTPD_BUFFER_SIZE)
endif

$(eval $(autotools-package))
