################################################################################
#
# rust
#
################################################################################

RUST_VERSION = 1.54.0
RUST_SOURCE = rustc-$(RUST_VERSION)-src.tar.xz
RUST_SITE = https://static.rust-lang.org/dist
RUST_LICENSE = Apache-2.0 or MIT
RUST_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

HOST_RUST_PROVIDES = host-rustc

HOST_RUST_DEPENDENCIES = \
	toolchain \
	host-rust-bin \
	host-openssl \
	$(BR2_CMAKE_HOST_DEPENDENCY)

ifeq ($(BR2_PACKAGE_PYTHON3),y)
HOST_RUST_PYTHON_VERSION = $(PYTHON3_VERSION_MAJOR)
HOST_RUST_DEPENDENCIES += host-python3
else
HOST_RUST_PYTHON_VERSION = $(PYTHON_VERSION_MAJOR)
HOST_RUST_DEPENDENCIES += host-python
endif

HOST_RUST_VERBOSITY = $(if $(VERBOSE),2,0)

# Some vendor crates contain Cargo.toml.orig files. The associated
# .cargo-checksum.json file will contain a checksum for Cargo.toml.orig but
# support/scripts/apply-patches.sh will delete them. This will cause the build
# to fail, as Cargo will not be able to find the file and verify the checksum.
# So, remove all Cargo.toml.orig entries from the affected .cargo-checksum.json
# files
define HOST_RUST_EXCLUDE_ORIG_FILES
	for file in $$(find $(@D) -name '*.orig'); do \
		crate=$$(dirname $${file}); \
		fn=$${crate}/.cargo-checksum.json; \
		sed -i -e 's/"Cargo.toml.orig":"[a-z0-9]\+",//g' $${fn}; \
	done
endef

HOST_RUST_POST_EXTRACT_HOOKS += HOST_RUST_EXCLUDE_ORIG_FILES

define HOST_RUST_CONFIGURE_CMDS
	( \
		echo '[build]'; \
		echo 'target = ["$(RUSTC_TARGET_NAME)"]'; \
		echo 'cargo = "$(HOST_RUST_BIN_DIR)/cargo/bin/cargo"'; \
		echo 'rustc = "$(HOST_RUST_BIN_DIR)/rustc/bin/rustc"'; \
		echo 'python = "$(HOST_DIR)/bin/python$(HOST_RUST_PYTHON_VERSION)"'; \
		echo 'submodules = false'; \
		echo 'vendor = true'; \
		echo 'extended = true'; \
		echo 'tools = ["cargo"]'; \
		echo 'compiler-docs = false'; \
		echo 'docs = false'; \
		echo 'verbose = $(HOST_RUST_VERBOSITY)'; \
		echo '[install]'; \
		echo 'prefix = "$(HOST_DIR)"'; \
		echo 'sysconfdir = "$(HOST_DIR)/etc"'; \
		echo '[rust]'; \
		echo 'channel = "stable"'; \
		echo '[target.$(RUSTC_TARGET_NAME)]'; \
		echo 'cc = "$(TARGET_CROSS)gcc"'; \
		echo '[llvm]'; \
		echo 'ninja = false'; \
	) > $(@D)/config.toml
endef

define HOST_RUST_BUILD_CMDS
	cd $(@D); $(HOST_MAKE_ENV) $(HOST_DIR)/bin/python$(HOST_RUST_PYTHON_VERSION) x.py build
endef

define HOST_RUST_INSTALL_CMDS
	cd $(@D); $(HOST_MAKE_ENV) $(HOST_DIR)/bin/python$(HOST_RUST_PYTHON_VERSION) x.py dist
	cd $(@D); $(HOST_MAKE_ENV) $(HOST_DIR)/bin/python$(HOST_RUST_PYTHON_VERSION) x.py install
endef

$(eval $(host-generic-package))
