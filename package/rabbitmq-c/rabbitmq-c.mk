################################################################################
#
# rabbitmq-c
#
################################################################################

RABBITMQ_C_VERSION = 0.11.0
RABBITMQ_C_SITE = $(call github,alanxz,rabbitmq-c,v$(RABBITMQ_C_VERSION))
RABBITMQ_C_LICENSE = MIT
RABBITMQ_C_LICENSE_FILES = LICENSE-MIT
RABBITMQ_C_CPE_ID_VENDOR = rabbitmq-c_project
RABBITMQ_C_INSTALL_STAGING = YES
RABBITMQ_C_CONF_OPTS = \
	-DBUILD_API_DOCS=OFF \
	-DBUILD_TOOLS_DOCS=OFF

# BUILD_SHARED_LIBS is handled in pkg-cmake.mk as it is a generic cmake variable
ifeq ($(BR2_SHARED_STATIC_LIBS),y)
RABBITMQ_C_CONF_OPTS += -DBUILD_STATIC_LIBS=ON
else ifeq ($(BR2_SHARED_LIBS),y)
RABBITMQ_C_CONF_OPTS += -DBUILD_STATIC_LIBS=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
RABBITMQ_C_CONF_OPTS += -DENABLE_SSL_SUPPORT=ON
RABBITMQ_C_DEPENDENCIES += openssl
else
RABBITMQ_C_CONF_OPTS += -DENABLE_SSL_SUPPORT=OFF
endif

ifeq ($(BR2_PACKAGE_POPT),y)
RABBITMQ_C_CONF_OPTS += -DBUILD_TOOLS=ON
RABBITMQ_C_DEPENDENCIES += popt
else
RABBITMQ_C_CONF_OPTS += -DBUILD_TOOLS=OFF
endif

$(eval $(cmake-package))
