################################################################################
#
# tmux
#
################################################################################

TMUX_VERSION = 3.1c
TMUX_SITE = https://github.com/tmux/tmux/releases/download/$(TMUX_VERSION)
TMUX_LICENSE = ISC
TMUX_LICENSE_FILES = COPYING
TMUX_CPE_ID_VENDOR = tmux_project
TMUX_DEPENDENCIES = libevent ncurses host-pkgconf

# Add /usr/bin/tmux to /etc/shells otherwise some login tools like dropbear
# can reject the user connection. See man shells.
define TMUX_ADD_TMUX_TO_SHELLS
	grep -qsE '^/usr/bin/tmux$$' $(TARGET_DIR)/etc/shells \
		|| echo "/usr/bin/tmux" >> $(TARGET_DIR)/etc/shells
endef
TMUX_TARGET_FINALIZE_HOOKS += TMUX_ADD_TMUX_TO_SHELLS

$(eval $(autotools-package))
