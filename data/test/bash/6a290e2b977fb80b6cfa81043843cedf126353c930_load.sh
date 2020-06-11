#!/bin/bash
#
# Copyright 2014 Thomas Schoebel-Theuer
# Programmed in my spare time on my private notebook.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

const_load_dd_cmd_mounted="${const_load_dd_cmd_mounted:-yes abc \| dd \$conf_load_dd_flags bs=4096 count=\$conf_load_dd_count of=/mnt/test/\$lv/testfile.\\\\\$\\\\\$}"
const_load_dd_cmd_raw="${const_load_dd_cmd_raw:-yes abc \| dd \$conf_load_dd_flags bs=4096 count=\$conf_load_dd_count of=/dev/mars/\$lv}"

conf_load_dd_count="${conf_load_dd_count:-1024}"
conf_load_dd_flags="${conf_load_dd_flags:-oflag=direct}"

check_install_list="$check_install_list dd killall"

declare -A state_load
state_load_start_count=0

function _LOAD_force_stop
{
    local host_list="${1:-$const_host_list}"

    remote_reset
    remote_add "$host_list" "while killall -r MARS-load; do sleep 1; done"
    remote_add "$host_list" "while killall dd; do sleep 1; done"
    remote_wait
    declare -A -g state_load
    local i
    for i in $host_list; do
	state_load[$i]=0
    done
}

function LOAD_force_stop
{
    _LOAD_force_stop
}

function _LOAD_stop
{
    local host_list="${1:-$const_host_list}"

    remote_wait
    _LOAD_force_stop "$host_list"
}

function _LOAD_start
{
    local in_host_list="$1"
    local do_repeat="${2:-0}"
    local lv_list="${3:-$(_get_lv_list)}"
    local cmd="${4:-}"

    local cmd_mounted="${cmd:-$const_load_dd_cmd_mounted}"
    local cmd_raw="${cmd:-$const_load_dd_cmd_raw}"

    declare -A -g state_load
    declare -A -g state_fs_mounted
    local host_list_mounted=""
    local host_list_raw=""
    local host
    for host in $in_host_list; do
	(( state_load[$host] )) && continue
	if (( state_fs_mounted[$host] )); then
	    host_list_mounted+=" $host"
	else
	    host_list_raw+=" $host"
	fi
    done
    [[ "$host_list_mounted$host_list_raw" = "" ]] && return 0

    for host in $host_list_mounted $host_list_raw; do
	local -a args
	local i=0
	local lv
	for lv in $lv_list; do
	    local cmd
	    if (( state_fs_mounted[$host] )); then
		cmd="$cmd_mounted"
	    else
		cmd="$cmd_raw"
	    fi
	    (( verbose > 99 )) && echo "host=$host lv=$lv cmd='$cmd'"
	    local subst_cmd="$(eval echo "$cmd")"
	    (( verbose > 99 )) && echo "host=$host lv=$lv subst_cmd='$subst_cmd'"
	    if (( do_repeat )); then
		# We need a quadratic backoff, otherwise the network bottleneck tests could not work by construction
		args[$(( i++ ))]="sleeptime=0"
		args[$(( i++ ))]="sleepinc=1"
		args[$(( i++ ))]="while true; do"
		args[$(( i++ ))]="  $subst_cmd"
		args[$(( i++ ))]="  sleep \\\$sleeptime"
		args[$(( i++ ))]="  (( sleeptime += sleepinc ))"
		args[$(( i++ ))]="  (( sleepinc++ ))"
		args[$(( i++ ))]="done &"
	    else
		args[$(( i++ ))]="$subst_cmd"
	    fi
	done
	remote_script_add "$host" "$do_repeat" "load" "${args[@]}"
    done
    remote_wait
    # wait until some logfile data has been produced
    for lv in $lv_list; do
	remote_add "$host_list_mounted $host_list_raw" "$marsadm view-replay-pos $lv || exit \$?"
	remote_wait "false" 1
    done
    for host in $host_list_mounted $host_list_raw; do
	state_load[$host]=1
    done
    (( state_load_start_count++ == 0 )) && hooks_testcase_finalize+=" LOAD_force_stop"
}

function LOAD_start
{
    local host_list="${1:-$state_primary}"

    (( conf_load_dd_count <= 0 )) && return 0
    declare -A -g state_load
    local host
    local need=0
    for host in $host_list; do
	(( state_load[$host] )) && continue
	(( need++ ))
    done
    (( need <= 0 )) && return 0
    (( verbose )) && echo "++++++++++++++++++ starting load at $host_list"
    _LOAD_start "$host_list" 1
}

function LOAD_stop
{
    _LOAD_stop "$state_primary"
}

function LOAD
{
    (( conf_load_dd_count <= 0 )) && return 0
    # synchronously: don't start in background, don't loop
    _LOAD_start "$state_primary" 0
    remote_wait
    declare -A -g state_load
    state_load[$state_primary]=0
}
