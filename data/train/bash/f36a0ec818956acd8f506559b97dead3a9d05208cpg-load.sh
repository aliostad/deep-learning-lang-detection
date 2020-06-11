#!/bin/bash
#
# Author: Jan Friesse <jfriesse@redhat.com>
#

# cpg_load_prepare nodes
cpg_load_prepare() {
    local nodes="$1"
    local node

    for node in $nodes;do
        compile_app "$node" "cpg-load" "-lcpg" || return $?
    done

    return 0
}

# cpg_load_start nodes [no_messages_in_burst]
cpg_load_start() {
    local nodes="$1"
    local msgs="$2"
    local node

    if [ "$msgs" == "" ];then
        msgs=5000
    fi

    for node in $nodes;do
        run_app "$node" "cpg-load -n $msgs" > "$test_var_dir/cpg-load-$node.log" &
        echo $! > "$test_var_dir/cpg-load-$node.pid"
    done

    return 0
}

# cpg_load_verify nodes
cpg_load_verify() {
    local nodes="$1"
    local node
    local err=0

    for node in $nodes;do
        if grep "^[0-9T]*:Error:" "$test_var_dir/cpg-load-$node.log";then
            return 1
        fi
    done

    return 0
}


# cpg_load_stop
cpg_load_stop() {
    local nodes="$1"
    local node

    for node in $nodes;do
        if [ -f "$test_var_dir/cpg-load-$node.pid" ];then
            pkill -P "`cat \"$test_var_dir/cpg-load-$node.pid\"`" || true
            wait "`cat \"$test_var_dir/cpg-load-$node.pid\"`" || true
            rm "$test_var_dir/cpg-load-$node.pid" || true
        fi
    done

    return 0
}

# cpg_load_one_shot node [max_msgs] [no_messages_in_burst]
# Run cpg-load on one node on foreground, sending/receiving max_msgs and checking error code
cpg_load_one_shot() {
    local node="$1"
    local max_msgs="$2"
    local burst="$3"

    if [ "$max_msgs" == "" ];then
        max_msgs=5000
    fi

    if [ "$burst" == "" ];then
        burst=100
    fi

    run_app "$node" "cpg-load -n $burst -m $max_msgs -q"
}
