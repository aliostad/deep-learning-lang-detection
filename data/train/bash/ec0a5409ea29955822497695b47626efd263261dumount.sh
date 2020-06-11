#!/bin/sh

. "$1/scriptenv.sh"

# which unmounts are necessary and which will be done implicitly when unmounting NEWROOT ? (esp. binds, proc etc.)

NEWROOT="$1"

invoke umount $NEWROOT/dev/pts
invoke umount $NEWROOT/proc
invoke umount $NEWROOT/sys
invoke umount $NEWROOT/sdcard
invoke umount $NEWROOT/tmp

#invoke umount $NEWROOT/root/cfg

#
# fixme: do not mount both to the same location! mount to /mnt or /media?
#
if [ -d /sdcard/external_sd ]; then
	invoke umount $NEWROOT/external_sd
fi
if [ -d /Removable/MicroSD ]; then
	invoke umount $NEWROOT/external_sd
fi
# This is for the HD version of the Archos 70 internet tablet, may be the same for the SD card edition but i dont know.
if [ -d /storage ]; then
	invoke umount $NEWROOT/external_sd
fi
