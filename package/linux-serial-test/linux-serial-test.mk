################################################################################
#
# linux-serial-test
#
################################################################################

LINUX_SERIAL_TEST_VERSION = bf865c37ccf9cbb1826ada61037c036dc1990b7b
LINUX_SERIAL_TEST_SITE = $(call github,cbrake,linux-serial-test,$(LINUX_SERIAL_TEST_VERSION))
LINUX_SERIAL_TEST_LICENSE = MIT
LINUX_SERIAL_TEST_LICENSE_FILES = LICENSES/MIT

$(eval $(cmake-package))
