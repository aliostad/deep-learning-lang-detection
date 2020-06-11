#!/bin/sh

# ---------------------
# Server Load Check
# ---------------------

L05="$(uptime|awk '{print $(NF-2)}'|cut -d. -f1)"
#echo test $L05;

# if server load is greater than 20.00
if test $L05 -gt 20

then

# -----------------
# Do something here
# -----------------

# Restart Apache

/sbin/service httpd stop
killall -9 httpd
ipcs -s | grep apache | perl -e 'while (<STDIN>) { @a=split(/\s+/); print `ipcrm sem $a[1]`}'
/sbin/service httpd start

echo "server load too high";

else

echo "server load load ok";

fi

