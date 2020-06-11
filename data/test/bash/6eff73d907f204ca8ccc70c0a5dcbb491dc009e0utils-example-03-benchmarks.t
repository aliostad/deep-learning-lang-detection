#! /bin/bash

. ./bash-test-utils

ok 0 "foo bar benchmarks"

sleeptime=$(/usr/bin/time -f %e sleep 3)
bogomips=$(echo $(cat /proc/cpuinfo | grep -i bogomips | head -1 | cut -d: -f2))

# simple yaml here, indent level2 by yourself:
append_tapdata "benchmarks:"
append_tapdata "  bogomips: ${bogomips:-0.0}"
append_tapdata "  sleeptime: $sleeptime"
append_tapdata "  settings_1:"
append_tapdata "    used_options: -foo -bar affe/zomtec.dat"
append_tapdata "    foo: 12.34"
append_tapdata "    bar: 9.75"
append_tapdata "  settings_2:"
append_tapdata "    used_options: -foo -bar affe/tiger.dat"
append_tapdata "    foo: 10.34"
append_tapdata "    bar: 7.75"

done_testing

# vim: set ts=4 sw=4 tw=0 ft=sh:
