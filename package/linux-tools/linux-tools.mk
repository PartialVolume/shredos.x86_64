# are named linux-tool-*.mk.in, so they won't be picked up by the top-level
# Makefile, but can be included here, guaranteeing the single inclusion and
# the proper ordering.

include $(sort $(wildcard package/linux-tools/*.mk.in))

# We only need the kernel to be extracted, not actually built
LINUX_TOOLS_PATCH_DEPENDENCIES = linux

# Install Linux kernel tools in the staging directory since some tools
# may install shared libraries and headers (e.g. cpupower).
LINUX_TOOLS_INSTALL_STAGING = YES

LINUX_TOOLS_DEPENDENCIES += $(foreach tool,$(LINUX_TOOLS),\
        $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                $($(call UPPERCASE,$(tool))_DEPENDENCIES)))

LINUX_TOOLS_POST_BUILD_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
        $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                $(call UPPERCASE,$(tool))_BUILD_CMDS))

LINUX_TOOLS_POST_INSTALL_STAGING_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
        $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                $(call UPPERCASE,$(tool))_INSTALL_STAGING_CMDS))

LINUX_TOOLS_POST_INSTALL_TARGET_HOOKS += $(foreach tool,$(LINUX_TOOLS),\
        $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                $(call UPPERCASE,$(tool))_INSTALL_TARGET_CMDS))

#
# Fix up kernel config if needed
#
define LINUX_TOOLS_LINUX_CONFIG_FIXUPS
        $(foreach tool,$(LINUX_TOOLS),\
                $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                        $($(call UPPERCASE,$(tool))_LINUX_CONFIG_FIXUPS))
        )
endef

#
# Systemd, SysV, and OpenRC init installations
#
define LINUX_TOOLS_INSTALL_INIT_SYSTEMD
        $(foreach tool,$(LINUX_TOOLS),\
                $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                        $($(call UPPERCASE,$(tool))_INSTALL_INIT_SYSTEMD))
        )
endef

define LINUX_TOOLS_INSTALL_INIT_SYSV
        $(foreach tool,$(LINUX_TOOLS),\
                $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                        $($(call UPPERCASE,$(tool))_INSTALL_INIT_SYSV))
        )
endef

define LINUX_TOOLS_INSTALL_INIT_OPENRC
        $(foreach tool,$(LINUX_TOOLS),\
                $(if $(BR2_PACKAGE_LINUX_TOOLS_$(call UPPERCASE,$(tool))),\
                        $(or $($(call UPPERCASE,$(tool))_INSTALL_INIT_OPENRC),\
                             $($(call UPPERCASE,$(tool))_INSTALL_INIT_SYSV)))
        )
endef

#
# -------------------------------------------------------------------
# Remove the 'action-ebpf' test artifact that triggers an
# "architecture mismatch" error on x86_64. This file is built
# for "Linux BPF" instead of the host architecture, so Buildroot
# complains on the first build.
# -------------------------------------------------------------------
#
define LINUX_TOOLS_REMOVE_BPF_TEST_ARTIFACT
	# Only remove if it exists. This is safe even if the file
	# doesn't get built or already got cleaned up.
	rm -f $(TARGET_DIR)/usr/lib/kselftests/tc-testing/action-ebpf
endef

LINUX_TOOLS_POST_INSTALL_TARGET_HOOKS += LINUX_TOOLS_REMOVE_BPF_TEST_ARTIFACT

$(eval $(generic-package))
