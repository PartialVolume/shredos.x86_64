################################################################################
#
# s6-networking
#
################################################################################

S6_NETWORKING_VERSION = 2.4.1.1
S6_NETWORKING_SITE = http://skarnet.org/software/s6-networking
S6_NETWORKING_LICENSE = ISC
S6_NETWORKING_LICENSE_FILES = COPYING
S6_NETWORKING_INSTALL_STAGING = YES
S6_NETWORKING_DEPENDENCIES = s6-dns s6

S6_NETWORKING_CONF_OPTS = \
	--prefix=/ \
	--with-sysdeps=$(STAGING_DIR)/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/include \
	--with-dynlib=$(STAGING_DIR)/lib \
	--with-lib=$(STAGING_DIR)/lib/execline \
	--with-lib=$(STAGING_DIR)/lib/s6 \
	--with-lib=$(STAGING_DIR)/lib/s6-dns \
	--with-lib=$(STAGING_DIR)/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

ifeq ($(BR2_PACKAGE_LIBRESSL),y)
S6_NETWORKING_CONF_OPTS += --enable-ssl=libressl
S6_NETWORKING_DEPENDENCIES += libressl
else ifeq ($(BR2_PACKAGE_BEARSSL),y)
S6_NETWORKING_CONF_OPTS += --enable-ssl=bearssl
S6_NETWORKING_DEPENDENCIES += bearssl
endif

define S6_NETWORKING_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_NETWORKING_CONF_OPTS))
endef

define S6_NETWORKING_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_NETWORKING_REMOVE_STATIC_LIB_DIR
	rm -rf $(TARGET_DIR)/usr/lib/s6-networking
endef

S6_NETWORKING_POST_INSTALL_TARGET_HOOKS += S6_NETWORKING_REMOVE_STATIC_LIB_DIR

define S6_NETWORKING_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

define S6_NETWORKING_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(STAGING_DIR) install
endef

$(eval $(generic-package))
