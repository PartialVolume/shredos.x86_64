################################################################################
#
# perl-timedate
#
################################################################################

PERL_TIMEDATE_VERSION = 2.33
PERL_TIMEDATE_SOURCE = TimeDate-$(PERL_TIMEDATE_VERSION).tar.gz
PERL_TIMEDATE_SITE = $(BR2_CPAN_MIRROR)/authors/id/A/AT/ATOOMIC
PERL_TIMEDATE_LICENSE = Artistic or GPL-1.0+
PERL_TIMEDATE_LICENSE_FILES = README
PERL_TIMEDATE_DISTNAME = TimeDate

$(eval $(perl-package))
