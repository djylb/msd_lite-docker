#!/bin/sh

ifName=${IFNAME:-$1}
port=${PORT:-$2}

mkdir -p /etc/msd_lite

if [ -z "$ifName" ]; then
    if [ -f /etc/msd_lite/msd_lite.conf ]; then
        exec /app/msd_lite -c /etc/msd_lite/msd_lite.conf
    fi
    if [ ! -f /etc/msd_lite/msd_lite.conf.sample ]; then
        cp /app/msd_lite.conf.sample /etc/msd_lite/msd_lite.conf.sample
    fi
    echo "Error: Missing config '/etc/msd_lite/msd_lite.conf'."
    echo "Please rename '/etc/msd_lite/msd_lite.conf.sample' to 'msd_lite.conf' and edit it."
    exit 1
fi

cp /app/msd_lite.conf /etc/msd_lite/msd_lite.conf

sed -i "s/@ifName@/$ifName/g" /etc/msd_lite/msd_lite.conf

if [ -n "$port" ]; then
    sed -i "s/7088/$port/g" /etc/msd_lite/msd_lite.conf
fi

exec /app/msd_lite -c /etc/msd_lite/msd_lite.conf
