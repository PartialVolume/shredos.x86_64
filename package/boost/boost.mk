################################################################################
#
# boost
#
################################################################################

BOOST_VERSION = 1.75.0
BOOST_SOURCE = boost_$(subst .,_,$(BOOST_VERSION)).tar.bz2
BOOST_SITE = https://boostorg.jfrog.io/artifactory/main/release/$(BOOST_VERSION)/source
BOOST_INSTALL_STAGING = YES
BOOST_LICENSE = BSL-1.0
BOOST_LICENSE_FILES = LICENSE_1_0.txt
BOOST_CPE_ID_VENDOR = boost

# keep host variant as minimal as possible
HOST_BOOST_FLAGS = --without-icu --with-toolset=gcc \
	--without-libraries=$(subst $(space),$(comma),atomic chrono context \
	contract container coroutine date_time exception fiber filesystem graph \
	graph_parallel iostreams json locale log math mpi nowide program_options \
	python random regex serialization stacktrace system test thread timer \
	type_erasure wave)

BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_ATOMIC),,atomic)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_CHRONO),,chrono)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_CONTAINER),,container)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_CONTEXT),,context)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_CONTRACT),,contract)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_COROUTINE),,coroutine)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_DATE_TIME),,date_time)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_EXCEPTION),,exception)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_FIBER),,fiber)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_FILESYSTEM),,filesystem)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_GRAPH),,graph)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_GRAPH_PARALLEL),,graph_parallel)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_IOSTREAMS),,iostreams)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_JSON),,json)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_LOCALE),,locale)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_LOG),,log)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_MATH),,math)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_MPI),,mpi)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_NOWIDE),,nowide)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_PROGRAM_OPTIONS),,program_options)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_PYTHON),,python)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_RANDOM),,random)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_REGEX),,regex)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SERIALIZATION),,serialization)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_STACKTRACE),,stacktrace)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SYSTEM),,system)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_TEST),,test)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_THREAD),,thread)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_TIMER),,timer)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_TYPE_ERASURE),,type_erasure)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_WAVE),,wave)

BOOST_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS)

BOOST_FLAGS = --with-toolset=gcc

ifeq ($(BR2_PACKAGE_ICU),y)
BOOST_FLAGS += --with-icu=$(STAGING_DIR)/usr
BOOST_DEPENDENCIES += icu
else
BOOST_FLAGS += --without-icu
endif

ifeq ($(BR2_PACKAGE_BOOST_IOSTREAMS),y)
BOOST_DEPENDENCIES += bzip2 zlib
endif

ifeq ($(BR2_PACKAGE_BOOST_PYTHON),y)
BOOST_FLAGS += --with-python-root=$(HOST_DIR)
ifeq ($(BR2_PACKAGE_PYTHON3),y)
BOOST_FLAGS += --with-python=$(HOST_DIR)/bin/python$(PYTHON3_VERSION_MAJOR)
BOOST_TARGET_CXXFLAGS += -I$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR)
BOOST_DEPENDENCIES += python3
else
BOOST_FLAGS += --with-python=$(HOST_DIR)/bin/python$(PYTHON_VERSION_MAJOR)
BOOST_TARGET_CXXFLAGS += -I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
BOOST_DEPENDENCIES += python
endif
endif

HOST_BOOST_OPTS += --no-cmake-config toolset=gcc threading=multi \
	variant=release link=shared runtime-link=shared

ifeq ($(BR2_MIPS_OABI32),y)
BOOST_ABI = o32
else ifeq ($(BR2_arm),y)
BOOST_ABI = aapcs
else
BOOST_ABI = sysv
endif

BOOST_OPTS += --no-cmake-config \
	     toolset=gcc \
	     threading=multi \
	     abi=$(BOOST_ABI) \
	     variant=$(if $(BR2_ENABLE_RUNTIME_DEBUG),debug,release)

ifeq ($(BR2_sparc64),y)
BOOST_OPTS += architecture=sparc instruction-set=ultrasparc
endif

ifeq ($(BR2_sparc),y)
BOOST_OPTS += architecture=sparc instruction-set=v8
endif

# By default, Boost build and installs both the shared and static
# variants. Override that if we want static only or shared only.
ifeq ($(BR2_STATIC_LIBS),y)
BOOST_OPTS += link=static runtime-link=static
else ifeq ($(BR2_SHARED_LIBS),y)
BOOST_OPTS += link=shared runtime-link=shared
endif

ifeq ($(BR2_PACKAGE_BOOST_LOCALE),y)
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# posix backend needs monetary.h which isn't available on uClibc
BOOST_OPTS += boost.locale.posix=off
endif

BOOST_DEPENDENCIES += $(if $(BR2_ENABLE_LOCALE),,libiconv)
endif

BOOST_WITHOUT_FLAGS_COMMASEPARATED += $(subst $(space),$(comma),$(strip $(BOOST_WITHOUT_FLAGS)))
BOOST_FLAGS += $(if $(BOOST_WITHOUT_FLAGS_COMMASEPARATED), --without-libraries=$(BOOST_WITHOUT_FLAGS_COMMASEPARATED))
BOOST_LAYOUT = $(call qstrip, $(BR2_PACKAGE_BOOST_LAYOUT))

# how verbose should the build be?
BOOST_OPTS += $(if $(QUIET),-d,-d+1)
HOST_BOOST_OPTS += $(if $(QUIET),-d,-d+1)

define BOOST_CONFIGURE_CMDS
	(cd $(@D) && ./bootstrap.sh $(BOOST_FLAGS))
	echo "using gcc : `$(TARGET_CC) -dumpversion` : $(TARGET_CXX) : <cxxflags>\"$(BOOST_TARGET_CXXFLAGS)\" <linkflags>\"$(TARGET_LDFLAGS)\" ;" > $(@D)/user-config.jam
	echo "" >> $(@D)/user-config.jam
	sed -i "s/: -O.* ;/: $(TARGET_OPTIMIZATION) ;/" $(@D)/tools/build/src/tools/gcc.jam
endef

define BOOST_BUILD_CMDS
	(cd $(@D) && $(TARGET_MAKE_ENV) ./tools/build/src/engine/bjam -j$(PARALLEL_JOBS) -q \
	--user-config=$(@D)/user-config.jam \
	$(BOOST_OPTS) \
	--ignore-site-config \
	--layout=$(BOOST_LAYOUT))
endef

define BOOST_INSTALL_TARGET_CMDS
	(cd $(@D) && $(TARGET_MAKE_ENV) ./b2 -j$(PARALLEL_JOBS) -q \
	--user-config=$(@D)/user-config.jam \
	$(BOOST_OPTS) \
	--prefix=$(TARGET_DIR)/usr \
	--ignore-site-config \
	--layout=$(BOOST_LAYOUT) install )
endef

define BOOST_INSTALL_STAGING_CMDS
	(cd $(@D) && $(TARGET_MAKE_ENV) ./tools/build/src/engine/bjam -j$(PARALLEL_JOBS) -q \
	--user-config=$(@D)/user-config.jam \
	$(BOOST_OPTS) \
	--prefix=$(STAGING_DIR)/usr \
	--ignore-site-config \
	--layout=$(BOOST_LAYOUT) install)
endef

# These hooks will help us to detect missing select in Config.in
# Indeed boost buildsystem can select a library even if the user has
# disable it
define BOOST_REMOVE_TARGET_LIBRARIES
	rm -rf $(TARGET_DIR)/usr/lib/libboost_*
endef

BOOST_PRE_INSTALL_TARGET_HOOKS += BOOST_REMOVE_TARGET_LIBRARIES

define BOOST_CHECK_TARGET_LIBRARIES
	@$(foreach disabled,$(BOOST_WITHOUT_FLAGS),\
		! ls $(TARGET_DIR)/usr/lib/libboost_$(disabled)* 1>/dev/null 2>&1 || \
			! echo "libboost_$(disabled) shouldn't have been installed: missing select in boost/Config.in" || \
			exit 1;)
endef

BOOST_POST_INSTALL_TARGET_HOOKS += BOOST_CHECK_TARGET_LIBRARIES

define HOST_BOOST_CONFIGURE_CMDS
	(cd $(@D) && ./bootstrap.sh $(HOST_BOOST_FLAGS))
	echo "using gcc : `$(HOST_CC) -dumpversion` : $(HOSTCXX) : <cxxflags>\"$(HOST_CXXFLAGS)\" <linkflags>\"$(HOST_LDFLAGS)\" ;" > $(@D)/user-config.jam
	echo "" >> $(@D)/user-config.jam
endef

define HOST_BOOST_BUILD_CMDS
	(cd $(@D) && ./b2 -j$(PARALLEL_JOBS) -q \
	--user-config=$(@D)/user-config.jam \
	$(HOST_BOOST_OPTS) \
	--ignore-site-config \
	--prefix=$(HOST_DIR) )
endef

define HOST_BOOST_INSTALL_CMDS
	(cd $(@D) && ./b2 -j$(PARALLEL_JOBS) -q \
	--user-config=$(@D)/user-config.jam \
	$(HOST_BOOST_OPTS) \
	--prefix=$(HOST_DIR) \
	--ignore-site-config \
	--layout=$(BOOST_LAYOUT) install )
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
