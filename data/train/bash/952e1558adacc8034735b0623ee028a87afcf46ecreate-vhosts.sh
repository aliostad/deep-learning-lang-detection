#! /bin/sh

set -e

/usr/share/gforge/bin/prepare-vhosts-file.pl

case "$1" in
	--norestart)
		exit 0
		;;
	*)
		test -f /etc/default/apache2 && . /etc/default/apache2
		if [ "$NO_START" != "0" ]; then
			if [ -x /usr/sbin/apache ]; then
    				/usr/sbin/invoke-rc.d --quiet apache reload
			fi
		else
			if [ -x /usr/sbin/apache2 ]; then
    				/usr/sbin/invoke-rc.d --quiet apache2 reload
			fi
		fi
		if [ -x /usr/sbin/apache-ssl ]; then
    			/usr/sbin/invoke-rc.d --quiet apache-ssl reload
		fi
		if [ -x /usr/sbin/apache-perl ]; then
    			/usr/sbin/invoke-rc.d --quiet apache-perl reload
		fi
		;;
esac
