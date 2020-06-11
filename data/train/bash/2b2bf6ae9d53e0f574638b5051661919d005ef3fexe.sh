#!/bin/bash

mf_file=$1
visu=$2
ttf=$3
DATE=`date +%Y-%m-%d:%H:%M:%S`
nameSave=$4
fontLog=fontlog.txt

mftrace $mf_file.mf

python print.py $mf_file.pfa

eog png/$visu.png

if [ $ttf = "save_ttf" ]
	then
		cp ocr-pbi.ttf archive/
		mv archive_ttf/ocr-pbi.ttf archive/$mf_file---$DATE.ttf
	fi

if [ $ttf = "save_all" ]
	then
		mkdir archive/$nameSave--$DATE
		cp ocr-pbi.ttf archive/$nameSave--$DATE
		cp ocr-pbi.mf archive/$nameSave--$DATE
		cp ocr-pbi-def.mf archive/$nameSave--$DATE
		cp ocr-pbi-mac.mf archive/$nameSave--$DATE
		cp exe.sh archive/$nameSave--$DATE
		cp print.py archive/$nameSave--$DATE
		cp -R png archive/$nameSave--$DATE
		mv archive/$nameSave--$DATE/ocr-pbi.ttf archive/$nameSave--$DATE/$mf_file---$nameSave.ttf

		echo "	C o m m e n t
		|
		v"
		read comment

		echo "
------------------------------------
Date : "$DATE"  Version : "$nameSave"

     C o m m e n t -----> "$comment"

		 end
		 " >> $fontLog

	fi
