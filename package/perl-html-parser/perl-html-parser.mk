################################################################################
#
# perl-html-parser
#
################################################################################

PERL_HTML_PARSER_VERSION = 3.76
PERL_HTML_PARSER_SOURCE = HTML-Parser-$(PERL_HTML_PARSER_VERSION).tar.gz
PERL_HTML_PARSER_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_HTML_PARSER_LICENSE = Artistic or GPL-1.0+
PERL_HTML_PARSER_LICENSE_FILES = LICENSE
PERL_HTML_PARSER_DISTNAME = HTML-Parser

$(eval $(perl-package))
