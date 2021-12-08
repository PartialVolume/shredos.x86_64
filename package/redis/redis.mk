################################################################################
#
# redis
#
################################################################################

REDIS_VERSION = 6.2.6
REDIS_SITE = http://download.redis.io/releases
REDIS_LICENSE = BSD-3-Clause (core); MIT and BSD family licenses (Bundled components)
REDIS_LICENSE_FILES = COPYING
REDIS_CPE_ID_VENDOR = redislabs
REDIS_SELINUX_MODULES = redis

define REDIS_USERS
	redis -1 redis -1 * /var/lib/redis /bin/false - Redis Server
endef

# Uses __atomic_fetch_add_4. Adding -latomic to LDFLAGS does not work,
# because LDFLAGS is used before the list of object files. We need to
# add -latomic to FINAL_LIBS to provide -latomic at the correct place
# in the linking command.
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
define REDIS_FIX_MAKEFILE
	$(SED) 's/FINAL_LIBS=-lm/FINAL_LIBS=-lm -latomic/' $(@D)/src/Makefile
endef
REDIS_POST_PATCH_HOOKS = REDIS_FIX_MAKEFILE
endif

# Redis doesn't support DESTDIR (yet, see
# https://github.com/antirez/redis/pull/609).  We set PREFIX
# instead.
REDIS_BUILDOPTS = $(TARGET_CONFIGURE_OPTS) \
	PREFIX=$(TARGET_DIR)/usr MALLOC=libc

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
REDIS_DEPENDENCIES += systemd
REDIS_BUILDOPTS += USE_SYSTEMD=yes
else
REDIS_BUILDOPTS += USE_SYSTEMD=no
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL),y)
REDIS_DEPENDENCIES += libopenssl
REDIS_BUILDOPTS += BUILD_TLS=yes
else
REDIS_BUILDOPTS += BUILD_TLS=no
endif

define REDIS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(REDIS_BUILDOPTS) -C $(@D)
endef

define REDIS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(REDIS_BUILDOPTS) -C $(@D) \
		LDCONFIG=true install
	$(INSTALL) -D -m 0644 $(@D)/redis.conf \
		$(TARGET_DIR)/etc/redis.conf
endef

define REDIS_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/redis/S50redis \
		$(TARGET_DIR)/etc/init.d/S50redis
endef

define REDIS_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/redis/redis.service \
		$(TARGET_DIR)/usr/lib/systemd/system/redis.service
endef

$(eval $(generic-package))
