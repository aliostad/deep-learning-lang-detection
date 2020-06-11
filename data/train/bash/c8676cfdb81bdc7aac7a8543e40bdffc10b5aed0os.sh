#!/bin/bash

function load-linux-gnu {
	echo "Loading for linux"
	ARCH=$(uname -m | sed 's/x86_//;s/i[3-6]86/32/')

	if [ -f /etc/lsb-release ]; then
		. /etc/lsb-release
		OS=$DISTRIB_ID
		VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
		OS=Debian
		VER=$(cat /etc/debian_version)
		load-deb
	elif [ -f /etc/redhat-release ]; then
		OS=RH_Cent
		VER=$(cat /etc/redhat-release)
		load-rhel
	else
		OS=$(uname -s)
		VER=$(uname -r)
		echo "Undetected Linux flavor: $OS $VER"
	fi
}

function run {

case "${OSTYPE}" in
	"linux-gnu")
		load-linux-gnu
		;;
	"darwin"*)
		load-darwin
		;;
	"cygwin"*)
		load-cygwin
		;;
	"free-bsd"*)
		load-free-bsd
		;;
	*)
		echo "Unknown OS: '${OSTYPE}'"
		;;
esac
}
