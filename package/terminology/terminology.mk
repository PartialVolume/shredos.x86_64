################################################################################
#
# terminology
#
################################################################################

TERMINOLOGY_VERSION = 1.9.0
TERMINOLOGY_SOURCE = terminology-$(TERMINOLOGY_VERSION).tar.xz
TERMINOLOGY_SITE = https://download.enlightenment.org/rel/apps/terminology
TERMINOLOGY_LICENSE = BSD-2-Clause
TERMINOLOGY_LICENSE_FILES = COPYING
TERMINOLOGY_CPE_ID_VENDOR = enlightenment

TERMINOLOGY_DEPENDENCIES = $(TARGET_NLS_DEPENDENCIES) efl host-pkgconf
TERMINOLOGY_CONF_OPTS = \
	-Dedje-cc=$(HOST_DIR)/bin/edje_cc \
	-Deet=$(HOST_DIR)/bin/eet

ifeq ($(BR2_SYSTEM_ENABLE_NLS),y)
TERMINOLOGY_CONF_OPTS += -Dnls=true
else
TERMINOLOGY_CONF_OPTS += -Dnls=false
endif

$(eval $(meson-package))
