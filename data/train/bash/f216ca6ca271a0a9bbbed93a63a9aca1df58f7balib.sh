#!/usr/bin/env bash

# Checks if the specified process is running or not.
running() {
    rpid "${1}" > /dev/null
}

# Wrapper around of 'pgrep'.
rpid() {
    pgrep -f "${1}" 2> /dev/null
}

# Calls specified process with assigned name.
start() {
    process=${1}; shift
    name=${1};    shift
    if ! running "${process}"; then
	"${@}"
    else
	echo "${name} already running."
    fi
}

# Stops specified process.
stop() {
    process=${1}; shift
    name=${1};    shift
    if running "${process}"; then
	"${@}"
    else
	echo "${name} not running."
    fi
}

# Shows status of the specified process.
status() {
    process=${1}; shift
    name=${1};    shift
    if running "${process}"; then
	echo "${name} running."
    else
	echo "${name} not running."
    fi
}
