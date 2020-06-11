#!/bin/bash
##############################################################################
### @author     Knut Kohl <github@knutkohl.de>
### @copyright  2012-2015 Knut Kohl
### @license    MIT License (MIT) http://opensource.org/licenses/MIT
### @version    1.0.0
##############################################################################

##############################################################################
### Init
##############################################################################
pwd=$(dirname $0)

. $pwd/../PVLng.sh

### Script options
opt_help      "Save server load from /proc/loadavg"
opt_help_hint "See dist/loadavg.conf for details."

### PVLng default options with flag for local time and save data
opt_define_pvlng x

source $(opt_build)

read_config "$CONFIG"

##############################################################################
### Functions
##############################################################################
SaveLoadAvg () {
    i=$((i+1))
    [ "$1" ] && sec 1 $i
    [ "$1" -a "$2" ] && PVLngPUT $@
}

##############################################################################
### Start
##############################################################################
[ "$TRACE" ] && set -x

##############################################################################
### Go
##############################################################################
### Get load and set load to $1, $2, $3
### set $4 to number of currently running processes
### set $5 to the total number of processes
set -- $(sed -e 's~/~ ~' /proc/loadavg)

SaveLoadAvg "$LOADAVG_1"  $1
SaveLoadAvg "$LOADAVG_5"  $2
SaveLoadAvg "$LOADAVG_15" $3
SaveLoadAvg "$RUNNIG"     $4
SaveLoadAvg "$PROCESSES"  $5
