#!/bin/bash

echo "<nexus>"
for sample in $(cat Samples/SampleList.txt)
do
	sampleDownloaded="true"
	echo "" > 1

	for file in $(ls Samples/$sample)
	do
		target=Samples/$sample/$(readlink Samples/$sample/$file)
		downloaded="false"
	
		if test -f $target
		then
			downloaded="true"
		else
			sampleDownloaded="false"
		fi

		echo "<file><name>$file</name><target>$target</target><downloaded>$downloaded</downloaded></file>" >> 1
	done

	processed="false"

	if test $(find Samples|grep "$sample."|grep OutputNum|head -n1|wc -l) -eq 1
	then
		processed="true"
	fi

	echo "<sample><name>$sample</name><downloaded>$sampleDownloaded</downloaded><processed>$processed</processed>"

	cat 1

	echo "</sample>"
done


echo "</nexus>"
