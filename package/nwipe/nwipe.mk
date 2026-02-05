################################################################################
#
# nwipe
#
################################################################################

NWIPE_VERSION = $(call qstrip,$(BR2_PACKAGE_NWIPE_GIT_REVISION))

# Default Git repository URL (never empty).
NWIPE_SITE = https://github.com/martijnvanbrummelen/nwipe.git
ifneq ($(call qstrip,$(BR2_PACKAGE_NWIPE_SITE)),)
NWIPE_SITE = $(call qstrip,$(BR2_PACKAGE_NWIPE_SITE))
endif

NWIPE_SITE_METHOD = git

NWIPE_DEPENDENCIES = ncurses parted dmidecode coreutils libconfig

################################################################################
# SHREDOS version.txt and banner updater. Updates the nwipe version which
# could be a release version, such as 0.40 or a commit reference, such as
# e964dba-dev used by developers when working on non released code from the
# master branch.
################################################################################

SHREDOS_VERSION_FILE = board/shredos/fsoverlay/etc/shredos/version.txt

ifeq ($(BR2_PACKAGE_NWIPE),y)

ifeq ($(BR2_PACKAGE_NWIPE_VERSION_GIT_REVISION),y)
# Take first 7 characters of the git revision and append suffix
NWIPE_VERSION_BANNER := $(shell printf "%.7s-commit-dev" "$(BR2_PACKAGE_NWIPE_GIT_REVISION)")
else
NWIPE_VERSION_BANNER := $(NWIPE_VERSION)
endif

endif

define NWIPE_UPDATE_VERSION_TXT
	@if [ -n "$(NWIPE_VERSION_BANNER)" ]; then \
		echo "Updating version.txt and nwipe banner with Nwipe version: $(NWIPE_VERSION_BANNER)"; \
		sed -i 's/\(.*_\)[^_]*$$/\1$(NWIPE_VERSION_BANNER)/' $(SHREDOS_VERSION_FILE); \
	fi
endef

NWIPE_PRE_CONFIGURE_HOOKS += NWIPE_UPDATE_VERSION_TXT

######

################################################################################
# Version architecture nwipe banner updater (pre-build)
################################################################################

define NWIPE_INITSH
	@echo "Updating version.txt and nwipe banner with architecture: $(BR2_ARCH)"

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

