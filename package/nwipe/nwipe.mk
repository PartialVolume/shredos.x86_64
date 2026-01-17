################################################################################
#
# nwipe
#
################################################################################

# Select the Git reference based on the Kconfig choice.
ifeq ($(BR2_PACKAGE_NWIPE_VERSION_STABLE),y)
NWIPE_VERSION = v0.39
else ifeq ($(BR2_PACKAGE_NWIPE_VERSION_GIT_REVISION),y)
NWIPE_VERSION = $(call qstrip,$(BR2_PACKAGE_NWIPE_GIT_REVISION))
else
# Fallback – should not happen because the choice enforces exactly one option
NWIPE_VERSION = v0.39
endif

# Default Git repository URL (never empty).
NWIPE_SITE = https://github.com/martijnvanbrummelen/nwipe.git
ifneq ($(call qstrip,$(BR2_PACKAGE_NWIPE_SITE)),)
NWIPE_SITE = $(call qstrip,$(BR2_PACKAGE_NWIPE_SITE))
endif

NWIPE_SITE_METHOD = git

NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils libconfig

################################################################################
# Version architecture nwipe banner updater (pre-build)
################################################################################

SHREDOS_VERSION_FILE = board/shredos/fsoverlay/etc/shredos/version.txt

define NWIPE_INITSH
	@echo "Updating version.txt for architecture: $(BR2_ARCH)"

	@if [ "$(BR2_ARCH)" = "i686" ]; then \
		sed -i 's/\(^.*_\)\(x86-64\|i686\)\(_.*\)/\1i686\3/' $(SHREDOS_VERSION_FILE); \
	elif [ "$(BR2_ARCH)" = "x86_64" ]; then \
		sed -i 's/\(^.*_\)\(x86-64\|i686\)\(_.*\)/\1x86-64\3/' $(SHREDOS_VERSION_FILE); \
	else \
		echo "Unsupported architecture: $(BR2_ARCH)"; \
		exit 1; \
	fi

	(cd $(@D) && \
	cp ../../../package/nwipe/002-nwipe-banner-patch.sh . && \
	./002-nwipe-banner-patch.sh && \
	PATH="../../host/bin:${PATH}" ./autogen.sh)
endef

# Pre-configure hook, as a post-patch hook would not get triggered on a package
# reconfigure, and possibly also taint the sources directory with the generated
# autogen files (which should not be there).
NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_INITSH

$(eval $(autotools-package))

