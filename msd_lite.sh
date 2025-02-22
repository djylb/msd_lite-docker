#!/bin/sh

ifName=${IFNAME:-$1}
port=${PORT:-$2}

if [ ! -d /etc/msd_lite ]; then
    mkdir -p /etc/msd_lite
fi

if [ -f /etc/msd_lite/msd_lite.conf ]; then
    /app/msd_lite -c /etc/msd_lite/msd_lite.conf
else
    if [ ! -f /etc/msd_lite/msd_lite.conf.sample ]; then
        cp /app/msd_lite.conf.sample /etc/msd_lite/msd_lite.conf.sample
    fi
fi

if [ -z "$ifName" ]; then
    echo "Please rename /etc/msd_lite/msd_lite.conf.sample to msd_lite.conf and modify it."
    exit 1
fi

cp /app/msd_lite.conf /etc/msd_lite/msd_lite.conf

sed -i "s/@ifName@/$ifName/g" /etc/msd_lite/msd_lite.conf

if [ ! -z "$port" ]; then
    sed -i "s/7088/$port/g" /etc/msd_lite/msd_lite.conf
fi

/app/msd_lite -c /etc/msd_lite/msd_lite.conf
