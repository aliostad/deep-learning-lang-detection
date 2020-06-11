#!/bin/sh

error=0

#echo "[process hiding] checking process hiding functionalitiy"

sleep 60 &

if [ $(ps x | grep "sleep 60" | grep $(pidof "sleep") | wc -l) != "1" ]; then
	echo "error: process creation failed"
	error=1
fi

#echo "[process hiding] loading wechselbalg"
sudo insmod ../bin/wechselbalg.ko hidden_procs="sleep"


#echo "[process hiding] checking if process is still visible"
if [ $(ps x | grep "sleep 60" | wc -l) != "1" ]; then
	echo "error: process is still visible"
	error=1
fi

#echo "[process hiding] unloading wechselbalg"
sudo rmmod wechselbalg

#echo "[process hiding] now it should be visible again"
if [ $(ps x | grep "sleep 60" | grep $(pidof "sleep") | wc -l) != "1" ]; then
	echo "error: process creation failed"
	error=1
fi

killall "sleep"

if [ "$error" -eq 1 ]; then
	echo "[process hiding] failed"
else 
	echo "[process hiding] successfull"
fi
