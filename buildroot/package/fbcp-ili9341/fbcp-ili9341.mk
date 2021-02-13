################################################################################
#
# fbcp-ili9341
#
################################################################################

# TODO: apply patches from Dockerfile.all and/or this GH issue
# https://github.com/juj/fbcp-ili9341/issues/50
# 1. sed -i '212 s/^/\/\//' config.h
# 2. sed -i '$d' CMakeLists.txt
# 3. echo "target_link_libraries(fbcp-ili9341 pthread bcm_host vchiq_arm vcos atomic)" >> CMakeLists.txt

FBCP_ILI9341_VERSION = 662e8db76ba16d86cf6fd09d85240adc19e62735
FBCP_ILI9341_SITE = $(call github,juj,fbcp-ili9341,$(FBCP_ILI9341_VERSION))
FBCP_ILI9341_LICENSE = MIT
FBCP_ILI9341_LICENSE_FILES = LICENSE.txt
FBCP_ILI9314_DEPENDENCIES = rpi-userland
FBCP_ILI9341_CONF_OPTS = \
    -DSPI_BUS_CLOCK_DIVISOR=30 \
    -DBACKLIGHT_CONTROL=ON \
    -DSTATISTICS=0

define FBCP_ILI9341_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fbcp $(STAGING_DIR)/usr/bin
endef

define FBCP_ILI9341_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/fbcp $(TARGET_DIR)/usr/bin
endef

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_ADAFRUIT_HX8357D_PITFT),y)
    FBCP_ILI9341_CONF_OPTS += -DADAFRUIT_HX8357D_PITFT=ON
endif

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_ADAFRUIT_ILI9341_PITFT),y)
    FBCP_ILI9341_CONF_OPTS += -DADAFRUIT_ILI9341_PITFT=ON
endif

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_FREEPLAYTECH_WAVESHARE32B),y)
    FBCP_ILI9341_CONF_OPTS += -DFREEPLAYTECH_WAVESHARE32B=ON
endif

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_WAVESHARE35B_ILI9486),y)
    FBCP_ILI9341_CONF_OPTS += -DWAVESHARE35B_ILI9486=ON
endif

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_TONTEC_MZ61581),y)
    FBCP_ILI9341_CONF_OPTS += -DTONTEC_MZ61581=ON
endif

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_WAVESHARE_ST7789VW_HAT),y)
    FBCP_ILI9341_CONF_OPTS += -DWAVESHARE_ST7789VW_HAT=ON
endif

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_WAVESHARE_ST7735S_HAT),y)
    FBCP_ILI9341_CONF_OPTS += -DWAVESHARE_ST7735S_HAT=ON
endif

ifeq ($(BR2_PACKAGE_FBCP_ILI9341_KEDEI_V63_MPI3501),y)
    FBCP_ILI9341_CONF_OPTS += -DKEDEI_V63_MPI3501=ON
endif

$(eval $(cmake-package))
