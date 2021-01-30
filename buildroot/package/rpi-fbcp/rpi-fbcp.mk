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

$(eval $(cmake-package))
