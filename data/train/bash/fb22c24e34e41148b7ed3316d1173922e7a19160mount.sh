#!/bin/sh

. "$1/scriptenv.sh"

invoke mount -t devpts devpts $NEWROOT/dev/pts
invoke mount -t proc proc $NEWROOT/proc
invoke mount -t sysfs sysfs $NEWROOT/sys
invoke mount -o bind /sdcard $NEWROOT/sdcard
invoke mount -t tmpfs tmpfs $NEWROOT/tmp # ??

#if [[ ! -d $NEWROOT/root/cfg ]]; then mkdir $NEWROOT/root/cfg; fi
#invoke mount -o bind $(dirname $ROOTIMAGE) $NEWROOT/root/cfg

#
# fixme: do not mount both to the same location! mount to /mnt or /media?
#
if [ -d /sdcard/external_sd ]; then
	invoke mount -o bind /sdcard/external_sd  $NEWROOT/external_sd
fi
if [ -d /Removable/MicroSD ]; then
	invoke mount -o bind /Removable/MicroSD  $NEWROOT/external_sd
fi
# This is for the HD version of the Archos 70 internet tablet, may be the same for the SD card edition but i dont know.
if [ -d /storage ]; then
	invoke mount -o bind /storage  $NEWROOT/external_sd
fi
