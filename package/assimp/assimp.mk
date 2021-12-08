################################################################################
#
# assimp
#
################################################################################

ASSIMP_VERSION = 5.0.1
ASSIMP_SITE = $(call github,assimp,assimp,v$(ASSIMP_VERSION))
ASSIMP_LICENSE = BSD-3-Clause
ASSIMP_LICENSE_FILES = LICENSE
ASSIMP_DEPENDENCIES = zlib
ASSIMP_INSTALL_STAGING = YES

# relocation truncated to fit: R_68K_GOT16O. We also need to disable
# optimizations to not run into "Error: value -43420 out of range"
# assembler issues.
ifeq ($(BR2_m68k),y)
ASSIMP_CXXFLAGS += -mxgot -O0
endif

# just like m68k coldfire, mips64 also has some limitations on the GOT
# size for large libraries, which can be overcome by passing
# -mxgot. Solves "relocation truncated to fit: R_MIPS_CALL16" issues.
ifeq ($(BR2_mips64)$(BR2_mips64el),y)
ASSIMP_CXXFLAGS += -mxgot
endif

# workaround SuperH compiler failure when static linking (i.e -fPIC is
# not passed) in gcc versions 5.x or older. The -Os optimization level
# causes a "unable to find a register to spill in class
# 'GENERAL_REGS'" error. -O2 works fine.
ifeq ($(BR2_sh):$(BR2_STATIC_LIBS):$(BR2_TOOLCHAIN_GCC_AT_LEAST_6),y:y:)
ASSIMP_CXXFLAGS += -O2
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
ASSIMP_CXXFLAGS += -O0
endif

ASSIMP_CONF_OPTS += -DASSIMP_BUILD_TESTS=OFF \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) $(ASSIMP_CXXFLAGS)"

$(eval $(cmake-package))
