################################################################################
#
# s6-dns
#
################################################################################

S6_DNS_VERSION = 2.3.5.1
S6_DNS_SITE = http://skarnet.org/software/s6-dns
S6_DNS_LICENSE = ISC
S6_DNS_LICENSE_FILES = COPYING
S6_DNS_INSTALL_STAGING = YES
S6_DNS_DEPENDENCIES = skalibs

S6_DNS_CONF_OPTS = \
	--prefix=/ \
	--with-sysdeps=$(STAGING_DIR)/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/include \
	--with-dynlib=$(STAGING_DIR)/lib \
	--with-lib=$(STAGING_DIR)/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define S6_DNS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_DNS_CONF_OPTS))
endef

define S6_DNS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_DNS_REMOVE_STATIC_LIB_DIR
	rm -rf $(TARGET_DIR)/usr/lib/s6-dns
endef

S6_DNS_POST_INSTALL_TARGET_HOOKS += S6_DNS_REMOVE_STATIC_LIB_DIR

define S6_DNS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_DNS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
