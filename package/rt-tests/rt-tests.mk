################################################################################
#
# rt-tests
#
################################################################################

RT_TESTS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/rt-tests
RT_TESTS_SOURCE = rt-tests-$(RT_TESTS_VERSION).tar.xz
RT_TESTS_VERSION = 1.10
RT_TESTS_LICENSE = GPL-2.0+
RT_TESTS_LICENSE_FILES = COPYING

RT_TESTS_DEPENDENCIES = numactl
RT_TESTS_CPE_ID_VENDOR = kernel

define RT_TESTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		prefix=/usr
endef

define RT_TESTS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR="$(TARGET_DIR)" \
		prefix=/usr \
		PYLIB="$(if $(BR2_PACKAGE_PYTHON3),/usr/lib/python$(PYTHON3_VERSION_MAJOR)/site-packages/)" \
		install
endef

$(eval $(generic-package))
