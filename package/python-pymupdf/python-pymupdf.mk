################################################################################
#
# python-pymupdf
#
################################################################################

# python-pymupdf's version must match mupdf's version
PYTHON_PYMUPDF_VERSION = 1.18.14
PYTHON_PYMUPDF_SOURCE = PyMuPDF-$(PYTHON_PYMUPDF_VERSION).tar.gz
PYTHON_PYMUPDF_SITE = https://files.pythonhosted.org/packages/41/f6/dbefe3d6949fa81fb7bcac9141e4345330d272724718ac5a6af78297498b
PYTHON_PYMUPDF_SETUP_TYPE = setuptools
PYTHON_PYMUPDF_LICENSE = GPL-3.0, AGPL-3.0+ (code generated from mupdf)
PYTHON_PYMUPDF_LICENSE_FILES = COPYING
# No license file included in pip, but it's present on github
PYTHON_PYMUPDF_DEPENDENCIES = freetype mupdf zlib

PYTHON_PYMUPDF_ENV = CFLAGS="-I$(STAGING_DIR)/usr/include/mupdf -I$(STAGING_DIR)/usr/include/freetype2"

# We need to remove the original paths as we provide them in the CFLAGS:
define PYTHON_PYMUPDF_REMOVE_PATHS
	sed -i "/\/usr\/include\/mupdf/d" $(@D)/setup.py
	sed -i "/\/usr\/include\/freetype2/d" $(@D)/setup.py
	sed -i "/\/usr\/local\/include\/mupdf/d" $(@D)/setup.py
	sed -i "/mupdf\/thirdparty\/freetype\/include/d" $(@D)/setup.py
endef

PYTHON_PYMUPDF_POST_PATCH_HOOKS = PYTHON_PYMUPDF_REMOVE_PATHS

$(eval $(python-package))
