# ~/.local/bashrc.x/etc/bashrc.d/90-prompt-load.sh
#
# This file is part of bashrc.x.
#
# bashrc.x is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# bashrc.x is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with bashrc.x.  If not, see <http://www.gnu.org/licenses/>.
#
# @package   bashrc.x
# @author    Snakevil Zen <zsnakevil@gmail.com>
# @copyright © 2012 szen.in
# @license   http://www.gnu.org/licenses/gpl.html

_bashrc.x-which 'awk' 'date' 'uname' 'uptime' && {
  [ -n "${BASHRCX_COLORS['load']}" ] || {
    BASHRCX_COLORS['load']="$Chgreen"
    BASHRCX_COLORS['load.2']="$Chyellow"
    BASHRCX_COLORS['load.3']="$Chred"
  }

  BASHRCX_VARS['load']='0.00'
  BASHRCX_VARS['load.time']=0
  BASHRCX_VARS['load.cores']=`[ 'sDarwin' = "s$('uname' -s)" ] \
      && 'sysctl' -n 'machdep.cpu.core_count' \
      || 'awk' '"processor"==$1{n++}END{print n}' /proc/cpuinfo`
  BASHRCX_VARS['load.level']=1

  function _bashrc.x-prompt-2.10-load {
    _pret=(2 "")
    [ -n "${BASHRCX_OPTS['prompt.load']}" ] || return
    local t1=`'date' +'%s'` t2
    let t2=${BASHRCX_VARS['load.time']}+${BASHRCX_OPTS['prompt.load.interval']}
    [ $t1 -lt $t2 ] || {
      BASHRCX_VARS['load']=`'uptime' \
        | 'awk' -F'load average' '{print $2}' \
        | 'awk' '{split($2,x,",");print x[1]}'`
      BASHRCX_VARS['load.time']=$t1
      BASHRCX_VARS['load.level']=`echo "${BASHRCX_VARS['load']} ${BASHRCX_VARS['load.cores']}" \
        | 'awk' '{i=$1/$2;if(0.1>i)j=1;else if(1>i)j=2;else j=3;print j}'`
    }
    _pret[1]="\\[${BASHRCX_COLORS['default']}\\]l"
    case "${BASHRCX_VARS['load.level']}" in
      1 )
        _pret[1]="${_pret[1]}\\[${BASHRCX_COLORS['load']}\\]"
        ;;
      2 )
        _pret[1]="${_pret[1]}\\[${BASHRCX_COLORS['load.2']}\\]"
        ;;
      * )
        _pret[1]="${_pret[1]}\\[${BASHRCX_COLORS['load.3']}\\]"
        ;;
    esac
    _pret[1]="${_pret[1]}${BASHRCX_VARS['load']}"
    [ -n "${BASHRCX_OPTS['prompt.load.cores']}" ] || return
    [ -z "${BASHRCX_VARS['load.cores']}" -o 2 -gt "${BASHRCX_VARS['load.cores']}" ] || {
      _pret[1]="${_pret[1]}\\[${BASHRCX_COLORS['default']}\\]"
      _pret[1]="${_pret[1]}@${BASHRCX_VARS['load.cores']}"
    }
  }
}

# vim: se ft=sh ff=unix fenc=utf-8 sw=2 ts=2 sts=2:
