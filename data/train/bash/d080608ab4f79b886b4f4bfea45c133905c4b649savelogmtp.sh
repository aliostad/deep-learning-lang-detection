#!/system/bin/sh

# savelog
SAVE_LOG_ROOT=/data/media/save_log
BUSYBOX=busybox

# check mount file
	umask 0;
	sync
############################################################################################	
	# create savelog folder (UTC)
	SAVE_LOG_PATH="$SAVE_LOG_ROOT/`date +%Y_%m_%d_%H_%M_%S`"
	$BUSYBOX mkdir -p $SAVE_LOG_PATH
	setprop asus.savelogmtp.folder $SAVE_LOG_PATH
	echo "$BUSYBOX mkdir -p $SAVE_LOG_PATH"
############################################################################################
	# save cmdline
	busybox cat /proc/cmdline > $SAVE_LOG_PATH/cmdline.txt
	echo "cat /proc/cmdline > $SAVE_LOG_PATH/cmdline.txt"	
############################################################################################
	# save mount table
	busybox cat /proc/mounts > $SAVE_LOG_PATH/mounts.txt
	echo "cat /proc/mounts > $SAVE_LOG_PATH/mounts.txt"
############################################################################################
	# save property
	getprop > $SAVE_LOG_PATH/getprop.txt
	echo "getprop > $SAVE_LOG_PATH/getprop.txt"
############################################################################################
	# save network info
	busybox route -n > $SAVE_LOG_PATH/route.txt
	echo "busybox route -n > $SAVE_LOG_PATH/route.txt"
	busybox ifconfig -a > $SAVE_LOG_PATH/ifconfig.txt
	echo "busybox ifconfig -a > $SAVE_LOG_PATH/ifconfig.txt"
############################################################################################
	# save software version
	AP_VER=`getprop ro.build.display.id`
	CP_VER=`getprop gsm.version.baseband`
	BUILD_DATE=`getprop ro.build.date`
	echo "AP_VER: $AP_VER" > $SAVE_LOG_PATH/version.txt
	echo "CP_VER: $CP_VER" >> $SAVE_LOG_PATH/version.txt
	echo "BUILD_DATE: $BUILD_DATE" >> $SAVE_LOG_PATH/version.txt
############################################################################################
	# save load kernel modules
	busybox lsmod > $SAVE_LOG_PATH/lsmod.txt
	echo "lsmod > $SAVE_LOG_PATH/lsmod.txt"
############################################################################################
	# save process now
	ps > $SAVE_LOG_PATH/ps.txt
	echo "ps > $SAVE_LOG_PATH/ps.txt"
	busybox ps -To user,pid,ppid,vsz,rss,args > $SAVE_LOG_PATH/ps_thread.txt
	echo "busybox ps > $SAVE_LOG_PATH/ps_thread.txt"
############################################################################################
	# save kernel message
	dmesg > $SAVE_LOG_PATH/dmesg.txt
	echo "dmesg > $SAVE_LOG_PATH/dmesg.txt"
############################################################################################
	# copy data/log to data/media
	busybox ls -R -l /data/log/ > $SAVE_LOG_PATH/ls_data_log.txt
	mkdir $SAVE_LOG_PATH/log
	busybox mv /data/log/* $SAVE_LOG_PATH/log/
	echo "busybox mv /data/log $SAVE_LOG_PATH"
############################################################################################
	# copy data/tombstones to data/media
	busybox ls -R -l /data/tombstones/ > $SAVE_LOG_PATH/ls_data_tombstones.txt
	mkdir $SAVE_LOG_PATH/tombstones
	busybox mv /data/tombstones/* $SAVE_LOG_PATH/tombstones/
	echo "busybox mv /data/tombstones $SAVE_LOG_PATH"	
############################################################################################
	# copy data/tombstones to data/media
	#busybox ls -R -l /tombstones/mdm > $SAVE_LOG_PATH/ls_tombstones_mdm.txt
	busybox mkdir -p /data/tombstones/dsps
	busybox mkdir -p /data/tombstones/lpass
	busybox mkdir -p /data/tombstones/mdm
	busybox mkdir -p /data/tombstones/modem
	busybox mkdir -p /data/tombstones/wcnss
	chown system.system /data/tombstones/*
	chmod 771 /data/tombstones/*
############################################################################################
	# copy Debug Ion information to data/media
	mkdir $SAVE_LOG_PATH/ION_Debug
	$BUSYBOX cp /d/ion/* $SAVE_LOG_PATH/ION_Debug/
############################################################################################
	# copy data/logcat_log to data/media
	busybox ls -R -l /data/logcat_log/ > $SAVE_LOG_PATH/ls_data_logcat_log.txt
	$BUSYBOX cp -r /data/logcat_log/ $SAVE_LOG_PATH
	echo "$BUSYBOX cp -r /data/logcat_log $SAVE_LOG_PATH"
############################################################################################
	# copy /sdcard/ASUSEvtlog.txt to data/media
	busybox cp -r /sdcard/ASUSEvtlog.txt $SAVE_LOG_PATH #backward compatible
	busybox cp -r /sdcard/ASUSEvtlog_old.txt $SAVE_LOG_PATH #backward compatible
	busybox cp -r /sdcard/asus_log/ASUSEvtlog.txt $SAVE_LOG_PATH
	busybox cp -r /sdcard/asus_log/ASUSEvtlog_old.txt $SAVE_LOG_PATH
	busybox cp -r /data/media/asus_log/ASDF $SAVE_LOG_PATH && busybox rm -r /data/media/asus_log/ASDF/ASDF.*
	echo "busybox cp -r /sdcard/ASUSEvtlog.txt $SAVE_LOG_PATH"
############################################################################################
	# copy /data/misc/wifi/wpa_supplicant.conf
	# copy /data/misc/wifi/hostapd.conf
	# copy /data/misc/wifi/p2p_supplicant.conf
	$BUSYBOX ls -R -l /data/misc/wifi/ > $SAVE_LOG_PATH/ls_wifi_asus_log.txt
	$BUSYBOX cp -r /data/misc/wifi/wpa_supplicant.conf $SAVE_LOG_PATH
	echo "$BUSYBOX cp -r /data/misc/wifi/wpa_supplicant.conf $SAVE_LOG_PATH"
	$BUSYBOX cp -r /data/misc/wifi/hostapd.conf $SAVE_LOG_PATH
	echo "$BUSYBOX cp -r /data/misc/wifi/hostapd.conf $SAVE_LOG_PATH"
	$BUSYBOX cp -r /data/misc/wifi/p2p_supplicant.conf $SAVE_LOG_PATH
	echo "$BUSYBOX cp -r /data/misc/wifi/p2p_supplicant.conf $SAVE_LOG_PATH"
############################################################################################
	# mv /data/anr to data/media
	busybox ls -R -l /data/anr > $SAVE_LOG_PATH/ls_data_anr.txt
	mkdir $SAVE_LOG_PATH/anr
	busybox mv /data/anr/* $SAVE_LOG_PATH/anr/
	echo "busybox mv /data/anr $SAVE_LOG_PATH"
############################################################################################
	# copy asusdbg(reset debug message) to /data/media
#	$BUSYBOX mkdir -p $SAVE_LOG_PATH/resetdbg
#	dd if=/dev/block/platform/msm_sdcc.1/by-name/ramdump of=$SAVE_LOG_PATH/resetdbg/kernelmessage.txt count=512
#	echo "copy asusdbg(reset debug message) to $SAVE_LOG_PATH/resetdbg"
############################################################################################
#is_ramdump_exist=`busybox cat /proc/cmdline | busybox grep RAMDUMP`
#if busybox test "$is_ramdump_exist"; then
#	dd if=/dev/block/platform/msm_sdcc.1/by-name/ramdump of=$SAVE_LOG_PATH/IMEM_C.BIN count=8 skip=512
#	dd if=/dev/block/platform/msm_sdcc.1/by-name/ramdump of=$SAVE_LOG_PATH/EBICS0.BIN count=2097152 skip=2048
#	echo "copy RAMDUMP.bin to $SAVE_LOG_PATH"
#fi	
############################################################################################
	# mv /data/media/ap_ramdump  to data/media
	busybox ls -R -l /data/media/ap_ramdump > $SAVE_LOG_PATH/ls_data_media_ap_ramdump.txt
	mkdir $SAVE_LOG_PATH/ap_ramdump
	busybox mv /data/media/ap_ramdump/* $SAVE_LOG_PATH/ap_ramdump/
	echo "busybox mv /data/media/ap_ramdump $SAVE_LOG_PATH"
############################################################################################
	# save system information
	dumpsys SurfaceFlinger > $SAVE_LOG_PATH/surfaceflinger.dump.txt
	echo "dumpsys SurfaceFlinger > $SAVE_LOG_PATH/surfaceflinger.dump.txt"
	dumpsys window > $SAVE_LOG_PATH/window.dump.txt
	echo "dumpsys window > $SAVE_LOG_PATH/window.dump.txt"
	dumpsys activity > $SAVE_LOG_PATH/activity.dump.txt
	echo "dumpsys activity > $SAVE_LOG_PATH/activity.dump.txt"
	dumpsys power > $SAVE_LOG_PATH/power.dump.txt
	echo "dumpsys power > $SAVE_LOG_PATH/power.dump.txt"
	dumpsys input_method > $SAVE_LOG_PATH/input_method.dump.txt
	echo "dumpsys input_method > $SAVE_LOG_PATH/input_method.dump.txt"
	date > $SAVE_LOG_PATH/date.txt
	echo "date > $SAVE_LOG_PATH/date.txt"
############################################################################################	
	# save debug report
	dumpsys > $SAVE_LOG_PATH/bugreport.txt
	echo "dumpsys > $SAVE_LOG_PATH/bugreport.txt"
############################################################################################
	busybox mv /data/media/diag_logs/QXDM_logs $SAVE_LOG_PATH 
	echo "busybox mv /data/media/diag_logs/QXDM_logs $SAVE_LOG_PATH"
############################################################################################
	date > $SAVE_LOG_PATH/microp_dump.txt
	 busybox cat /d/gpio >> $SAVE_LOG_PATH/microp_dump.txt                   
        echo "cat /d/gpio > $SAVE_LOG_PATH/microp_dump.txt"  
        busybox cat /d/microp >> $SAVE_LOG_PATH/microp_dump.txt
        echo "cat /d/microp > $SAVE_LOG_PATH/microp_dump.txt"
############################################################################################
	# sync data to disk 
	# 1015 sdcard_rw
	chmod -R 777 $SAVE_LOG_PATH
	sync
am broadcast -a android.intent.action.MEDIA_MOUNTED --ez read-only false -d file:///storage/sdcard0/
