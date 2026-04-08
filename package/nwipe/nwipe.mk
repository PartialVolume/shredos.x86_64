################################################################################
#
# nwipe
#
################################################################################

NWIPE_BUILD_ARCH = $(call qstrip,$(BR2_ARCH))
NWIPE_VERSION = $(call qstrip,$(BR2_PACKAGE_NWIPE_GIT_REVISION))
NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils libconfig libnvme
NWIPE_CONF_OPTS = --with-libnvme
NWIPE_SITE_METHOD = git

ifneq ($(call qstrip,$(BR2_PACKAGE_NWIPE_SITE)),)
NWIPE_SITE = $(call qstrip,$(BR2_PACKAGE_NWIPE_SITE))
else
NWIPE_SITE = https://github.com/martijnvanbrummelen/nwipe.git
endif

################################################################################
# Architecture safeguard
################################################################################

define NWIPE_CHECK_ARCH
	case "$(NWIPE_BUILD_ARCH)" in \
	i686|x86_64) ;; \
	*) echo "Unsupported architecture: $(NWIPE_BUILD_ARCH)"; exit 1 ;; \
	esac
endef

NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_CHECK_ARCH

################################################################################
# SHREDOS version.txt and banner updater. Updates the nwipe version which
# could be a release version, such as 0.40 or a commit reference, such as
# e964dba-dev used by developers when working on non released code from the
# master branch.
################################################################################

SHREDOS_VERSION_FILE = board/shredos/fsoverlay/etc/shredos/version.txt

# If version contains a dot, treat it as a release tag
ifneq ($(findstring .,$(NWIPE_VERSION)),)
NWIPE_VERSION_BANNER = $(NWIPE_VERSION)
else
# Otherwise assume it is a development version by hash
NWIPE_VERSION_BANNER = $(shell printf "%.7s-commit-dev" "$(NWIPE_VERSION)")
endif

# Normalize x86_64 to x86-64 for version
NWIPE_VERSION_ARCH = $(if $(filter x86_64,$(NWIPE_BUILD_ARCH)),x86-64,$(NWIPE_BUILD_ARCH))

define NWIPE_UPDATE_VERSION_TXT
	echo "Updating version.txt: arch=$(NWIPE_VERSION_ARCH) banner=$(NWIPE_VERSION_BANNER)"
	sed -i "s/\(.*_\)\(x86-64\|i686\)_.*$$/\1$(NWIPE_VERSION_ARCH)_$(NWIPE_VERSION_BANNER)/" \
		$(SHREDOS_VERSION_FILE)
	grep -q "$(NWIPE_VERSION_ARCH)_$(NWIPE_VERSION_BANNER)" $(SHREDOS_VERSION_FILE) || \
		{ echo "ERROR: Failed to update version.txt - unexpected format in file?"; exit 1; }
endef

NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_UPDATE_VERSION_TXT

################################################################################
# Version architecture nwipe banner updater (pre-build)
################################################################################

define NWIPE_INIT_BUILD
	(cd $(@D) && \
	cp ../../../package/nwipe/002-nwipe-banner-patch.sh . && \
	./002-nwipe-banner-patch.sh && \
	PATH="../../host/bin:${PATH}" ./autogen.sh)
endef

# Pre-configure hook, as a post-patch hook would not get triggered on a package
# reconfigure, and possibly also taint the sources directory with the generated
# autogen files (which should not be there).
NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_INIT_BUILD

$(eval $(autotools-package))

