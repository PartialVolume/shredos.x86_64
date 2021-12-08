################################################################################
#
# lshw
#
################################################################################

LSHW_VERSION = 02.19.2
LSHW_SITE = http://ezix.org/software/files
LSHW_SOURCE = lshw-B.$(LSHW_VERSION).tar.gz
LSHW_LICENSE = GPL-2.0
LSHW_LICENSE_FILES = COPYING

LSHW_MAKE_OPTS = CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" AR="$(TARGET_AR)" \
	RPM_OPT_FLAGS="$(TARGET_CFLAGS)" all
LSHW_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	LIBS=$(TARGET_NLS_LIBS)
LSHW_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES)

define LSHW_BUILD_CMDS
	$(LSHW_MAKE_ENV) $(MAKE) -C $(@D)/src $(LSHW_MAKE_OPTS)
endef

define LSHW_INSTALL_TARGET_CMDS
	$(LSHW_MAKE_ENV) $(MAKE) -C $(@D)/src DESTDIR=$(TARGET_DIR) \
		$(LSHW_MAKE_OPTS) install
	$(RM) -rf $(TARGET_DIR)/usr/share/lshw
endef

$(eval $(generic-package))
