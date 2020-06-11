#!/bin/sh
echo [$0] $1 ... > /dev/console
TROOT="/etc/templates"
case "$1" in
start)
	rgdb -A $TROOT/hd_process.php -V generate_start=1 > /var/run/hd_process_start.sh
	rgdb -A $TROOT/hd_process.php -V generate_start=0 > /var/run/hd_process_stop.sh
        sh /var/run/hd_process_start.sh
	;;
restart)
	[ -f /var/run/hd_process_stop.sh ] && sh /var/run/hd_process_stop.sh
	rgdb -A $TROOT/hd_process.php -V generate_start=1 > /var/run/hd_process_start.sh
	sh /var/run/hd_process_start.sh
	rgdb -A $TROOT/hd_process.php -V generate_start=0 > /var/run/hd_process_stop.sh
	echo 1 > /var/test
	;;
restart_without_echo)
	[ -f /var/run/hd_process_stop.sh ] && sh /var/run/hd_process_stop.sh
	rgdb -A $TROOT/hd_process.php -V generate_start=1 > /var/run/hd_process_start.sh
	sh /var/run/hd_process_start.sh
	rgdb -A $TROOT/hd_process.php -V generate_start=0 > /var/run/hd_process_stop.sh
	;;
stop)
	if [ -f /var/run/hd_process_stop.sh ]; then
		sh /var/run/hd_process_stop.sh > /dev/console
		rm -f /var/run/hd_process_stop.sh
	fi
	;;
end_process_for_format)
	rgdb -A $TROOT/hd_process.php -V generate_before_format=1 > /var/run/hd_process_before_format.sh
	sh /var/run/hd_process_before_format.sh
#	rm -f /var/run/hd_process_before_format.sh
	;;
start_process_for_format)
	rgdb -A $TROOT/hd_process.php -V generate_before_format=0 > /var/run/hd_process_after_format.sh
	sh /var/run/hd_process_after_format.sh
#	rm -f /var/run/hd_process_after_format.sh
	;;
*)
	echo "usage: hd_process.sh {start|stop|restart}" > /dev/console
	;;
esac
