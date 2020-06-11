#!/bin/bash
IS64=`if [ -n "\`uname -m | grep x86_64\`" ];then echo 64; fi`
export LD_LIBRARY_PATH=../misc:/usr/local/cuda/lib$IS64
./sonicawe $1 $2 $3 $4 $5 $6 $7 $8 $9 --get_chunk_count=1
N=$?
SCALES_PER_OCTAVE=`./sonicawe $1 $2 $3 $4 $5 $6 $7 $8 $9 --scales_per_octave | grep scales_per_octave | sed "s/default scales_per_octave=//"`

FRAMES_PATH=frames
mkdir -p $FRAMES_PATH || exit $?
rm -f $FRAMES_PATH/image-*.png

for i in $(seq 0 $N)
do
   echo "========= CHUNK  $i  ============"
   rm sonicawe-1.csv
   time ./sonicawe $1 $2 $3 $4 $5 $6 $7 $8 $9 --extract_chunk=$i
   time octave --eval "plot_producevideo(1,$SCALES_PER_OCTAVE,\"$FRAMES_PATH\");"
done

if [ -f soundtoavi-unversioned.avi ]
then
	mv sondtoavi-unversioned.avi soundtoavi-unversioned.avi~
fi

P=`pwd`
pushd $FRAMES_PATH
$P/encavi.sh
mv unversioned.avi $P/soundtoavi-unversioned.avi
popd

