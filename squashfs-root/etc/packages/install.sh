#!/bin/ash
# This script installs all of the ipk packages in the current directory
# This will essentially run opkg install /etc/packages/*.ipk

#Redirect output to serial console at /dev/console
exec 1>/dev/console
exec 2>&1 #redirect stderr to stdout
# Check if the packages directory exists
if [ -d /etc/packages ]; then
    # First install shadow-common 
    opkg install /etc/packages/shadow-common_4.2.1-8_arm_cortex-a7_neon-vfpv4.ipk
    opkg install /etc/packages/zlib_1.2.11-2_arm_cortex-a7_neon-vfpv4.ipk
    opkg install /etc/packages/libelf1_0.169-1_arm_cortex-a7_neon-vfpv4.ipk
    # Then install the rest of the packages, suppressing the configuring messages
    opkg install /etc/packages/*.ipk
else
    echo "The packages directory does not exist"
fi
