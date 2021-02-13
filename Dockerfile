#syntax=docker/dockerfile:1.2

FROM klutchell/buildroot-base:2020.11 as build

ARG FBCP_DISPLAY=adafruit-ili9341-pitft

# copy custom packages
COPY package/ package/

# add custom packages to package config
RUN echo "source package/fbcp-ili9341/Config.in" >> package/Config.in && \
    echo "source package/rpi-fbcp/Config.in" >> package/Config.in

# copy all config files
COPY config/ ./

# merge common config with selected display config
RUN support/kconfig/merge_config.sh -m common.cfg $FBCP_DISPLAY.cfg

# download sources first as a separate run command
# hadolint ignore=SC2215
RUN --mount=type=cache,target=/cache,uid=1000,gid=1000,sharing=private \
    make olddefconfig && make source

# compile packages second as a separate run command
# hadolint ignore=SC2215
RUN --mount=type=cache,target=/cache,uid=1000,gid=1000,sharing=private \
    make

# hadolint ignore=DL3002
USER root

WORKDIR /rootfs

RUN tar xpf /home/br-user/output/images/rootfs.tar -C /rootfs

FROM scratch

COPY --from=build rootfs/ /

CMD [ "/usr/bin/fbcp" ]
