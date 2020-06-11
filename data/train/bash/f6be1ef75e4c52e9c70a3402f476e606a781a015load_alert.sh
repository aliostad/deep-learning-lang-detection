#!/bin/bash

LOAD_DETAILS="details.txt"
MAIL_BODY="mail_body.txt"
HOST=`hostname`

function show_help {
    echo ""
    echo "Usage:"
    echo "      ./load_alert.sh [-h] -to email -lim limit"
    echo "      Send email when the system load limit is more than the specified limit."
    echo ""
    echo "Arguments:"
    echo "     -h      show this help and exit"
    echo "     -to     email address to send alert message to"
    echo "     -lim    total system disk load limit that will trigger the email sending"
    echo ""
    echo "Example:"
    echo "     ./load_alert.sh -to you@mail.com -lim 90"
    echo "     Sends mail to you@mail.com when the host total disk load is more than 90%" 
    echo ""
    exit
}

function show_error {
    echo "ERROR:" $1
    echo "    Use -h option for help."
    exit
}

# parse cli args
if [ $# -eq 0 ] ; then
   show_help
fi
while [ $# -gt 0 ] ; do
    case $1 in
        -h) show_help ;;
        -to) TO=$2 ; shift 2 ;;
        -lim) LIMIT=$2 ; shift 2 ;;
        *) shift 1 ;;
esac
done

# make sure mandatoru args are supplied
if [ -z $TO ]; then
    show_error "Email address not specified."
fi
if [ -z $LIMIT ]; then
    show_error "Total disk load limit not specified."
fi

df --total > $LOAD_DETAILS
TOTAL_LOAD=`cat $LOAD_DETAILS | awk 'END{print $5}' | cut -d'%' -f1`

if [ $TOTAL_LOAD -gt 90 ]; then 
    echo "Total load for system '`hostname`' is $TOTAL_LOAD%." > $MAIL_BODY
    echo "" >> $MAIL_BODY
    cat $LOAD_DETAILS >> $MAIL_BODY
    ./mailsend.py -s "System Load Alert" -to $TO -b $MAIL_BODY
fi
