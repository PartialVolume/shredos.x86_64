################################################################################
#
# vde2
#
################################################################################

VDE2_VERSION = 2.3.2
VDE2_SOURCE = vde2-$(VDE2_VERSION).tar.bz2
VDE2_SITE = http://downloads.sourceforge.net/project/vde/vde2/$(VDE2_VERSION)
VDE2_LICENSE = GPL-2.0+, LGPL-2.1+, BSD-3-Clause
VDE2_LICENSE_FILES = COPYING COPYING.libvdeplug COPYING.slirpvde
VDE2_CPE_ID_VENDOR = vde_project
VDE2_CPE_ID_PRODUCT = vde
VDE2_INSTALL_STAGING = YES

# We touch configure.ac, so we need to autoreconf
VDE2_AUTORECONF = YES

# Reasons for enabling/disabling stuff:
# - tuntap is enabled in the hope we're using a recent-enough toolchain
#   that does have if_tun.h (virtually everything these days)
# - kvde_switch is disabled because it requires a patched kernel
# - cryptcab is disabled to not depend on openSSL
# - python is disabled to not depend on Python
# - pcap is disabled to not depend on libpcap
# - profiling is disabled because we do not want to debug/profile
#
# Note: disabled features can be added with corresponding dependencies
#       in future commits.
VDE2_CONF_OPTS = \
	--disable-cryptcab \
	--disable-experimental \
	--disable-kernel-switch \
	--disable-pcap \
	--disable-profile \
	--disable-python \
	--enable-tuntap

# Package does not build in parallel due to improper make rules
VDE2_MAKE = $(MAKE1)

HOST_VDE2_CONF_OPTS = \
	--disable-cryptcab \
	--disable-experimental \
	--disable-kernel-switch \
	--disable-pcap \
	--disable-profile \
	--disable-python \
	--enable-tuntap

HOST_VDE2_MAKE = $(MAKE1)

$(eval $(autotools-package))
$(eval $(host-autotools-package))
