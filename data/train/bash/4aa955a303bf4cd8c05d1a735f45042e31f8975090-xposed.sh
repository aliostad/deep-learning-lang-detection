#!/sbin/sh
#
# /system/addon.d/90-xposed.sh
# During an upgrade, if /system/bin/app_process.orig exists, this
# script backs up /system/bin/app_process, /system is formatted
# and reinstalled, the ROM bundled /system/bin/app_process is copied as
# /system/bin/app_process.orig, then /system/bin/app_process is restored
# (as would the Xposed Installer do)

. /tmp/backuptool.functions

APP_PROCESS=bin/app_process

case "$1" in
  backup)
    [ -e "$S/${APP_PROCESS}.orig" ] && backup_file "$S/${APP_PROCESS}"
  ;;
  restore)
    if [ -e "$C/$S/${APP_PROCESS}" ]; then
      echo "Backuping new $S/${APP_PROCESS} as $S/${APP_PROCESS}.orig"
      cp -p "$S/${APP_PROCESS}" "$S/${APP_PROCESS}.orig"
      echo "Restoring Xposed $S/${APP_PROCESS}"
      restore_file "$S/${APP_PROCESS}"
      echo "If your system bootloops, you can either:"
      echo " - Replace $S/${APP_PROCESS} with $S/${APP_PROCESS}.orig"
      echo " - Remove $S/${APP_PROCESS} and reinstall your ROM"
    fi
  ;;
  pre-backup)
    # Stub
  ;;
  post-backup)
    # Stub
  ;;
  pre-restore)
    # Stub
  ;;
  post-restore)
    # Stub
  ;;
esac
