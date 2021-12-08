################################################################################
#
# This file contains the download helpers for the various package
# infrastructures. It is used to handle downloads from HTTP servers,
# FTP servers, Git repositories, Subversion repositories, Mercurial
# repositories, Bazaar repositories, and SCP servers.
#
################################################################################

# Download method commands
export WGET := $(call qstrip,$(BR2_WGET))
export SVN := $(call qstrip,$(BR2_SVN))
export CVS := $(call qstrip,$(BR2_CVS))
export BZR := $(call qstrip,$(BR2_BZR))
export GIT := $(call qstrip,$(BR2_GIT))
export HG := $(call qstrip,$(BR2_HG))
export SCP := $(call qstrip,$(BR2_SCP))
export LOCALFILES := $(call qstrip,$(BR2_LOCALFILES))

# Version of the format of the archives we generate in the corresponding
# download backend:
BR_FMT_VERSION_git = -br1
BR_FMT_VERSION_svn = -br2

DL_WRAPPER = support/download/dl-wrapper

# DL_DIR may have been set already from the environment
ifeq ($(origin DL_DIR),undefined)
DL_DIR ?= $(call qstrip,$(BR2_DL_DIR))
ifeq ($(DL_DIR),)
DL_DIR := $(TOPDIR)/dl
endif
else
# Restore the BR2_DL_DIR that was overridden by the .config file
BR2_DL_DIR = $(DL_DIR)
endif

# ensure it exists and a absolute path, derefrecing symlinks
DL_DIR := $(shell mkdir -p $(DL_DIR) && cd $(DL_DIR) >/dev/null && pwd -P)

#
# URI scheme helper functions
# Example URIs:
# * http://www.example.com/dir/file
# * scp://www.example.com:dir/file (with domainseparator :)
#
# geturischeme: http
geturischeme = $(firstword $(subst ://, ,$(call qstrip,$(1))))
# getschemeplusuri: git|parameter+http://example.com
getschemeplusuri = $(call geturischeme,$(1))$(if $(2),\|$(2))+$(1)
# stripurischeme: www.example.com/dir/file
stripurischeme = $(lastword $(subst ://, ,$(call qstrip,$(1))))
# domain: www.example.com
domain = $(firstword $(subst $(call domainseparator,$(2)), ,$(call stripurischeme,$(1))))
# notdomain: dir/file
notdomain = $(patsubst $(call domain,$(1),$(2))$(call domainseparator,$(2))%,%,$(call stripurischeme,$(1)))
#
# default domainseparator is /, specify alternative value as first argument
domainseparator = $(if $(1),$(1),/)

# github(user,package,version): returns site of GitHub repository
github = https://github.com/$(1)/$(2)/archive/$(3)

# gitlab(user,package,version): returns site of Gitlab-generated tarball
gitlab = https://gitlab.com/$(1)/$(2)/-/archive/$(3)

# Expressly do not check hashes for those files
# Exported variables default to immediately expanded in some versions of
# make, but we need it to be recursively-epxanded, so explicitly assign it.
export BR_NO_CHECK_HASH_FOR =

################################################################################
# DOWNLOAD_URIS - List the candidates URIs where to get the package from:
# 1) BR2_PRIMARY_SITE if enabled
# 2) Download site, unless BR2_PRIMARY_SITE_ONLY is set
# 3) BR2_BACKUP_SITE if enabled, unless BR2_PRIMARY_SITE_ONLY is set
#
# Argument 1 is the source location
# Argument 2 is the upper-case package name
#
################################################################################

ifneq ($(call qstrip,$(BR2_PRIMARY_SITE)),)
DOWNLOAD_URIS += \
	$(call getschemeplusuri,$(call qstrip,$(BR2_PRIMARY_SITE)/$($(2)_DL_SUBDIR)),urlencode) \
	$(call getschemeplusuri,$(call qstrip,$(BR2_PRIMARY_SITE)),urlencode)
endif

ifeq ($(BR2_PRIMARY_SITE_ONLY),)
DOWNLOAD_URIS += \
	$(patsubst %/,%,$(dir $(call qstrip,$(1))))
ifneq ($(call qstrip,$(BR2_BACKUP_SITE)),)
DOWNLOAD_URIS += \
	$(call getschemeplusuri,$(call qstrip,$(BR2_BACKUP_SITE)/$($(2)_DL_SUBDIR)),urlencode) \
	$(call getschemeplusuri,$(call qstrip,$(BR2_BACKUP_SITE)),urlencode)
endif
endif

################################################################################
# DOWNLOAD -- Download helper. Will call DL_WRAPPER which will try to download
# source from the list returned by DOWNLOAD_URIS.
#
# Argument 1 is the source location
# Argument 2 is the upper-case package name
#
################################################################################

define DOWNLOAD
	$(Q)mkdir -p $($(2)_DL_DIR)
	$(Q)$(EXTRA_ENV) $($(2)_DL_ENV) \
		flock $($(2)_DL_DIR)/.lock $(DL_WRAPPER) \
		-c '$($(2)_DL_VERSION)' \
		-d '$($(2)_DL_DIR)' \
		-D '$(DL_DIR)' \
		-f '$(notdir $(1))' \
		-H '$($(2)_HASH_FILE)' \
		-n '$($(2)_BASENAME_RAW)' \
		-N '$($(2)_RAWNAME)' \
		-o '$($(2)_DL_DIR)/$(notdir $(1))' \
		$(if $($(2)_GIT_SUBMODULES),-r) \
		$(foreach uri,$(call DOWNLOAD_URIS,$(1),$(2)),-u $(uri)) \
		$(QUIET) \
		-- \
		$($(2)_DL_OPTS)
endef
