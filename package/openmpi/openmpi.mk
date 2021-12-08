################################################################################
#
# openmpi
#
################################################################################

OPENMPI_VERSION_MAJOR = 4.0
OPENMPI_VERSION = $(OPENMPI_VERSION_MAJOR).0
OPENMPI_SITE = https://www.open-mpi.org/software/ompi/v$(OPENMPI_VERSION_MAJOR)/downloads
OPENMPI_SOURCE = openmpi-$(OPENMPI_VERSION).tar.bz2
OPENMPI_LICENSE = BSD-3-Clause
OPENMPI_LICENSE_FILES = LICENSE
OPENMPI_INSTALL_STAGING = YES

# Enabling Fortran support requires pre-seeding the configure script
# with various values that cannot be guessed, so we provide cache
# files for various architectures.

ifeq ($(BR2_TOOLCHAIN_HAS_FORTRAN),y)
ifeq ($(BR2_mips)$(BR2_mipsel),y)
OPENMPI_FORTRAN_CONF_CACHE = package/openmpi/openmpi-mips32-fortran.cache
else ifeq ($(BR2_mips64)$(BR2_mips64el),y)
OPENMPI_FORTRAN_CONF_CACHE = package/openmpi/openmpi-mips64-fortran.cache
endif
endif

ifneq ($(OPENMPI_FORTRAN_CONF_CACHE),)
define OPENMPI_COPY_FORTRAN_CACHE
	cp $(OPENMPI_FORTRAN_CONF_CACHE) $(@D)/openmpi-config.cache
endef

OPENMPI_POST_PATCH_HOOKS += OPENMPI_COPY_FORTRAN_CACHE
OPENMPI_CONF_OPTS += \
	--enable-mpi-fortran=yes \
	--cache-file=$(@D)/openmpi-config.cache
else
OPENMPI_CONF_OPTS += --enable-mpi-fortran=no
endif

OPENMPI_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
OPENMPI_CFLAGS += -O0
endif

OPENMPI_CONF_ENV = CFLAGS="$(OPENMPI_CFLAGS)"

$(eval $(autotools-package))
