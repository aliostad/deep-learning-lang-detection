#!/bin/sh
#
# Startup script for program
#
# chkconfig: 345 85 15     - start or stop process definition within the boot process
# description: Description of program
# processname: process-name
# pidfile: /var/run/process-name.pid

# Source function library.      This creates the operating environment for the process to be started
. /etc/rc.d/init.d/functions

case "$1" in
  start)
        echo -n "Starting  process-name: "
        daemon  process-name                 - Starts only one process of a given name.
        echo
        touch /var/lock/subsys/process-name
        ;;
  stop)
        echo -n "Shutting down process-name: "
        killproc process-name
        echo
        rm -f /var/lock/subsys/process-name
        rm -f /var/run/process-name.pid      - Only if process generates this file
        ;;
  status)
        status process-name
        ;;
  restart)
        $0 stop
        $0 start
        ;;
  reload)
        echo -n "Reloading process-name: "
        killproc process-name -HUP
        echo
        ;;
  *)
        echo "Usage: $0 {start|stop|restart|reload|status}"
        exit 1
esac

exit 0


# vim:ft=sh:

