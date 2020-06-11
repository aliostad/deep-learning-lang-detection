#! /bin/bash

#  #  #  #  # 
# 
# Use it to backup a full system (/*) for later easy restore.
#
# Script source: https://wiki.archlinux.org/index.php/Full_System_Backup_with_rsync
# For detailed explanation about used arguments, see the man and the link above ;)
#
#  #  #  #  # 

this_name="$(basename "$0")"

echoerr() 
{
    echo "$@" 1>&2
}

usage ()
{
    echoerr
    echoerr "USAGE:"
    echoerr " "$this_name" <destination>"
    exit 2
}


if (( $EUID != 0 )); then
   echoerr ""$this_name": must be run as root"
   exit 1
fi

if (( $# < 1 )); then 
    echoerr ""$this_name": no destination defined"
    usage
elif (( $# > 1 )); then
    echo ""$this_name": too many arguments"
    usage
fi

invoke-rc.d deluge-web stop
invoke-rc.d deluge-daemon stop

START="$(date +%s)"

rsync -aAXvh /* "$1" --exclude={/dev/*,/proc/*,/sys/*,/tmp/*,/run/*,/mnt/*,/media/*,/lost+found}
if (( $? )); then
    exit "$?"
fi

FINISH="$(date +%s)"
echo "total time: $(( ($FINISH-$START) / 60 )) minutes, $(( ($FINISH-$START) % 60 )) seconds"

invoke-rc.d deluge-daemon start
invoke-rc.d deluge-web start

echo "Backup performed on $(date '+%A, %d %B %Y, %T')"
exit 0
