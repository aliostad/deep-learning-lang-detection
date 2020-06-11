#!/bin/env bash

DVB_SCAN_LOC=true

DVB_FROM_DIR='/usr/share/dvb-apps/dvb-t'
DVB_FROM_TAG='it'
DVB_FROM_SEP=':'
DVB_FROM_LOC="$DVB_FROM_TAG-Robbiate-$(date +%Y%m%d)"
DVB_FROM_CFG=$(ls $DVB_FROM_DIR/$DVB_FROM_TAG*)

if ( $DVB_SCAN_LOC ); then
#CZ#[ ! -e "$DVB_FROM_LOC" ] && w_scan -x -c "$DVB_FROM_TAG" | tee "$DVB_FROM_LOC" \
    [ ! -e "$DVB_FROM_LOC" ] && w_scan -x                    | tee "$DVB_FROM_LOC" \
                             || echo "Scan channels for '$DVB_FROM_LOC' is alrady exists" >&2
    DVB_FROM_TAG=$DVB_FROM_LOC
    DVB_FROM_CFG=$DVB_FROM_LOC
fi

DVB_SAVE_TAG='dvbtchannels'
DVB_SAVE_NOW=`date +%Y%m%d`
DVB_SAVE_DIR=$1 ; [ -z "$DVB_SAVE_DIR" ] && DVB_SAVE_DIR="$DVB_SAVE_TAG-$DVB_FROM_TAG.d-$DVB_SAVE_NOW" && mkdir -p "$DVB_SAVE_DIR"
DVB_SAVE_CFG="$DVB_SAVE_DIR/$DVB_SAVE_TAG-$DVB_FROM_TAG.conf"

for file_conf in $DVB_FROM_CFG; do
	file_name=`basename $file_conf`
	file_save="$DVB_SAVE_DIR/$DVB_SAVE_TAG-$file_name.conf"

	[ ! -e "$file_save" ] && scandvb "$file_conf" > "$file_save" \
	                      || echo "Channels for $file_name is alrady exists" >&2
done

rm -f "$DVB_SAVE_CFG"

#CZ#IFS=$'\n'
#CZ#for channel in `cat $DVB_SAVE_DIR/$DVB_SAVE_TAG* | cut -d"$DVB_FROM_SEP" -f1 | sort | uniq`; do
#CZ#	grep -h "^$channel$DVB_FROM_SEP" $DVB_SAVE_DIR/$DVB_SAVE_TAG* | head -n 1 | tee -a "$DVB_SAVE_CFG"
#CZ#done

exit
