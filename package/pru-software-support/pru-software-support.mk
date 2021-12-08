################################################################################
#
# pru-software-support
#
################################################################################

PRU_SOFTWARE_SUPPORT_VERSION = 5.7.0
PRU_SOFTWARE_SUPPORT_SITE = https://git.ti.com/cgit/pru-software-support-package/pru-software-support-package/snapshot
PRU_SOFTWARE_SUPPORT_SOURCE = $(PRU_SOFTWARE_SUPPORT_NAME)-package-v$(PRU_SOFTWARE_SUPPORT_VERSION).tar.gz
PRU_SOFTWARE_SUPPORT_LICENSE =  BSD-3-Clause, Public Domain
PRU_SOFTWARE_SUPPORT_LICENSE_FILES = PRU-Package-v6.1-Manifest.html
PRU_SOFTWARE_SUPPORT_DEPENDENCIES = host-ti-cgt-pru host-pru-software-support
HOST_PRU_SOFTWARE_SUPPORT_DEPENDENCIES = host-ti-cgt-pru

define HOST_PRU_SOFTWARE_SUPPORT_BUILD_CMDS
	$(MAKE) PRU_CGT=$(TI_CGT_PRU_INSTALLDIR) -C $(@D)/lib/src
endef

# install this library support alongside PRU toolchain i.e.
# everything in TI_CGT_PRU_INSTALLDIR as PRU_CGT
define HOST_PRU_SOFTWARE_SUPPORT_INSTALL_CMDS
	mkdir -p $(TI_CGT_PRU_INSTALLDIR)/usr/include
	cp -dpfr $(@D)/include/* $(TI_CGT_PRU_INSTALLDIR)/usr/include
	mkdir -p $(TI_CGT_PRU_INSTALLDIR)/usr/lib
	cp -dpfr $(@D)/lib/src/*/gen/*.lib $(TI_CGT_PRU_INSTALLDIR)/usr/lib/
endef

define PRU_SOFTWARE_SUPPORT_BUILD_CMDS
	$(MAKE) PRU_CGT=$(TI_CGT_PRU_INSTALLDIR) -C $(@D)/examples
endef

define PRU_SOFTWARE_SUPPORT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/share/pru-software-support
	cp -dpfr $(@D)/examples/* $(TARGET_DIR)/usr/share/pru-software-support/
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
