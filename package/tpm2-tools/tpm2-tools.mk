################################################################################
#
# tpm2-tools
#
################################################################################

TPM2_TOOLS_VERSION = 4.3.2
TPM2_TOOLS_SITE = https://github.com/tpm2-software/tpm2-tools/releases/download/$(TPM2_TOOLS_VERSION)
TPM2_TOOLS_LICENSE = BSD-3-Clause
TPM2_TOOLS_LICENSE_FILES = doc/LICENSE
TPM2_TOOLS_CPE_ID_VENDOR = tpm2-tools_project
TPM2_TOOLS_SELINUX_MODULES = tpm2
TPM2_TOOLS_DEPENDENCIES = libcurl openssl tpm2-tss host-pkgconf util-linux
# We're patching configure.ac
TPM2_TOOLS_AUTORECONF = YES

# -fstack-protector-all and FORTIFY_SOURCE=2 is used by
# default. Disable that so the BR2_SSP_* / BR2_FORTIFY_SOURCE_* options
# in the toolchain wrapper and CFLAGS are used instead
TPM2_TOOLS_CONF_OPTS = --disable-hardening

# do not build man pages
TPM2_TOOLS_CONF_ENV += ac_cv_prog_PANDOC=''

$(eval $(autotools-package))
