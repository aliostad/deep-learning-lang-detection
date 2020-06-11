#!/bin/bash

apk_file="/home/tt/bin/apk.log"
apk_save="/home/tt/tmp/apk_save"
apk_old_dir="/home/tt/work/gt/gt_android/out/target/product/msm8625/system"

if [ -d $apk_save ]
then
	echo "$apk_save is exist"
	rm -rvf $apk_save
else
	echo "create $apk_save dir"
fi

mkdir -p $apk_save

if [ $? = 0 ]
then
	echo "$apk_save is ok"
fi

if [ -d $apk_old_dir ]
then
	cd $apk_old_dir
	pwd

	if [ -e $apk_file ]
	then
    	while read line
	    do
			apkfile=`find . -name "$line" |grep "$line"`
			if [ -z "$apkfile" ]
			then
				echo "error ....not file$line........"
			else
				echo "$apkfile"
				cp -v $apkfile $apk_save
			fi

	    done <$apk_file
	else
    	echo "apk.log not exist"
	fi
	
else
	echo "no apk old dir"
fi


