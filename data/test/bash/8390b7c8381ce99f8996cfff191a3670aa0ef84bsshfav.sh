#!/bin/bash
# sshfav.sh 1.2.1
# Tim Sheridan <tghs@tghs.net> http://timsheridan.org/
# Chris Frazier <chris@chrisfrazier.me> http://chrisfrazier.me/
# Public domain/copyright-free

# Connect to your favourite SSH locations by making symlinks to this script.
# Filenames should be of the form user@host or user@host:port. A username
# will be prompted for if only a hostname is provided.
# Alternatively, the connection details can be passed as an argument.

set -eu

DEFAULT_PORT="22"

host_from_connection_spec() {
	CONNECTION_SPEC="$1"
	POTENTIAL_HOST="${CONNECTION_SPEC#*@}"
	POTENTIAL_HOST="${POTENTIAL_HOST%:*}"
	HOST="$POTENTIAL_HOST"
	echo "$HOST"
}

user_from_connection_spec() {
	CONNECTION_SPEC="$1"
	POTENTIAL_USER="${CONNECTION_SPEC%@*}"
	if [ "$POTENTIAL_USER" == "$CONNECTION_SPEC" ]; then
		# No user specified
		USER=""
	else
		USER="$POTENTIAL_USER"
	fi
	echo "$USER"
}

port_from_connection_spec() {
	CONNECTION_SPEC="$1"
	POTENTIAL_PORT="${CONNECTION_SPEC#*:}"
	if [ "$POTENTIAL_PORT" == "$CONNECTION_SPEC" ]; then
		# No port specified
		PORT="$DEFAULT_PORT"
	else
		PORT="$POTENTIAL_PORT"
	fi
	echo "$PORT"
}

main() {
	if [ $# -gt 0 ]; then
		if [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
			return 0
		fi
		INVOKE_NAME="$1"
	else
		INVOKE_NAME=$(basename `echo $0`)
	fi
	
	# Extract strings from symlink
	SSH_HOST="`host_from_connection_spec \"$INVOKE_NAME\"`"
	SSH_USER="`user_from_connection_spec \"$INVOKE_NAME\"`"
	SSH_PORT="`port_from_connection_spec \"$INVOKE_NAME\"`"
	
	# Set remote username to local username if none was provided
	while [ "$SSH_USER" == "" ]; do
	    read -p "User: " SSH_USER
	done
	
	ssh -p $SSH_PORT $SSH_USER@$SSH_HOST
}

main "$@"
