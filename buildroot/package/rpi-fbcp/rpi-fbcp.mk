################################################################################
#
# rpi-fbcp
#
################################################################################

RPI_FBCP_VERSION = af8d32246c23cb23e4030e6588668a14341f5ddc
RPI_FBCP_SITE = $(call github,tasanakorn,rpi-fbcp,$(RPI_FBCP_VERSION))
RPI_FBCP_LICENSE = MIT
RPI_FBCP_LICENSE_FILES = LICENSE
RPI_FBCP_DEPENDENCIES = rpi-userland

define RPI_FBCP_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fbcp $(STAGING_DIR)/usr/bin
endef

define RPI_FBCP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fbcp $(TARGET_DIR)/usr/bin
endef

$(eval $(cmake-package))
