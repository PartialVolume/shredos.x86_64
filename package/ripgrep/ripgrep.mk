################################################################################
#
# ripgrep
#
################################################################################

RIPGREP_VERSION = 0.8.1
RIPGREP_SITE = $(call github,burntsushi,ripgrep,$(RIPGREP_VERSION))
RIPGREP_LICENSE = MIT
RIPGREP_LICENSE_FILES = LICENSE-MIT
RIPGREP_CPE_ID_VENDOR = ripgrep_project

# CVE only impacts ripgrep on Windows
RIPGREP_IGNORE_CVES += CVE-2021-3013

RIPGREP_DEPENDENCIES = host-rustc
RIPGREP_CARGO_ENV = CARGO_HOME=$(HOST_DIR)/share/cargo \
	__CARGO_TEST_CHANNEL_OVERRIDE_DO_NOT_USE_THIS="nightly" \
	CARGO_TARGET_APPLIES_TO_HOST="false"

RIPGREP_BIN_DIR = target/$(RUSTC_TARGET_NAME)/$(RIPGREP_CARGO_BIN_SUBDIR)

RIPGREP_CARGO_OPTS = \
	-Z target-applies-to-host \
	--target=$(RUSTC_TARGET_NAME) \
	--manifest-path=$(@D)/Cargo.toml

ifeq ($(BR2_ENABLE_RUNTIME_DEBUG),y)
RIPGREP_CARGO_BIN_SUBDIR = debug
else
RIPGREP_CARGO_OPTS += --release
RIPGREP_CARGO_BIN_SUBDIR = release
endif

define RIPGREP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(RIPGREP_CARGO_ENV) \
		cargo build $(RIPGREP_CARGO_OPTS)
endef

define RIPGREP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(RIPGREP_BIN_DIR)/rg \
		$(TARGET_DIR)/usr/bin/rg
endef

$(eval $(generic-package))
