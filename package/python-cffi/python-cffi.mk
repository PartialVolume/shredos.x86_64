################################################################################
#
# python-cffi
#
################################################################################

# Please keep in sync with package/python3-cffi/python3-cffi.mk
PYTHON_CFFI_VERSION = 1.14.6
PYTHON_CFFI_SOURCE = cffi-$(PYTHON_CFFI_VERSION).tar.gz
PYTHON_CFFI_SITE = https://files.pythonhosted.org/packages/2e/92/87bb61538d7e60da8a7ec247dc048f7671afe17016cd0008b3b710012804
PYTHON_CFFI_SETUP_TYPE = setuptools
PYTHON_CFFI_DEPENDENCIES = host-pkgconf libffi
PYTHON_CFFI_LICENSE = MIT
PYTHON_CFFI_LICENSE_FILES = LICENSE

# This host package uses pkg-config to find libffi, so we have to
# provide the proper hints for pkg-config to behave properly for host
# packages.
HOST_PYTHON_CFFI_ENV = \
	PKG_CONFIG_ALLOW_SYSTEM_CFLAGS=1 \
	PKG_CONFIG_ALLOW_SYSTEM_LIBS=1 \
	PKG_CONFIG="$(PKG_CONFIG_HOST_BINARY)" \
	PKG_CONFIG_SYSROOT_DIR="/" \
	PKG_CONFIG_LIBDIR="$(HOST_DIR)/lib/pkgconfig:$(HOST_DIR)/share/pkgconfig"
HOST_PYTHON_CFFI_DEPENDENCIES = host-pkgconf host-python-pycparser host-libffi

$(eval $(python-package))
$(eval $(host-python-package))
