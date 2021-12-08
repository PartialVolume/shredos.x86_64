################################################################################
#
# nfs-utils
#
################################################################################

NFS_UTILS_VERSION = 2.5.4
NFS_UTILS_SOURCE = nfs-utils-$(NFS_UTILS_VERSION).tar.xz
NFS_UTILS_SITE = https://www.kernel.org/pub/linux/utils/nfs-utils/$(NFS_UTILS_VERSION)
NFS_UTILS_LICENSE = GPL-2.0+
NFS_UTILS_LICENSE_FILES = COPYING
NFS_UTILS_DEPENDENCIES = host-nfs-utils host-pkgconf libtirpc util-linux
NFS_UTILS_CPE_ID_VENDOR = linux-nfs
NFS_UTILS_AUTORECONF = YES

NFS_UTILS_CONF_ENV = knfsd_cv_bsd_signals=no

NFS_UTILS_CONF_OPTS = \
	--enable-tirpc \
	--enable-ipv6 \
	--without-tcp-wrappers \
	--with-statedir=/run/nfs \
	--with-rpcgen=$(HOST_DIR)/bin/rpcgen

HOST_NFS_UTILS_DEPENDENCIES = host-pkgconf host-libtirpc

HOST_NFS_UTILS_CONF_OPTS = \
	--enable-tirpc \
	--disable-nfsv4 \
	--disable-nfsv41 \
	--disable-gss \
	--disable-uuid \
	--disable-ipv6 \
	--without-tcp-wrappers \
	--with-statedir=/run/nfs \
	--disable-caps \
	--without-systemd \
	--with-rpcgen=internal \
	--with-tirpcinclude=$(HOST_DIR)/include/tirpc

NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPCDEBUG) += usr/sbin/rpcdebug
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_LOCKD) += usr/sbin/rpc.lockd
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_RQUOTAD) += usr/sbin/rpc.rquotad
NFS_UTILS_TARGETS_$(BR2_PACKAGE_NFS_UTILS_RPC_NFSD) += usr/sbin/exportfs \
	usr/sbin/rpc.mountd usr/sbin/rpc.nfsd usr/lib/systemd/system/nfs-server.service

ifeq ($(BR2_PACKAGE_NFS_UTILS_NFSV4),y)
NFS_UTILS_CONF_OPTS += --enable-nfsv4 --enable-nfsv41
NFS_UTILS_DEPENDENCIES += keyutils libevent lvm2 sqlite
else
NFS_UTILS_CONF_OPTS += --disable-nfsv4 --disable-nfsv41
endif

ifeq ($(BR2_PACKAGE_NFS_UTILS_GSS),y)
NFS_UTILS_CONF_OPTS += \
	--enable-gss \
	--enable-svcgss \
	--with-krb5=$(STAGING_DIR)/usr
NFS_UTILS_DEPENDENCIES += libkrb5
else
NFS_UTILS_CONF_OPTS += --disable-gss --disable-svcgss
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
NFS_UTILS_CONF_OPTS += --enable-caps
NFS_UTILS_DEPENDENCIES += libcap
else
NFS_UTILS_CONF_OPTS += --disable-caps
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),y)
NFS_UTILS_CONF_OPTS += --enable-uuid
else
NFS_UTILS_CONF_OPTS += --disable-uuid
endif

define NFS_UTILS_INSTALL_FIXUP
	cd $(TARGET_DIR) && rm -f $(NFS_UTILS_TARGETS_)
	touch $(TARGET_DIR)/etc/exports
	$(INSTALL) -D -m 644 \
		$(@D)/utils/mount/nfsmount.conf $(TARGET_DIR)/etc/nfsmount.conf
endef
NFS_UTILS_POST_INSTALL_TARGET_HOOKS += NFS_UTILS_INSTALL_FIXUP

ifeq ($(BR2_INIT_SYSTEMD),y)
NFS_UTILS_CONF_OPTS += --with-systemd=/usr/lib/systemd/system
NFS_UTILS_DEPENDENCIES += systemd
else
NFS_UTILS_CONF_OPTS += --without-systemd
endif

ifeq ($(BR2_PACKAGE_NFS_UTILS_RPC_NFSD),y)
define NFS_UTILS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/nfs-utils/S60nfs \
		$(TARGET_DIR)/etc/init.d/S60nfs
endef

endif

define NFS_UTILS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0755 package/nfs-utils/nfs-utils_env.sh \
		$(TARGET_DIR)/usr/libexec/nfs-utils/nfs-utils_env.sh

	$(INSTALL) -D -m 0644 package/nfs-utils/nfs-utils_tmpfiles.conf \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/nfs-utils.conf
endef

define NFS_UTILS_REMOVE_NFSIOSTAT
	rm -f $(TARGET_DIR)/usr/sbin/nfsiostat
endef

# nfsiostat is interpreted python, so remove it unless it's in the target
NFS_UTILS_POST_INSTALL_TARGET_HOOKS += $(if $(BR2_PACKAGE_PYTHON),,NFS_UTILS_REMOVE_NFSIOSTAT)

define HOST_NFS_UTILS_BUILD_CMDS
	$(MAKE) -C $(@D)/tools/rpcgen
endef

define HOST_NFS_UTILS_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/tools/rpcgen/rpcgen $(HOST_DIR)/bin/rpcgen
endef

$(eval $(autotools-package))
$(eval $(host-autotools-package))
