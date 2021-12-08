################################################################################
#
# xl2tp
#
################################################################################

XL2TP_VERSION = 1.3.16
XL2TP_SITE = $(call github,xelerance,xl2tpd,v$(XL2TP_VERSION))
XL2TP_DEPENDENCIES = libpcap
XL2TP_LICENSE = GPL-2.0
XL2TP_LICENSE_FILES = LICENSE
XL2TP_SELINUX_MODULES = l2tp

ifeq ($(BR2_STATIC_LIBS),y)
XL2TP_LDLIBS = LDLIBS="`$(STAGING_DIR)/usr/bin/pcap-config --static --additional-libs`"
endif

define XL2TP_BUILD_CMDS
	$(SED) 's/ -O2 //' $(@D)/Makefile
	$(TARGET_CONFIGURE_OPTS) $(MAKE) $(XL2TP_LDLIBS) -C $(@D)
endef

define XL2TP_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(TARGET_DIR) PREFIX=/usr -C $(@D) install
endef

$(eval $(generic-package))
