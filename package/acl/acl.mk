################################################################################
#
# acl
#
################################################################################

ACL_VERSION = 2.3.1
ACL_SOURCE = acl-$(ACL_VERSION).tar.xz
ACL_SITE = http://download.savannah.gnu.org/releases/acl
ACL_LICENSE = GPL-2.0+ (programs), LGPL-2.1+ (libraries)
ACL_LICENSE_FILES = doc/COPYING doc/COPYING.LGPL
ACL_CPE_ID_VENDOR = acl_project

ACL_DEPENDENCIES = attr
HOST_ACL_DEPENDENCIES = host-attr

ACL_INSTALL_STAGING = YES

ACL_CONF_OPTS = --disable-nls

$(eval $(autotools-package))
$(eval $(host-autotools-package))
