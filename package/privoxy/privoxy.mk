################################################################################
#
# privoxy
#
################################################################################

PRIVOXY_VERSION = 3.0.32
PRIVOXY_SITE = http://downloads.sourceforge.net/project/ijbswa/Sources/$(PRIVOXY_VERSION)%20%28stable%29
PRIVOXY_SOURCE = privoxy-$(PRIVOXY_VERSION)-stable-src.tar.gz
# configure not shipped
PRIVOXY_AUTORECONF = YES
PRIVOXY_DEPENDENCIES = pcre zlib
PRIVOXY_LICENSE = GPL-2.0+
PRIVOXY_LICENSE_FILES = LICENSE
PRIVOXY_CPE_ID_VENDOR = privoxy
PRIVOXY_SELINUX_MODULES = privoxy

$(eval $(autotools-package))
