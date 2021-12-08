################################################################################
#
# perl-http-cookies
#
################################################################################

PERL_HTTP_COOKIES_VERSION = 6.10
PERL_HTTP_COOKIES_SOURCE = HTTP-Cookies-$(PERL_HTTP_COOKIES_VERSION).tar.gz
PERL_HTTP_COOKIES_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_HTTP_COOKIES_LICENSE = Artistic or GPL-1.0+
PERL_HTTP_COOKIES_LICENSE_FILES = LICENSE
PERL_HTTP_COOKIES_DISTNAME = HTTP-Cookies

$(eval $(perl-package))
