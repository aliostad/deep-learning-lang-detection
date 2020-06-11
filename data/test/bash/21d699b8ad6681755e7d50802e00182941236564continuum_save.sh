#!/bin/sh

CURRENT_DIR="$(cd "$(dirname "${0}")" && pwd)"

. "${CURRENT_DIR}/vars.sh"
. "${CURRENT_DIR}/helpers.sh"

interval_option_minutes="$(_get_tmux_option_global_helper "${continuum_save_interval_option}" "${continuum_save_interval_default}")"
interval_option_seconds="$(($interval_option_minutes * 60))"
last_interval_seconds="$(_get_tmux_option_global_helper "${last_auto_save_option}" "0")"
next_interval_seconds="$(($interval_option_seconds + $last_interval_seconds))"

if [ "${interval_option_seconds}" -gt "0" ] && [ "$(date "+%s")" -ge "${next_interval_seconds}" ]; then
    resurrect_save_script_path="$(_get_tmux_option_global_helper "${resurrect_save_path_option}")"
    if [ -n "${resurrect_save_script_path}" ]; then
        "${resurrect_save_script_path}" "quiet" >/dev/null 2>&1 &
        #set current timestamp
        tmux set-environment -g "${last_auto_save_option}" "$(date "+%s")" > /dev/null
    fi
fi

# vim: set ts=8 sw=4 tw=0 ft=sh :
