#!/bin/sh
# FIXME: currently, it automatically generates plots for a single VM

clean=0
if [ $# -eq 1 -a "$1" == "-c" ]; then
        clean=1
fi

systemtap/vdi_load.stp > /dev/shm/load_sample.dump
mv /dev/shm/load_sample.dump .
./load_profile.py load_sample.dump
recent_output=`ls -t | head -1`
vm_id=`echo $recent_output | perl -e '$f = <>; print "$1\n" if $f =~ /vm(\d+)/;'`
max_prof_id=`echo $recent_output | perl -e '$f = <>; print "$1\n" if $f =~ /id(\d+)/;'`
for prof_id in `seq 1 $max_prof_id`; do
        ./mkplt_load_profile.sh $vm_id $prof_id
done

if [ $clean -eq 1 ]; then
        rm -f load-vm*.dat load-vm*.plt event-vm*.dat
fi
