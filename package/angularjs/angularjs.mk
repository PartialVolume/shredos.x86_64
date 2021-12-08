################################################################################
#
# angularjs
#
################################################################################

ANGULARJS_VERSION = 1.8.2
ANGULARJS_SOURCE = angular-$(ANGULARJS_VERSION).zip
ANGULARJS_SITE = https://code.angularjs.org/$(ANGULARJS_VERSION)
ANGULARJS_LICENSE = MIT
# There's no separate license file in the archive, so use angular.js instead.
ANGULARJS_LICENSE_FILES = angular.js
ANGULARJS_CPE_ID_VENDOR = angularjs
ANGULARJS_CPE_ID_PRODUCT = angular.js

define ANGULARJS_EXTRACT_CMDS
	unzip $(ANGULARJS_DL_DIR)/$(ANGULARJS_SOURCE) -d $(@D)
	mv $(@D)/angular-$(ANGULARJS_VERSION)/* $(@D)
	rmdir $(@D)/angular-$(ANGULARJS_VERSION)
endef

# install .min.js as .js
define ANGULARJS_INSTALL_TARGET_CMDS
	$(foreach f,$(notdir $(wildcard $(@D)/*.min.js)),
		$(INSTALL) -m 0644 -D $(@D)/$(f) \
			$(TARGET_DIR)/var/www/$(f:.min.js=.js)$(sep))
endef

$(eval $(generic-package))
