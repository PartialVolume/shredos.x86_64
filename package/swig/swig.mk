################################################################################
#
# swig
#
################################################################################

SWIG_VERSION_MAJOR = 4.0
SWIG_VERSION = $(SWIG_VERSION_MAJOR).2
SWIG_SITE = http://downloads.sourceforge.net/project/swig/swig/swig-$(SWIG_VERSION)
HOST_SWIG_DEPENDENCIES = host-bison host-pcre
HOST_SWIG_CONF_OPTS = \
	--with-pcre \
	--disable-ccache \
	--without-octave
SWIG_LICENSE = GPL-3.0+, BSD-2-Clause, BSD-3-Clause
SWIG_LICENSE_FILES = LICENSE LICENSE-GPL LICENSE-UNIVERSITIES

# CMake looks first at swig3.0, then swig2.0 and then swig. However,
# when doing the search, it will look into the PATH for swig2.0 first,
# and then for swig.
# While the PATH contains first our $(HOST_DIR)/bin, it also contains
# /usr/bin and other system directories. Therefore, if there is an
# installed swig3.0 on the system, it will get the preference over the
# swig installed in $(HOST_DIR)/bin, which isn't nice. To prevent
# this from happening we create a symbolic link swig3.0 -> swig, so that
# our swig always gets used.

define HOST_SWIG_INSTALL_SYMLINK
	ln -fs swig $(HOST_DIR)/bin/swig$(SWIG_VERSION_MAJOR)
	ln -fs swig $(HOST_DIR)/bin/swig3.0
endef

HOST_SWIG_POST_INSTALL_HOOKS += HOST_SWIG_INSTALL_SYMLINK

$(eval $(host-autotools-package))

SWIG = $(HOST_DIR)/bin/swig$(SWIG_VERSION_MAJOR)
