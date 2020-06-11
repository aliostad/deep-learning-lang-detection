#!/bin/bash

case "$1" in
	"prefork")
		rm /etc/apache2/mods-enabled/mpm.conf
		rm /etc/apache2/mods-enabled/mpm.load
		cd /etc/apache2/mods-enabled
		ln -s ../mods-available/mpm_$1.conf mpm.conf
		ln -s ../mods-available/mpm_$1.load mpm.load
		;;
	"event")
		rm /etc/apache2/mods-enabled/mpm.conf
		rm /etc/apache2/mods-enabled/mpm.load
		cd /etc/apache2/mods-enabled
		ln -s ../mods-available/mpm_$1.conf mpm.conf
		ln -s ../mods-available/mpm_$1.load mpm.load
		;;
	"worker")
		rm /etc/apache2/mods-enabled/mpm.conf
		rm /etc/apache2/mods-enabled/mpm.load
		cd /etc/apache2/mods-enabled
		ln -s ../mods-available/mpm_$1.conf mpm.conf
		ln -s ../mods-available/mpm_$1.load mpm.load
		;;
	*)
		echo "Usage : $0 [prefork|event|worker]"
		;;
esac