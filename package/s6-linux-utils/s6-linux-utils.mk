################################################################################
#
# s6-linux-utils
#
################################################################################

S6_LINUX_UTILS_VERSION = 2.5.1.5
S6_LINUX_UTILS_SITE = http://skarnet.org/software/s6-linux-utils
S6_LINUX_UTILS_LICENSE = ISC
S6_LINUX_UTILS_LICENSE_FILES = COPYING
S6_LINUX_UTILS_DEPENDENCIES = skalibs

S6_LINUX_UTILS_CONF_OPTS = \
	--prefix=/ \
	--with-sysdeps=$(STAGING_DIR)/lib/skalibs/sysdeps \
	--with-include=$(STAGING_DIR)/include \
	--with-dynlib=$(STAGING_DIR)/lib \
	--with-lib=$(STAGING_DIR)/lib/skalibs \
	$(if $(BR2_STATIC_LIBS),,--disable-allstatic) \
	$(SHARED_STATIC_LIBS_OPTS)

define S6_LINUX_UTILS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_CONFIGURE_OPTS) ./configure $(S6_LINUX_UTILS_CONF_OPTS))
endef

define S6_LINUX_UTILS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define S6_LINUX_UTILS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
