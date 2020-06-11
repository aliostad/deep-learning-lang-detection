#/usr/bin/bash
#do_test.sh <name> <gateways> <chunk_size> <ngs> <duration> <seed> 
name=$1
gws=$2
chunk_size=$3
ngs=$4
penalty=$5
gateway_mbs=$6
[ -f $name.txt ] && rm $name.txt
set -x
./test terse gateways $gws chunk_size $chunk_size ngs $ngs penalty $penalty gateway_mbs $gateway_mbs mbs 1200 seed 5791 duration 50 outprefix $name."rep" rep | tee $name.rep.txt
./test terse gateways $gws chunk_size $chunk_size ngs $ngs penalty $penalty gateway_mbs $gateway_mbs mbs 1200 seed 5791 duration 50 outprefix $name."repnocc" rep congestion_penalty 0 | tee $name.rep.txt
./test terse gateways $gws chunk_size $chunk_size ngs $ngs penalty $penalty gateway_mbs $gateway_mbs mbs 1200 seed 5791 duration 50 outprefix $name."chucast" chucast | tee $name.chucast.txt
./test terse gateways $gws chunk_size $chunk_size ngs $ngs penalty $penalty gateway_mbs $gateway_mbs mbs 1200 seed 5791 duration 50 outprefix $name."omhtcp" omhucast | tee $name.omhtcp.txt
./test terse gateways $gws chunk_size $chunk_size ngs $ngs penalty $penalty gateway_mbs $gateway_mbs mbs 1200 seed 5791 duration 50 outprefix $name."omhudp" omhmcast | tee $name.omhudp.txt

[ -f $name.tgz ] && rm $name.tgz
tar zcf $name.tgz $name.* $name.*.csv
