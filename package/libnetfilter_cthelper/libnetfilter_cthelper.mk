################################################################################
#
# libnetfilter_cthelper
#
################################################################################

LIBNETFILTER_CTHELPER_VERSION = 1.0.0
LIBNETFILTER_CTHELPER_SOURCE = libnetfilter_cthelper-$(LIBNETFILTER_CTHELPER_VERSION).tar.bz2
LIBNETFILTER_CTHELPER_SITE = http://www.netfilter.org/projects/libnetfilter_cthelper/files
LIBNETFILTER_CTHELPER_INSTALL_STAGING = YES
LIBNETFILTER_CTHELPER_DEPENDENCIES = host-pkgconf libmnl
LIBNETFILTER_CTHELPER_AUTORECONF = YES
LIBNETFILTER_CTHELPER_LICENSE = GPL-2.0+
LIBNETFILTER_CTHELPER_LICENSE_FILES = COPYING
LIBNETFILTER_CTHELPER_CPE_ID_VENDOR = netfilter

$(eval $(autotools-package))
