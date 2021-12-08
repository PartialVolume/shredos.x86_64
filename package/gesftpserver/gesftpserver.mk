################################################################################
#
# gesftpserver
#
################################################################################

GESFTPSERVER_VERSION = 1
GESFTPSERVER_SOURCE = sftpserver-$(GESFTPSERVER_VERSION).tar.gz
GESFTPSERVER_SITE = http://www.greenend.org.uk/rjk/sftpserver
GESFTPSERVER_LICENSE = GPL-2.0+
GESFTPSERVER_LICENSE_FILES = COPYING

# "Missing prototype" warning treated as error
GESFTPSERVER_CONF_OPTS = --disable-warnings-as-errors
GESFTPSERVER_CPE_ID_VENDOR = green_end
GESFTPSERVER_CPE_ID_PRODUCT = sftpserver

# forgets to link against pthread when cross compiling
GESFTPSERVER_CONF_ENV = LIBS=-lpthread

# overwrite openssh version if enabled
GESFTPSERVER_DEPENDENCIES += \
	$(if $(BR2_ENABLE_LOCALE),,libiconv) \
	$(if $(BR2_PACKAGE_OPENSSH),openssh)

# Python on the host is only used for tests, which we don't use in
# Buildroot
GESFTPSERVER_CONF_ENV += rjk_cv_python24=false

# openssh/dropbear looks here
define GESFTPSERVER_ADD_SYMLINK
	ln -sf gesftpserver $(TARGET_DIR)/usr/libexec/sftp-server
endef

GESFTPSERVER_POST_INSTALL_TARGET_HOOKS += GESFTPSERVER_ADD_SYMLINK

$(eval $(autotools-package))
