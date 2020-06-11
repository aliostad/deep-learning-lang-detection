#!/bin/bash

abort() {
    echo "$*"
    exit 1
}

iptables_save_file() {
    echo "/tmp/iptables.$1.dump"
}

save_iptables() {
    save_file=$(iptables_save_file "$1")
    [ -f ${save_file} ] && abort "iptables dump file ${save_file} already exists; bailing out."
    iptables -L > /dev/null  # if iptables / netfilter hasn't been touched since boot, iptables-save output will be
                             # an empty string, which iptables-restore will ignore.
    iptables-save > ${save_file}
    [ $? -ne 0 ] && abort "Failed to save iptables rules to $save_file; bailing out."
}

restore_iptables() {
    save_file=$(iptables_save_file "$1")
    iptables-restore < ${save_file}
    if [ $? -ne 0 ]; then
        echo "Failed to restore iptables rules saved when starting from $save_file, flushing iptables."
        iptables -F
    fi
    rm -f ${save_file}
}

mess_with_outgoing_traffic() {
    rule=$1; shift
    for dst in $*; do
        iptables -A OUTPUT --destination $dst -j $rule
    done
}

drop_traffic_to() {
    mess_with_outgoing_traffic DROP $*
}