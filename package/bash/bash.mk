################################################################################
#
# bash
#
################################################################################

BASH_VERSION = 5.1
BASH_SITE = $(BR2_GNU_MIRROR)/bash
BASH_DEPENDENCIES = ncurses readline host-bison
BASH_LICENSE = GPL-3.0+
BASH_LICENSE_FILES = COPYING
BASH_CPE_ID_VENDOR = gnu

# We want the bash binary in /bin
BASH_CONF_OPTS = \
	--bindir=/bin \
	--with-installed-readline \
	--without-bash-malloc

BASH_CONF_ENV += \
	ac_cv_rl_prefix="$(STAGING_DIR)" \
	ac_cv_rl_version="$(READLINE_VERSION)" \
	bash_cv_getcwd_malloc=yes \
	bash_cv_job_control_missing=present \
	bash_cv_sys_named_pipes=present \
	bash_cv_func_sigsetjmp=present \
	bash_cv_printf_a_format=yes

# The static build needs some trickery
ifeq ($(BR2_STATIC_LIBS),y)
BASH_CONF_OPTS += --enable-static-link
# bash wants to redefine the getenv() function. To check whether this is
# possible, AC_TRY_RUN is used which is not possible in
# cross-compilation.
# On uClibc, redefining getenv is not possible; on glibc and musl it is.
# Related:
# http://lists.gnu.org/archive/html/bug-bash/2012-03/msg00052.html
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
BASH_CONF_ENV += bash_cv_getenv_redef=no
else
BASH_CONF_ENV += bash_cv_getenv_redef=yes
endif
endif

define BASH_REMOVE_UNUSED_FILES
	rm -f $(TARGET_DIR)/bin/bashbug
endef
BASH_POST_INSTALL_TARGET_HOOKS += BASH_REMOVE_UNUSED_FILES

ifeq ($(BR2_PACKAGE_BASH_LOADABLE_EXAMPLES),y)
define BASH_REMOVE_LOADABLE_UNUSED_FILES
	rm -f $(TARGET_DIR)/usr/lib/bash/Makefile.inc
	rm -f $(TARGET_DIR)/usr/lib/bash/loadables.h
endef
BASH_POST_INSTALL_TARGET_HOOKS += BASH_REMOVE_LOADABLE_UNUSED_FILES
else
define BASH_REMOVE_LOADABLE_EXAMPLES
	rm -rf $(TARGET_DIR)/usr/lib/bash
endef
BASH_POST_INSTALL_TARGET_HOOKS += BASH_REMOVE_LOADABLE_EXAMPLES
endif

# Add /bin/bash to /etc/shells otherwise some login tools like dropbear
# can reject the user connection. See man shells.
define BASH_ADD_MKSH_TO_SHELLS
	grep -qsE '^/bin/bash$$' $(TARGET_DIR)/etc/shells \
		|| echo "/bin/bash" >> $(TARGET_DIR)/etc/shells
endef
BASH_TARGET_FINALIZE_HOOKS += BASH_ADD_MKSH_TO_SHELLS

$(eval $(autotools-package))
