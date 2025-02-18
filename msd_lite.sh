#!/bin/bash

# Read network interface name and port from environment variables or command line arguments
ifName=${IFNAME:-$1}
port=${PORT:-$2}

# Check if the msd_lite configuration file exists
if [ -f /etc/msd_lite/msd_lite.conf ]; then
    # If the configuration file exists, run msd_lite with it
    /usr/bin/msd_lite -c /etc/msd_lite/msd_lite.conf
else
    # If not, copy the sample configuration file to the directory
    cp /root/msd_lite.conf.sample /etc/msd_lite/msd_lite.conf.sample
fi

# Exit if no network interface name is provided
if [ -z "$ifName" ]; then
    echo "Please rename /etc/msd_lite/msd_lite.conf.sample to msd_lite.conf and modify it. Exiting."
    exit 1
fi

# Copy the configuration file from root to the correct location
cp /root/msd_lite.conf /etc/msd_lite/msd_lite.conf

# Replace the placeholder with the actual network interface name
sed -i "s/@ifName@/$ifName/g" /etc/msd_lite/msd_lite.conf

# If a port is provided, replace the default port with it
if [ ! -z "$port" ]; then
    sed -i "s/7088/$port/g" /etc/msd_lite/msd_lite.conf
fi

# Execute msd_lite with the configuration file
/usr/bin/msd_lite -c /etc/msd_lite/msd_lite.conf
