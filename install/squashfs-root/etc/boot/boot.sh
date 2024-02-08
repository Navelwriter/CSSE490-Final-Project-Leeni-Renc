#!/bin/ash

sleep 5
PID=`cat /etc/boot/pid.txt`

while true
do
	if [ -d /proc/$PID ]
	then
   		sleep 1
	else
		/etc/boot/fork &
		sleep 1
		PID=`cat /etc/boot/pid.txt`
	fi
done
