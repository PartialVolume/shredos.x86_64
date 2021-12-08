################################################################################
#
# libsemanage
#
################################################################################

LIBSEMANAGE_VERSION = 3.2
LIBSEMANAGE_SITE = https://github.com/SELinuxProject/selinux/releases/download/$(LIBSEMANAGE_VERSION)
LIBSEMANAGE_LICENSE = LGPL-2.1+
LIBSEMANAGE_LICENSE_FILES = COPYING
LIBSEMANAGE_DEPENDENCIES = host-bison host-flex audit libselinux bzip2
LIBSEMANAGE_CPE_ID_VENDOR = selinuxproject
LIBSEMANAGE_INSTALL_STAGING = YES

LIBSEMANAGE_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

define LIBSEMANAGE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) all
endef

define LIBSEMANAGE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
endef

define LIBSEMANAGE_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEMANAGE_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

HOST_LIBSEMANAGE_DEPENDENCIES = \
	host-bison \
	host-audit \
	host-libsepol \
	host-libselinux \
	host-bzip2 \
	host-swig \
	host-python3

HOST_LIBSEMANAGE_MAKE_OPTS += \
	$(HOST_CONFIGURE_OPTS) \
	PREFIX=$(HOST_DIR) \
	SWIG_LIB="$(HOST_DIR)/share/swig/$(SWIG_VERSION)/" \
	DEFAULT_SEMANAGE_CONF_LOCATION=$(HOST_DIR)/etc/selinux/semanage.conf \
	PYINC="-I$(HOST_DIR)/include/python$(PYTHON3_VERSION_MAJOR)/" \
	PYTHONLIBDIR="$(HOST_DIR)/lib/python$(PYTHON3_VERSION_MAJOR)/" \
	PYLIBVER="python$(PYTHON3_VERSION_MAJOR)"

define HOST_LIBSEMANAGE_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) all
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) swigify pywrap
endef

define HOST_LIBSEMANAGE_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) install
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_LIBSEMANAGE_MAKE_OPTS) install-pywrap
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
