# balenablocks/fbcp

Provides `fbcp` driver for SPI based displays for Raspberry Pis via [fbcp-ili9341](https://github.com/juj/fbcp-ili9341)

## Supported Displays

fbcp-ili9341 [supports several displays](https://github.com/juj/fbcp-ili9341#which-spi-display-should-i-buy-to-make-sure-it-works-best-with-fbcp-ili9341) but we have compiled controllers for

| Display                                                                    | Tag                         | Tested | Tested On |
| -------------------------------------------------------------------------- | --------------------------- | ------ | --------- |
| Adafruit PiTFT - Assembled 480x320 3.5" TFT+Touchscreen for Raspberry Pi   | `adafruit-hx8357d-pitft`    | ✅     | 3B+       |
| Adafruit 2.8" 320x240 TFT w/ Touch screen for Raspberry Pi                 | `adafruit-ili9341-pitft`    |        |           |
| Adafruit PiTFT 2.2" HAT Mini Kit - 320x240 2.2" TFT - No Touch             | `adafruit-ili9341-pitft`    |        |           |
| Freeplay CM3 DIY Kit                                                       | `freeplaytech-waveshare32b` |        |           |
| Waveshare 3.5" 480x320 (ILI9486)                                           | `waveshare35b-ili9486`      |        |           |
| Tontec 3.5" 320x480 LCD Display                                            | `tontec-mz61581`            |        |           |
| Waveshare 240x240, 1.3inch IPS LCD display HAT for Raspberry Pi (ST7789VW) | `waveshare-st7789vw-hat`    |        |           |
| Waveshare 128x128, 1.44inch LCD display HAT for Raspberry Pi (ST7735S)     | `waveshare-st7735s-hat`     |        |           |
| KeDei 3.5 inch SPI TFTLCD 480\*320 16bit/18bit version 6.3 2018/4/9        | `kedei-v63-mpi3501`         |        |           |
| Generic rpi-fbcp using `BALENA_HOST_CONFIG_dtoverlay` for drivers          | `dtoverlay`                 | ✅     | 3B+       |

## Usage

`fbcp` is meant to be used alongside other services, so you will need to create a service in your `docker-compose.yml` file:

So for example, if you are using `fbcp` with the Adafruit PiTFT - Assembled 480x320 3.5" TFT+Touchscreen along with the [dashboard](https://github.com/balenablocks/dashboard) and [browser](https://github.com/balenablocks/browser) blocks with a Raspberry Pi 3, you would use the following `docker-compose.yml` file

```yml
version: "2.1"

services:
  fbcp:
    image: balenablocks/fbcp
    privileged: true
  dashboard:
    image: balenablocks/dashboard:raspberrypi3
    restart: always
    network_mode: host
    volumes:
      - "dashboard-data:/data"
    ports:
      - "80"
  browser:
    image: balenablocks/browser:raspberrypi3
    network_mode: host
    privileged: true
    environment:
      - "KIOSK=1"
```

Then set the `FBCP_DISPLAY` environment variable. e.g `FBCP_DISPLAY=adafruit-hx8357d-pitft`

## ⚠️ Touch compatibility ⚠️

`fbcp` block includes two drivers, namely

- [tasanakorn/rpi-fbcp](https://github.com/tasanakorn/rpi-fbcp) which has touch support and is used when `FBCP_DISPLAY=dtoverlay`. You will still need to set the proper dtoverlay driver and params.
- [juj/fbcp-ili9341](https://github.com/juj/fbcp-ili9341) which **does not** have touch support. See [here](https://github.com/juj/fbcp-ili9341#does-fbcp-ili9341-work-with-touch-displays)

## Configuring HDMI and TFT display sizes

The following [Device Configuration](https://www.balena.io/docs/learn/manage/configuration/#configuration-variables) variables might be required for proper scaling and resolutions:

| Name                                  | Value                                                                                     |
| ------------------------------------- | ----------------------------------------------------------------------------------------- |
| BALENA_HOST_CONFIG_hdmi_cvt           | `<width> <height> <framerate> <aspect> <margins> <interlace> <rb>` e.g 480 320 60 1 0 0 0 |
| BALENA_HOST_CONFIG_hdmi_force_hotplug | 1                                                                                         |
| BALENA_HOST_CONFIG_hdmi_group         | 2                                                                                         |
| BALENA_HOST_CONFIG_hdmi_mode          | 87                                                                                        |

_These lines hint native applications about the default display mode, and let them render to the native resolution of the TFT display. This can however prevent the use of the HDMI connector, if the HDMI connected display does not support such a small resolution._

You can read more about these settings in the original [fbcp-ili9341](https://github.com/juj/fbcp-ili9341) documentation [here](https://github.com/juj/fbcp-ili9341#configuring-hdmi-and-tft-display-sizes).
