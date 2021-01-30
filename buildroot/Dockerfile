#syntax=docker/dockerfile:1.2

FROM klutchell/buildroot-base:2020.11 as build

COPY package/ package/

RUN echo "source package/rpi-fbcp/Config.in" >> package/Config.in && \
    echo "source package/fbcp-ili9341/Config.in" >> package/Config.in

COPY common.cfg rpi-fbcp.cfg ./

RUN support/kconfig/merge_config.sh -m common.cfg rpi-fbcp.cfg

# hadolint ignore=SC2215
RUN --mount=type=cache,target=/cache,uid=1000,gid=1000,sharing=private \
    make olddefconfig && make

# hadolint ignore=DL3002
USER root

WORKDIR /rootfs

RUN tar xpf /home/br-user/output/images/rootfs.tar -C /rootfs

FROM scratch

COPY --from=build rootfs/ /

CMD [ "/bin/fbcp" ]
