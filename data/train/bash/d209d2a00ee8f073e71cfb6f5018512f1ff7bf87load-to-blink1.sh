#!/bin/bash
# Automatically change a Blink(1)'s color based on system load

# Using which for convenience at the moment
# blink1-tool needs to be in your PATH
BLINK1_TOOL=`which blink1-tool`

# How long to sleep between polling
# If this is too low and the system is borderline it would swap
# back and forth. Also, since we are watching the load, there is
# no point in contributing more to it than necessary ;^)
SLEEP=5

# thresholds in percentage
THRESHOLD_MEM=25
THRESHOLD_LOAD=15

# total available memory and physical cores
TOTAL_MEM=$(free | grep Mem | awk '{print $2}')
TOTAL_CORE=$(grep 'model name' /proc/cpuinfo | wc -l)

# Calculate a value between 0-255 based on the arg1/arg2
get_value()
{
    RESULT=`echo ${1} ${2} | awk '{print int((255 * ($1)/$2))}'`
    echo $RESULT
}

invert_value()
{
    RESULT=`echo ${1} | awk '{print int(255-($1))}'`
}

# return a value between 0-255 to represent used memory
memory()
{
    free_mem=$(free | grep buffers/cach | awk '{print $3}')
    echo $(get_value $free_mem $TOTAL_MEM)
}

# return a value between 0-255 to represent used memory
load()
{
    cur_load=$(uptime | awk '{ print $10 }' | cut -c1-4)
    echo $(get_value $cur_load $TOTAL_CORE)
}

##signal trapping
cleanup()
{
    # Turn the Blink(1) off
    $TOOL --off > /dev/null 2>&1
    exit $?
}
# trap keyboard interrupt (CTRL-c) or a SIGTERM (kill)
trap cleanup SIGINT SIGTERM


echo "Monitoring load with threasholds: memory>${THRESHOLD_MEM} (led 1) and load>${THRESHOLD_LOAD} (led 2)"
echo "CTRL-C to exit."

#infinite loop, stop with CTRL-c
while true; do
    cur_mem=$(memory)
    cur_load=$(load)

    change_mem=$(echo "$cur_mem > $THRESHOLD_MEM*2.55" | bc)
    #echo "mem =$cur_mem change=$change_mem"
    change_load=$(echo "$cur_load > $THRESHOLD_LOAD*2.55" | bc)
    #echo "load=$cur_load change=$change_load"

    if [ "$change_mem" != "0" ]; then
        $BLINK1_TOOL --hsb  255,255,$cur_mem --led 1 > /dev/null 2>&1
    fi
    if [ "$change_load" != "0" ]; then
        $BLINK1_TOOL --hsb  255,255,$cur_load --led 2 > /dev/null 2>&1
    fi
sleep $SLEEP
done
