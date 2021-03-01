FROM balenalib/rpi-python:build AS builder

WORKDIR /usr/src/

RUN install_packages cmake libraspberrypi-dev git rsync binutils

RUN git clone https://github.com/tasanakorn/rpi-fbcp.git

WORKDIR /usr/src/rpi-fbcp

RUN sed '/target_link_libraries/d' -i CMakeLists.txt
RUN echo "target_link_libraries(fbcp pthread bcm_host vchiq_arm vcos atomic)" >> CMakeLists.txt

WORKDIR /usr/src/rpi-fbcp/build

RUN cmake .. && make && mv fbcp /usr/bin/fbcp-dtoverlay

WORKDIR /usr/src/

RUN git clone https://github.com/juj/fbcp-ili9341.git

WORKDIR /usr/src/fbcp-ili9341

RUN sed '/define TURN_DISPLAY_OFF_AFTER_USECS_OF_INACTIVITY/d' -i config.h
RUN sed '/target_link_libraries/d' -i CMakeLists.txt
RUN echo "target_link_libraries(fbcp-ili9341 pthread bcm_host vchiq_arm vcos atomic)" >> CMakeLists.txt

WORKDIR /usr/src/fbcp-ili9341/build

ARG DISPLAYS=" \
    adafruit-hx8357d-pitft \
    adafruit-ili9341-pitft \
    freeplaytech-waveshare32b \
    waveshare35b-ili9486 \
    tontec-mz61581 \
    waveshare-st7789vw-hat \
    waveshare-st7735s-hat \
    kedei-v63-mpi3501 \
"

RUN for display in ${DISPLAYS}; do \
        export target="$(echo "${display}" | tr - _ | tr [:lower:] [:upper:])" && \
        echo "Building for target ${display}" && \
        cmake \
        -D${target}=ON \
        -DSPI_BUS_CLOCK_DIVISOR=30 \
        -DBACKLIGHT_CONTROL=ON \
        -DSTATISTICS=0 \
        .. && \
        make -j"$(nproc)" && \
        mv fbcp-ili9341 "/usr/bin/fbcp-${display}" && \
        rm -rf ./* ; \
    done

WORKDIR /rootfs

RUN pip install git+https://github.com/larsks/dockerize

RUN dockerize -n --verbose -o /rootfs/ /usr/bin/fbcp-*

RUN rm /rootfs/Dockerfile

FROM arm32v5/busybox

COPY --from=builder /rootfs/ /

COPY start.sh ./

CMD ["./start.sh"]
