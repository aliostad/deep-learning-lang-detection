#!/bin/bash -
#===============================================================================
#
#          FILE: change.slot.sh
#
#         USAGE: ./change.slot.sh
#
#   DESCRIPTION:
#
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: ORiON
#  ORGANIZATION:
#       CREATED: 04/03/2015 11:38
#      REVISION: 1.0
#===============================================================================

SETTINGS_PATH=/home/steam/.klei/DoNotStarveTogether/settings.ini

echo "Enter save slot"
read saveSlot

if [ ! -z $saveSlot ]
then
	sed -i "s/\(server_save_slot = \).*/\1${saveSlot}/" "$SETTINGS_PATH"
	echo "Save slot updated."
fi

