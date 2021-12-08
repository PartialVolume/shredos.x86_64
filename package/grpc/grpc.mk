################################################################################
#
# grpc
#
################################################################################

GRPC_VERSION = 1.38.1
GRPC_SITE = $(call github,grpc,grpc,v$(GRPC_VERSION))
GRPC_LICENSE = Apache-2.0
GRPC_LICENSE_FILES = LICENSE
GRPC_CPE_ID_VENDOR = grpc

GRPC_INSTALL_STAGING = YES

# Need to use host grpc_cpp_plugin during cross compilation.
GRPC_DEPENDENCIES = c-ares host-grpc libabseil-cpp openssl protobuf re2 zlib
HOST_GRPC_DEPENDENCIES = host-c-ares host-libabseil-cpp host-openssl host-protobuf \
	host-re2 host-zlib

# gRPC_CARES_PROVIDER=package won't work because it requires c-ares to have
# installed a cmake config file, but buildroot uses c-ares' autotools build,
# which doesn't do this.  These CARES settings trick the gRPC cmake code into
# not looking for c-ares at all and yet still linking with the library.
GRPC_CONF_OPTS = \
	-DgRPC_ABSL_PROVIDER=package \
	-D_gRPC_CARES_LIBRARIES=cares \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_RE2_PROVIDER=package \
	-DgRPC_SSL_PROVIDER=package \
	-DgRPC_ZLIB_PROVIDER=package \
	-DgRPC_BUILD_GRPC_CPP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF

# grpc can use __atomic builtins, so we need to link with
# libatomic when available
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
GRPC_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

GRPC_CFLAGS = $(TARGET_CFLAGS)
GRPC_CXXFLAGS = $(TARGET_CXXFLAGS)

# Set GPR_DISABLE_WRAPPED_MEMCPY otherwise build will fail on x86_64 with uclibc
# because grpc tries to link with memcpy@GLIBC_2.2.5
ifeq ($(BR2_x86_64):$(BR2_TOOLCHAIN_USES_GLIBC),y:)
GRPC_CFLAGS += -DGPR_DISABLE_WRAPPED_MEMCPY
GRPC_CXXFLAGS += -DGPR_DISABLE_WRAPPED_MEMCPY
endif

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_85180),y)
GRPC_CFLAGS += -O0
GRPC_CXXFLAGS += -O0
endif

# Toolchains older than gcc5 will fail to compile with -0s due to:
# error: failure memory model cannot be stronger than success memory model for
# '__atomic_compare_exchange', so we use -O2 in these cases
ifeq ($(BR2_TOOLCHAIN_GCC_AT_LEAST_5):$(BR2_OPTIMIZE_S),:y)
GRPC_CFLAGS += -O2
GRPC_CXXFLAGS += -O2
endif

GRPC_CONF_OPTS += \
	-DCMAKE_C_FLAGS="$(GRPC_CFLAGS)" \
	-DCMAKE_CXX_FLAGS="$(GRPC_CXXFLAGS)"

HOST_GRPC_CONF_OPTS = \
	-DgRPC_ABSL_PROVIDER=package \
	-D_gRPC_CARES_LIBRARIES=cares \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_RE2_PROVIDER=package \
	-DgRPC_SSL_PROVIDER=package \
	-DgRPC_ZLIB_PROVIDER=package

$(eval $(cmake-package))
$(eval $(host-cmake-package))
