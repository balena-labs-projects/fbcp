FROM balenalib/rpi-python:build AS builder

ARG TARGET

WORKDIR /usr/src/app



RUN install_packages cmake libraspberrypi-dev git rsync binutils

RUN pip install git+https://github.com/larsks/dockerize

RUN git clone https://github.com/juj/fbcp-ili9341.git

WORKDIR /usr/src/app/fbcp-ili9341

RUN sed -i '212 s/^/\/\//' config.h

RUN sed -i '$d' CMakeLists.txt

RUN echo "target_link_libraries(fbcp-ili9341 pthread bcm_host vchiq_arm vcos atomic)" >> CMakeLists.txt


WORKDIR /usr/src/app/fbcp-ili9341/build

RUN cmake \
    -D${TARGET}=ON \
    -DSPI_BUS_CLOCK_DIVISOR=30 \
    -DBACKLIGHT_CONTROL=ON \
    -DSTATISTICS=0 \
    .. \
    && make -j

RUN cp /usr/src/app/fbcp-ili9341/build/fbcp-ili9341 /usr/src/fbcp


WORKDIR /usr/src/app/output

RUN dockerize -n --verbose -o /usr/src/app/output/  /usr/src/fbcp


FROM scratch

COPY --from=builder /usr/src/app/output/ ./

CMD ["/usr/src/fbcp"]