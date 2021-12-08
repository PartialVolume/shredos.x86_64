################################################################################
#
# xfont_font-misc-ethiopic
#
################################################################################

XFONT_FONT_MISC_ETHIOPIC_VERSION = 1.0.4
XFONT_FONT_MISC_ETHIOPIC_SOURCE = font-misc-ethiopic-$(XFONT_FONT_MISC_ETHIOPIC_VERSION).tar.bz2
XFONT_FONT_MISC_ETHIOPIC_SITE = http://xorg.freedesktop.org/releases/individual/font
XFONT_FONT_MISC_ETHIOPIC_LICENSE = MIT
XFONT_FONT_MISC_ETHIOPIC_LICENSE_FILES = COPYING

XFONT_FONT_MISC_ETHIOPIC_INSTALL_STAGING_OPTS = DESTDIR=$(STAGING_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install
XFONT_FONT_MISC_ETHIOPIC_INSTALL_TARGET_OPTS = DESTDIR=$(TARGET_DIR) MKFONTSCALE=$(HOST_DIR)/bin/mkfontscale MKFONTDIR=$(HOST_DIR)/bin/mkfontdir install-data
XFONT_FONT_MISC_ETHIOPIC_DEPENDENCIES = xfont_font-util host-xfont_font-util host-xapp_mkfontscale host-xapp_bdftopcf

$(eval $(autotools-package))
