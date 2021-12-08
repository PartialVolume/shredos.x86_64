################################################################################
#
# ipset
#
################################################################################

IPSET_VERSION = 7.11
IPSET_SOURCE = ipset-$(IPSET_VERSION).tar.bz2
IPSET_SITE = http://ipset.netfilter.org
IPSET_DEPENDENCIES = libmnl host-pkgconf
IPSET_CONF_OPTS = --with-kmod=no
IPSET_LICENSE = GPL-2.0
IPSET_LICENSE_FILES = COPYING
IPSET_CPE_ID_VENDOR = netfilter
IPSET_INSTALL_STAGING = YES
IPSET_SELINUX_MODULES = iptables

$(eval $(autotools-package))
