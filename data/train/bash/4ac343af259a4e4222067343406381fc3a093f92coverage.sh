#!/bin/bash

# provide the corpus file as the only argument, with the format of one word per line
# usage: sh coverage.sh bn.wiki.corpus

HOME="."

if [ -f $1 ]
then
	echo "initiating coverage test..."
else
	echo "*ERROR: no file provided!"
fi

count=$(cat $1 | grep -c '')
chunk=$(echo $count / 4 | bc)

begcur=0
endcur=$(echo "$begcur + $chunk" | bc)

if [ $endcur -le $count ]
then
	#echo "begcur: $begcur, endcur:$endcur"
	cat $1 | head -$endcur | tail -$chunk > /tmp/chunk
	part1=$(cat /tmp/chunk | lt-proc -a $HOME/bn-en.automorf.bin | grep -c -v "[\*|#|@]")
	echo "part1: $part1/$chunk"
	begcur=`expr $endcur`
	endcur=`expr $begcur + $chunk`
fi

if [ $endcur -le $count ]
then
	#echo "begcur: $begcur, endcur:$endcur"
	cat $1 | head -$endcur | tail -$chunk > /tmp/chunk
	part2=$(cat /tmp/chunk | lt-proc -a $HOME/bn-en.automorf.bin | grep -c -v "[\*|#|@]")
	echo "part2: $part2/$chunk"
	begcur=`expr $endcur`
	endcur=`expr $begcur + $chunk`
fi

if [ $endcur -le $count ]
then
	#echo "begcur: $begcur, endcur:$endcur"
	cat $1 | head -$endcur | tail -$chunk > /tmp/chunk
	part3=$(cat /tmp/chunk | lt-proc -a $HOME/bn-en.automorf.bin | grep -c -v "[\*|#|@]")
	echo "part3: $part3/$chunk"
	begcur=`expr $endcur`
	endcur=`expr $begcur + $chunk`
fi

if [ $endcur -le $count ]
then
	#echo "begcur: $begcur, endcur:$endcur"
	cat $1 | head -$endcur | tail -$chunk > /tmp/chunk
	part4=$(cat /tmp/chunk | lt-proc -a $HOME/bn-en.automorf.bin | grep -c -v "[\*|#|@]")
	echo "part4: $part4/$chunk"
	begcur=`expr $endcur`
	endcur=`expr $begcur + $chunk`
fi

extra=0

if [ $begcur -lt $count ]
then
	newchunk=`expr $count - $begcur`
	#echo "newchunk: $newchunk"
	cat $1 | tail -$newchunk > /tmp/chunk
	extra=$(cat /tmp/chunk | lt-proc -a $HOME/bn-en.automorf.bin | grep -c -v "[\*|#|@]")
	echo "extra: $extra"
fi

total=$(echo "$part1 + $part2 + $part3 + $part4 + $extra" | bc)
echo "total: $total/$count"

mean=$(echo "scale=8;$total/4" | bc)
printf "mean: %.2lf\n" $mean

sdt=0
t=$(echo "scale=8;($part1-$mean)^2" | bc)
sdt=`expr $std + $t`
t=$(echo "scale=8;($part2-$mean)^2" | bc)
sdt=`expr $std + $t`
t=$(echo "scale=8;($part3-$mean)^2" | bc)
sdt=`expr $std + $t`
t=$(echo "scale=8;($part4-$mean)^2" | bc)
sdt=`expr $std + $t`

sdt=$(echo "scale=8;sqrt($sdt/4)" | bc)
printf "sdt: %.2lf\n" $sdt
sdt=$(echo "scale=8;$sdt/$chunk" | bc)
sdt=$(echo "scale=8;$sdt*100" | bc)

cov=$(echo "scale=8;$total/$count" | bc)
cov=$(echo "scale=8;$cov*100" | bc)
printf "coverage: %.2lf%% +/- %.4lf%%\n" $cov $sdt
