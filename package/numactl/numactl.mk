################################################################################
#
# numactl
#
################################################################################

NUMACTL_VERSION = 2.0.14
NUMACTL_SITE = $(call github,numactl,numactl,v$(NUMACTL_VERSION))
NUMACTL_LICENSE = LGPL-2.1 (libnuma), GPL-2.0 (programs)
NUMACTL_LICENSE_FILES = README.md
NUMACTL_INSTALL_STAGING = YES
NUMACTL_AUTORECONF = YES
NUMACTL_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -fPIC"

$(eval $(autotools-package))
