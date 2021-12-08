################################################################################
#
# s6-linux-init
#
################################################################################

S6_LINUX_INIT_VERSION = 1.0.6.3
S6_LINUX_INIT_SITE = http://skarnet.org/software/s6-linux-init
S6_LINUX_INIT_LICENSE = ISC
S6_LINUX_INIT_LICENSE_FILES = COPYING
S6_LINUX_INIT_DEPENDENCIES = s6 s6-linux-utils s6-portable-utils

S6_LINUX_INIT_CONF_OPTS = \
	--prefix=/ \
	--with-sysdeps=$(STAGING_DIR)/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/include \
	--with-dynlib=$(STAGING_DIR)/lib \
	--with-lib=$(STAGING_DIR)/lib/execline \
	--with-lib=$(STAGING_DIR)/lib/s6 \
	--with-lib=$(STAGING_DIR)/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define S6_LINUX_INIT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_LINUX_INIT_CONF_OPTS))
endef

define S6_LINUX_INIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_LINUX_INIT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
