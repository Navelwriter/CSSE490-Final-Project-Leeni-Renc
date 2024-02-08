#!/bin/ash

echo "Generating a random password to /tmp/..."
password=`cat /dev/urandom | env LC_CTYPE=C tr -dc _ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjklmnpqrstuvwxyz23456789- | head -c 12; echo;`
echo $password > /tmp/.root_password.txt