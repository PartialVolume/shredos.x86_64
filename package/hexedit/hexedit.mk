################################################################################
#
# hexedit 
#
################################################################################

HEXEDIT_VERSION = 1.4.2 
HEXEDIT_SITE = $(call github,pixel,hexedit,$(HEXEDIT_VERSION))
HEXEDIT_DEPENDENCIES = ncurses parted 

define HEXEDIT_INITSH
	(cd $(@D) && ./autogen.sh);
endef

HEXEDIT_POST_PATCH_HOOKS += HEXEDIT_INITSH


$(eval $(autotools-package))
