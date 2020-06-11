#! /bin/bash

#latency
gnuplot -p ./scripts/latency.p


#throughput
./throughput_process.py < ./single_server_100ms_delay.txt > /tmp/single_server_100ms_delay_throughput.txt
./throughput_process.py < ./load_balancer_100ms_delay.txt > /tmp/load_balancer_100ms_delay_throughput.txt
./throughput_process.py < ./load_balancer_55ms_delay.txt  > /tmp/load_balancer_55ms_delay_throughput.txt


gnuplot -p -e "file1='/tmp/single_server_100ms_delay_throughput.txt';file2='/tmp/load_balancer_100ms_delay_throughput.txt';file3='/tmp/load_balancer_55ms_delay_throughput.txt'" ./scripts/throughput.p 
