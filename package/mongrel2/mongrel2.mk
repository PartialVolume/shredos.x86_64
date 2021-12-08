################################################################################
#
# mongrel2
#
################################################################################

MONGREL2_VERSION = 1.12.2
MONGREL2_SOURCE = mongrel2-v$(MONGREL2_VERSION).tar.bz2
# Do not use the github helper here, the generated tarball is *NOT* the same
# as the one uploaded by upstream for the release.
MONGREL2_SITE = https://github.com/mongrel2/mongrel2/releases/download/v$(MONGREL2_VERSION)
MONGREL2_LICENSE = BSD-3-Clause
MONGREL2_LICENSE_FILES = LICENSE
MONGREL2_DEPENDENCIES = mbedtls sqlite zeromq

define MONGREL2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		PREFIX=/usr all
endef

define MONGREL2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		PREFIX=/usr DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
