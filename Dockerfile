FROM phusion/baseimage:noble-1.0.0 AS builder

LABEL maintainer="D-Jy <duan@d-jy.net>"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN echo 'APT::Get::Clean=always;' >> /etc/apt/apt.conf.d/99AutomaticClean && \
    apt-get update -qqy && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qyy --no-install-recommends \
        build-essential \
        git \
        cmake \
        fakeroot \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

RUN git clone --recursive https://github.com/rozhuk-im/msd_lite.git && \
    cd msd_lite && \
    cp conf/msd_lite.conf conf/msd_lite.conf.sample && \
    mkdir build && cd build && \
    LDFLAGS="-static" CXXFLAGS="-static" CFLAGS="-static" cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_C_FLAGS="-O3 -mtune=generic -flto -static" \
      -DCMAKE_CXX_FLAGS="-O3 -mtune=generic -flto -static" \
      -DCMAKE_EXE_LINKER_FLAGS="-static" && \
    make -j$(nproc)

COPY msd_lite.conf msd_lite.sh /tmp/msd_lite/

RUN mkdir -p /app && \
    install -m 755 /tmp/msd_lite/build/src/msd_lite /app/msd_lite && \
    install -m 644 /tmp/msd_lite/conf/msd_lite.conf /app/msd_lite.conf.sample && \
    install -m 644 /tmp/msd_lite/msd_lite.conf /app/msd_lite.conf && \
    install -m 755 /tmp/msd_lite/msd_lite.sh /app/msd_lite.sh

FROM busybox:stable-glibc

COPY --from=builder /app /app

WORKDIR /app

ENTRYPOINT ["/bin/sh", "/app/msd_lite.sh"]
#CMD ["eth0", "7088"]
CMD []
