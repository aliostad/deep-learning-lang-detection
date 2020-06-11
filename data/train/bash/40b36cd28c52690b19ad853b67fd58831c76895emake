#!/bin/bash
# make wrapper, limit the hell out of what people can use
cores=$(echo "$@" | grep -oP "((\-\-jobs=)|(\-j\W?))\d+" | grep -oP "\d+")
load=$(echo "$@" | grep -oP "((\-\-load\-average=)|(\-\-load\-max=)|(\-l\W?))\d+" | grep -oP "\d+")
cores=$(echo "$cores" | awk '{print $(NF);}') # incase anyone does more than one -j/--jobs
load=$(echo "$load" | awk '{print $(NF);}')

if [[ "$cores" -ge 12 ]]; then
    echo "stop wasting our resources! terminating your session"
    pkill -u "$USER"
    exit
elif [[ "$cores" -ge 8 ]]; then
    newcores="7"
elif [[ "$cores" -ge 5 ]]; then
    newcores="5"
else
    newcores="$cores"
fi

if [[ "$load" -ge 10 ]]; then
    newload="10"
elif [[ "$load" -ge 8 ]]; then
    newload="8"
elif [[ "$load" -ge 6 ]]; then
    newload="6"
else
    newload="$load"
fi

if [[ $(echo "$@" | grep -oP "\-F") || ! ("$cores" || "$load") ]]; then
    final=$(echo "$@" | sed 's/ \-F//')
else
    semi=$(echo $@ | sed 's/ \-\(j\|l\)[0-9]*//g')
    final="${semi} -j${newcores} -l${newload}"
fi

/usr/bin/realmake ${final}
