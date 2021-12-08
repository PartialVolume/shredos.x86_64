################################################################################
#
# at
#
################################################################################

AT_VERSION = 3.2.2
AT_SOURCE = at_$(AT_VERSION).orig.tar.gz
AT_SITE = http://software.calhariz.com/at
AT_AUTORECONF = YES
AT_DEPENDENCIES = $(if $(BR2_PACKAGE_FLEX),flex) host-bison host-flex
AT_LICENSE = GPL-2.0+, GPL-3.0+, ISC
AT_LICENSE_FILES = Copyright COPYING

AT_CONF_OPTS = \
	--with-jobdir=/var/spool/cron/atjobs \
	--with-atspool=/var/spool/cron/atspool \
	--with-daemon_username=root \
	--with-daemon_groupname=root \
	SENDMAIL=/usr/sbin/sendmail

define AT_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/at/S99at $(TARGET_DIR)/etc/init.d/S99at
endef

$(eval $(autotools-package))
