################################################################################
#
# bullet
#
################################################################################

BULLET_VERSION = 3.09
BULLET_SITE = $(call github,bulletphysics,bullet3,$(BULLET_VERSION))
BULLET_INSTALL_STAGING = YES
BULLET_LICENSE = Zlib
BULLET_LICENSE_FILES = LICENSE.txt

# Disable unit tests.
# Don't disable demos apps and Bullet3 library to avoid a build failure:
# https://github.com/bulletphysics/bullet3/issues/3143
BULLET_CONF_OPTS = -DBUILD_UNIT_TESTS=OFF

# extras needs dlfcn.h and NPTL (pthread_barrier_init)
ifeq ($(BR2_STATIC_LIBS):$(BR2_TOOLCHAIN_HAS_THREADS_NPTL),:y)
BULLET_CONF_OPTS += -DBUILD_EXTRAS=ON
else
BULLET_CONF_OPTS += -DBUILD_EXTRAS=OFF
endif

BULLET_CXXFLAGS = $(TARGET_CXXFLAGS)

ifneq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180)$(BR2_TOOLCHAIN_HAS_GCC_BUG_101952),)
BULLET_CXXFLAGS += -O0
endif

BULLET_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(BULLET_CXXFLAGS)"

$(eval $(cmake-package))
