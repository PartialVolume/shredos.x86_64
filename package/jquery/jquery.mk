################################################################################
#
# jquery
#
################################################################################

JQUERY_VERSION = 3.5.1
JQUERY_SITE = http://code.jquery.com
JQUERY_SOURCE = jquery-$(JQUERY_VERSION).min.js
JQUERY_LICENSE = MIT
JQUERY_CPE_ID_VENDOR = jquery

define JQUERY_EXTRACT_CMDS
	cp $(JQUERY_DL_DIR)/$(JQUERY_SOURCE) $(@D)
endef

define JQUERY_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/$(JQUERY_SOURCE) \
		$(TARGET_DIR)/var/www/jquery.js
endef

$(eval $(generic-package))
