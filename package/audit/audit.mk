################################################################################
#
# audit
#
################################################################################

AUDIT_VERSION = 3.0.1
AUDIT_SITE = http://people.redhat.com/sgrubb/audit
AUDIT_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
AUDIT_LICENSE_FILES = COPYING COPYING.LIB
AUDIT_CPE_ID_VENDOR = linux_audit_project
AUDIT_CPE_ID_PRODUCT = linux_audit

AUDIT_INSTALL_STAGING = YES

AUDIT_CONF_OPTS = --without-python --without-python3 --disable-zos-remote

ifeq ($(BR2_PACKAGE_LIBCAP_NG),y)
AUDIT_DEPENDENCIES += libcap-ng
AUDIT_CONF_OPTS += --with-libcap-ng=yes
else
AUDIT_CONF_OPTS += --with-libcap-ng=no
endif

# For i386, x86-64 and PowerPC, the system call tables are
# unconditionally included. However, for ARM(eb) and AArch64, then
# need to be explicitly enabled.

ifeq ($(BR2_arm)$(BR2_armeb),y)
AUDIT_CONF_OPTS += --with-arm
endif
ifeq ($(BR2_aarch64),y)
AUDIT_CONF_OPTS += --with-aarch64
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
AUDIT_CONF_OPTS += --enable-systemd
else
AUDIT_CONF_OPTS += --disable-systemd
endif

define AUDIT_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/audit/S02auditd $(TARGET_DIR)/etc/init.d/S02auditd
endef

define AUDIT_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/audit/audit_tmpfiles.conf \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/audit.conf
endef

define AUDIT_INSTALL_CLEANUP
	$(RM) $(TARGET_DIR)/etc/rc.d/init.d/auditd
	$(RM) $(TARGET_DIR)/etc/sysconfig/auditd
endef
AUDIT_POST_INSTALL_TARGET_HOOKS += AUDIT_INSTALL_CLEANUP

define AUDIT_LINUX_CONFIG_FIXUPS
	$(call KCONFIG_ENABLE_OPT,CONFIG_NET)
	$(call KCONFIG_ENABLE_OPT,CONFIG_AUDIT)
endef

HOST_AUDIT_CONF_OPTS = \
	--without-python \
	--without-python3 \
	--disable-zos-remote \
	--without-libcap-ng

$(eval $(autotools-package))
$(eval $(host-autotools-package))
