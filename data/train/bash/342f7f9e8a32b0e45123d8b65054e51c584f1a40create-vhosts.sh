#! /bin/sh

set -e

#su -s /bin/sh gforge -c /usr/share/gforge/bin/prepare-vhosts-file.pl
#TODO (remove workaround) make proper db connect config so the previous line works
/usr/share/gforge/bin/prepare-vhosts-file.pl
[ -f /var/lib/gforge/etc/templates/httpd.vhosts ] && \
	/usr/share/gforge/bin/fill-in-the-blanks.pl \
		/var/lib/gforge/etc/templates/httpd.vhosts \
		/var/lib/gforge/etc/httpd.vhosts \
		/etc/fusionforge/fusionforge.conf

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
