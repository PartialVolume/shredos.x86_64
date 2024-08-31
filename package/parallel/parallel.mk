################################################################################
#
# parallel
#
################################################################################

# https://ftp.gnu.org/gnu/parallel/parallel-20240822.tar.bz2.sig
# Latest version can always be sourced at https://ftp.gnu.org/gnu/parallel/parallel-latest.tar.bz2

PARALLEL_VERSION = 20240822
PARALLEL_SOURCE = parallel-$(PARALLEL_VERSION).tar.bz2
PARALLEL_SITE = https://ftp.gnu.org/gnu/parallel
PARALLEL_LICENSE = GPL-3.0-only
PARALLEL_LICENSE_FILES = LICENSES/GPL-3.0-only.txt

$(eval $(autotools-package))