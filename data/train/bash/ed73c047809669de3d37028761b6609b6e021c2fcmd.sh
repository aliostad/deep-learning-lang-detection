#!/bin/bash

##
## CONFIGURATION
##
vol=AUTH_test
cnt="trace_replay"

# Single Swift host to setup container
SWIFTHOST=localhost:8080

# Comma separated hosts:
# Example Multiple Hosts:  
# SWIFTHOSTS=host1,host2,host3
# Example Single Host:
# SWIFTHOSTS=host1
SWIFTHOSTS=localhost

# Swift host port
SWIFTHOSTPORT=8080


##
## Test
##
# Encode environmental parameters in the container name:
# Ensure container exists:
curl -sS --connect-timeout 5 --write-out "%{http_code} %{time_total} %{url_effective}\n" \
	-o /dev/null -X PUT http://${SWIFTHOST}/v1/$vol/$cnt | grep -E "^20" || exit 1
echo "OK"
#./swift-load.py 0 PUT 0 localhost 8080 $vol $cnt run0 60
# single test: exit 0

# Issue the runs, 3 PUTs, followed by 3 GETs of what was just PUT
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run0 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run1 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run2 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run0 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run1 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run2 30
# Reboot!
echo "DONE"
exit 0
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run3 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run4 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run5 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run3 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run4 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run5 30
# Reboot!
exit 0
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run6 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run7 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run8 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run6 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run7 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run8 30
# Reboot!
exit 0
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run9 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runA 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runB 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt run9 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runA 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runB 30
# Reboot!
exit 0
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runC 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runD 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runE 30
./swift-load.py 0 PUT 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runF 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runC 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runD 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runE 30
./swift-load.py 0 GET 0 ${SWIFTHOSTS} ${SWIFTHOSTPORT} $vol $cnt runF 30

