#!/bin/bash

file="/home/pi/stran/data/load.csv"

a=$(wc -l "$file")
l=$(echo ${a%% *})
l1=$((($l-1)))

p=$(sed -n "$l1""p" "$file")
pred=$(echo ${p#*,})

z=$(sed -n "$l""p" "$file")
zad=$(echo ${z#*,})

datum=$(date '+%Y/%m/%d %H:%M:%S')

load=$(uptime)
temp=$(cat /sys/class/thermal/thermal_zone0/temp)
while [ $temp -gt 100000 -o $temp -lt 0 ]; do
	temp=$(cat /sys/class/thermal/thermal_zone0/temp)
done

load=$(echo ${load##*: })
load=$(echo ${load#*, })
load=$(echo "${load%%,*}*100" | bc)
load=$(printf "%0.f" $load)

temp=$(echo "$temp/1000.0" | bc -l)
temp=$(printf "%.1f" $temp)
if [ "$temp" == "85.0" ]; then
	temp="$(echo ${zad##*,})"
fi

if [ "$pred" == "$zad" -a "$zad" == "$load,$temp" ]; then
	sed -i "$l""d" "$file"
fi

echo "$datum,$load,$temp" >> "$file"
