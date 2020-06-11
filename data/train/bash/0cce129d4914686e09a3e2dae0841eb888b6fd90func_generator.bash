#!/bin/bash
#this script takes a file name and a number and generates
#a training file with data for distinguishing e^x and x^2
echo "<?xml version=\"1.0\"?>" > $1
echo "<samples>" >> $1
echo "<sampleCount>$(($2*2))</sampleCount>" >> $1
echo "<sampleInputCount>2</sampleInputCount>" >> $1
echo "<sampleOutputCount>2</sampleOutputCount>" >> $1
echo "<!-- the first samples are x^2 -->" >> $1
for i in `seq 0 $(($2-1))`;
do
	echo "	<sample>" >> $1
	echo -n "		<sampleInput>" >> $1
	echo "scale=8;"$i"/"$(($2-1)) | bc | tr -d '\n' >> $1
	echo "</sampleInput>" >> $1
	echo -n "		<sampleInput>" >> $1
	echo "scale=8;"$i"/"$(($2-1))"^2" | bc | tr -d '\n' >> $1
	echo "</sampleInput>" >> $1
	echo "		<sampleOutput>1</sampleOutput>" >> $1
	echo "		<sampleOutput>0</sampleOutput>" >> $1
	echo "	</sample>" >> $1
done;
echo "<!-- these samples are e^x -->" >> $1
for i in `seq 0 $(($2-1))`;
do
	echo "	<sample>" >> $1
	echo -n "		<sampleInput>" >> $1
	echo "scale=8;"$i"/"$(($2-1)) | bc | tr -d '\n' >> $1
	echo "</sampleInput>" >> $1
	echo -n "		<sampleInput>" >> $1
	echo "scale=8;e("$i"/"$(($2-1))")" | bc -l | tr -d '\n' >> $1
	echo "</sampleInput>" >> $1
	echo "		<sampleOutput>0</sampleOutput>" >> $1
	echo "		<sampleOutput>1</sampleOutput>" >> $1
	echo "	</sample>" >> $1
done;
echo "</samples>" >> $1
