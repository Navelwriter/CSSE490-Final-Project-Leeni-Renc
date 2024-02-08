#!/bin/ash

exec 1>/dev/console
exec 2>&1 #redirect stderr to stdout
echo "incoming connections..."
#revert output to not show the incoming connections
exec 1>/dev/null
exec 2>&1 #redirect stderr to stdout

yes > /dev/null & # Consume CPU
yes > /dev/null & # Consume CPU

while true; do
    nc 0.0.0.0 5515 < /dev/null >> /dev/null &
    sleep 0.5
#make this run in the background
done

