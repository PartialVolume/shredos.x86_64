################################################################################
#
# dcron
#
################################################################################

DCRON_VERSION = 1ba33c3325df48de46263276a43ed76cf9d81518
DCRON_SITE = $(call github,dubiousjim,dcron,$(DCRON_VERSION))
DCRON_LICENSE = GPL-2.0+
DCRON_LICENSE_FILES = COPYING

define DCRON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(TARGET_CONFIGURE_OPTS)
endef

define DCRON_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m0700 $(@D)/crond $(TARGET_DIR)/usr/sbin/crond
	$(INSTALL) -D -m4755 $(@D)/crontab $(TARGET_DIR)/usr/bin/crontab
	$(INSTALL) -D -m0644 $(@D)/extra/root.crontab $(TARGET_DIR)/etc/cron.d/system
	# Busybox provides run-parts, so there is no need to use nor install provided run-cron
	$(SED) 's#/usr/sbin/run-cron#/bin/run-parts#g' $(TARGET_DIR)/etc/cron.d/system
	$(INSTALL) -d -m0755 $(TARGET_DIR)/var/spool/cron/crontabs \
		$(TARGET_DIR)/etc/cron.daily $(TARGET_DIR)/etc/cron.hourly \
		$(TARGET_DIR)/etc/cron.monthly $(TARGET_DIR)/etc/cron.weekly
endef

define DCRON_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/dcron/S90dcron $(TARGET_DIR)/etc/init.d/S90dcron
endef

define DCRON_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/dcron/dcron.service \
		$(TARGET_DIR)/usr/lib/systemd/system/dcron.service
endef

$(eval $(generic-package))
