################################################################################
#
# perl-xml-libxml
#
################################################################################

PERL_XML_LIBXML_VERSION = 2.0134
PERL_XML_LIBXML_SOURCE = XML-LibXML-$(PERL_XML_LIBXML_VERSION).tar.gz
PERL_XML_LIBXML_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SH/SHLOMIF
PERL_XML_LIBXML_DEPENDENCIES = zlib libxml2
PERL_XML_LIBXML_LICENSE = Artistic or GPL-1.0+
PERL_XML_LIBXML_LICENSE_FILES = LICENSE
PERL_XML_LIBXML_CPE_ID_VENDOR = xml-libxml_project
PERL_XML_LIBXML_CPE_ID_PRODUCT = xml-libxml
PERL_XML_LIBXML_DISTNAME = XML-LibXML

PERL_XML_LIBXML_CONF_OPTS = \
	LIBS="-L $(STAGING_DIR)/usr/lib" \
	INC="-I $(STAGING_DIR)/usr/include/libxml2" \
	NO_THREADS

$(eval $(perl-package))
