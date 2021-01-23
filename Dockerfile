#syntax=docker/dockerfile:1.2

FROM klutchell/buildroot-base:2020.11 as build

# copy common config
COPY config/common.cfg ./.config

# build common packages first to make best use of layer caching
# hadolint ignore=SC2215
RUN --mount=type=cache,target=/cache,uid=1000,gid=1000,sharing=private \
    make olddefconfig && make source && make

# copy custom packages
COPY package/ package/

# add custom packages to package config
RUN echo "source package/fbcp-ili9341/Config.in" >> package/Config.in && \
    echo "source package/rpi-fbcp/Config.in" >> package/Config.in

# default to the legacy rpi-fbcp driver
ARG FBCP_DISPLAY=dtoverlay

# copy selected display config
COPY config/$FBCP_DISPLAY.cfg ./

# merge common config with selected display config
RUN support/kconfig/merge_config.sh -m .config $FBCP_DISPLAY.cfg

# build display packages, this should be quick and not rebuild common stuff
# hadolint ignore=SC2215
RUN --mount=type=cache,target=/cache,uid=1000,gid=1000,sharing=private \
    make olddefconfig && make source && make

# hadolint ignore=DL3002
USER root

WORKDIR /rootfs

# extract the rootfs so we can just COPY in future layers
RUN tar xpf /home/br-user/output/images/rootfs.tar -C /rootfs

# rename fbcp binary and replace with symlink
# this makes it easier to flatten multiple images into one in Dockerfile.all
RUN mv /rootfs/usr/bin/fbcp /rootfs/usr/bin/fbcp-$FBCP_DISPLAY && \
    ln -sf fbcp-$FBCP_DISPLAY /rootfs/usr/bin/fbcp

FROM scratch

COPY --from=build rootfs/ /

CMD [ "/usr/bin/fbcp" ]
