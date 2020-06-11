#!/usr/bin/env bash
set -e

MAPPER=100

for SAMPLE in {100..800..100}
do
	for i in 1 2 3
	do 
		echo "sample=$SAMPLE run=$i"
		hadoop jar ~/test/jars/samplingdriver.jar disc \
			-D mapred.job.name="scale-mapper, disc, sample${SAMPLE}, mapper${MAPPER}"	\
			-D mapred.min.split.size=0	\
			-D mapred.map.tasks=${MAPPER}	\
			-D dps.right.line.length=585	\
			/user/s117449/disc-datasets/census/positive.data	\
			/user/s117449/disc-datasets/census/negative-expanded/negative.data-expanded-584	\
			/user/s117449/output/disc-census-sample${SAMPLE}-mapper${MAPPER}-run${i}		\
			${SAMPLE}
	done
done
