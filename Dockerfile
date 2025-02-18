FROM phusion/baseimage:noble-1.0.0 AS builder

MAINTAINER D-Jy <duan@d-jy.net>

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN echo 'APT::Get::Clean=always;' >> /etc/apt/apt.conf.d/99AutomaticClean

RUN apt-get update -qqy \
    && DEBIAN_FRONTEND=noninteractive apt-get -qyy install \
	--no-install-recommends \
	build-essential \
	git \
	cmake \
	fakeroot \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /tmp

RUN git clone --recursive https://github.com/rozhuk-im/msd_lite.git
RUN cd msd_lite && mkdir build && cd build && cmake .. &&  make -j 8


FROM debian:stable-slim

COPY --from=builder /tmp/msd_lite/build/src/msd_lite /usr/bin/msd_lite
COPY --from=builder /tmp/msd_lite/conf/msd_lite.conf /root/msd_lite.conf.sample
COPY msd_lite.conf /root/msd_lite.conf
COPY msd_lite.sh /root/msd_lite.sh
RUN chmod +x /usr/bin/msd_lite
RUN chmod +x /root/msd_lite.sh
RUN mkdir /etc/msd_lite

WORKDIR /root

ENTRYPOINT ["/bin/bash", "/root/msd_lite.sh"]
#CMD ["eth0", "7088"]
CMD []
