################################################################################
#
# openjdk
#
################################################################################

ifeq ($(BR2_PACKAGE_OPENJDK_VERSION_17),y)
OPENJDK_VERSION_MAJOR = 17
OPENJDK_VERSION_MINOR = 0.1+12
else
OPENJDK_VERSION_MAJOR = 11
OPENJDK_VERSION_MINOR = 0.13+8
endif
OPENJDK_VERSION = $(OPENJDK_VERSION_MAJOR).$(OPENJDK_VERSION_MINOR)
OPENJDK_SITE = $(call github,openjdk,jdk$(OPENJDK_VERSION_MAJOR)u,jdk-$(OPENJDK_VERSION))

OPENJDK_LICENSE = GPL-2.0+ with exception
OPENJDK_LICENSE_FILES = LICENSE
OPENJDK_INSTALL_STAGING = YES

# OpenJDK requires Alsa, cups, and X11 even for a headless build.
# host-zip is needed for the zip executable.
OPENJDK_DEPENDENCIES = \
	host-gawk \
	host-openjdk-bin \
	host-pkgconf \
	host-zip \
	host-zlib \
	alsa-lib \
	cups \
	fontconfig \
	giflib \
	jpeg \
	lcms2 \
	libpng \
	libusb \
	xlib_libXrandr \
	xlib_libXrender \
	xlib_libXt \
	xlib_libXtst \
	zlib

# JVM variants
ifeq ($(BR2_PACKAGE_OPENJDK_JVM_VARIANT_CLIENT),y)
OPENJDK_JVM_VARIANT = client
endif
ifeq ($(BR2_PACKAGE_OPENJDK_JVM_VARIANT_SERVER),y)
OPENJDK_JVM_VARIANT = server
endif
ifeq ($(BR2_PACKAGE_OPENJDK_JVM_VARIANT_ZERO),y)
OPENJDK_JVM_VARIANT = zero
OPENJDK_DEPENDENCIES += libffi
endif

ifeq ($(BR2_PACKAGE_OPENJDK_FULL_JDK),y)
OPENJDK_VARIANT = jdk
OPENJDK_MAKE_TARGET = jdk-image
else
OPENJDK_VARIANT = jre
OPENJDK_MAKE_TARGET = legacy-jre-image
endif

# OpenJDK installs a file named 'modules' in jre/lib, which gets installed as
# /usr/lib/modules. However, with a merged /usr, this conflicts with the
# directory named 'modules' installed by the kernel. If OpenJDK gets built
# after the kernel, this manifests itself with: "cp: cannot overwrite
# directory '/usr/lib/modules with non-directory."
OPENJDK_INSTALL_BASE = /usr/lib/jvm

# OpenJDK ignores some variables unless passed via the environment.
# These variables are PATH, LD, CC, CXX, and CPP.
# OpenJDK defaults ld to the ld binary but passes -Xlinker and -z as
# arguments during the linking process, which causes compilation failures.
# To fix this issue, LD is set to point to gcc.
OPENJDK_CONF_ENV = \
	PATH=$(BR_PATH) \
	CC=$(TARGET_CC) \
	CPP=$(TARGET_CPP) \
	CXX=$(TARGET_CXX) \
	LD=$(TARGET_CC) \
	BUILD_SYSROOT_CFLAGS="$(HOST_CFLAGS)" \
	BUILD_SYSROOT_LDFLAGS="$(HOST_LDFLAGS)"

OPENJDK_CONF_OPTS = \
	--disable-full-docs \
	--disable-hotspot-gtest \
	--disable-manpages \
	--disable-warnings-as-errors \
	--enable-headless-only \
	--enable-openjdk-only \
	--enable-unlimited-crypto \
	--openjdk-target=$(GNU_TARGET_NAME) \
	--with-boot-jdk=$(HOST_OPENJDK_BIN_ROOT_DIR) \
	--with-stdc++lib=dynamic \
	--with-debug-level=release \
	--with-devkit=$(HOST_DIR) \
	--with-extra-cflags="$(TARGET_CFLAGS)" \
	--with-extra-cxxflags="$(TARGET_CXXFLAGS)" \
	--with-extra-ldflags="-Wl,-rpath,$(OPENJDK_INSTALL_BASE)/lib,-rpath,$(OPENJDK_INSTALL_BASE)/lib/$(OPENJDK_JVM_VARIANT)" \
	--with-giflib=system \
	--with-jobs=$(PARALLEL_JOBS) \
	--with-jvm-variants=$(OPENJDK_JVM_VARIANT) \
	--with-lcms=system \
	--with-libjpeg=system \
	--with-libpng=system \
	--with-zlib=system \
	--with-native-debug-symbols=none \
	--without-version-pre \
	--with-sysroot=$(STAGING_DIR) \
	--with-version-build="$(OPENJDK_VERSION_MAJOR)" \
	--with-version-string="$(OPENJDK_VERSION_MAJOR)"

# If building for AArch64, use the provided CPU port.
ifeq ($(BR2_aarch64),y)
OPENJDK_CONF_OPTS += --with-abi-profile=aarch64
endif

ifeq ($(BR2_CCACHE),y)
OPENJDK_CONF_OPTS += \
	--enable-ccache \
	--with-ccache-dir=$(BR2_CCACHE_DIR)
endif

# Autogen and configure are performed in a single step.
define OPENJDK_CONFIGURE_CMDS
	chmod +x $(@D)/configure
	cd $(@D); $(OPENJDK_CONF_ENV) ./configure autogen $(OPENJDK_CONF_OPTS)
endef

# Make -jn is unsupported. Instead, set the "--with-jobs=" configure option,
# and use $(MAKE1).
define OPENJDK_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(OPENJDK_CONF_ENV) $(MAKE1) -C $(@D) $(OPENJDK_MAKE_TARGET)
endef

# Calling make install always builds and installs the JDK instead of the JRE,
# which makes manual installation necessary.
define OPENJDK_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)$(OPENJDK_INSTALL_BASE)
	cp -dpfr $(@D)/build/linux-*-release/images/$(OPENJDK_VARIANT)/* \
		$(TARGET_DIR)$(OPENJDK_INSTALL_BASE)/
	cd $(TARGET_DIR)/usr/bin && ln -snf ../..$(OPENJDK_INSTALL_BASE)/bin/* .
endef

define OPENJDK_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/jvm
	cp -dpfr $(@D)/build/linux-*-release/jdk/include/* \
		$(STAGING_DIR)/usr/include/jvm
endef

# Demos and includes are not needed on the target
ifeq ($(BR2_PACKAGE_OPENJDK_FULL_JDK),y)
define OPENJDK_REMOVE_UNEEDED_JDK_DIRECTORIES
	$(RM) -r $(TARGET_DIR)$(OPENJDK_INSTALL_BASE)/include/
	$(RM) -r $(TARGET_DIR)$(OPENJDK_INSTALL_BASE)/demo/
endef
OPENJDK_TARGET_FINALIZE_HOOKS += OPENJDK_REMOVE_UNEEDED_JDK_DIRECTORIES
endif

$(eval $(generic-package))
