#!/usr/bin/env bash 

SAMPLE=$1
MAPPER=100

hadoop jar ~/test/jars/discdriver.jar  \
	-D mapred.job.name="scale-sample, disc, adult, sample${SAMPLE}, mapper${MAPPER}" \
	-D mapred.map.tasks.speculative.execution=false \
	-D mapred.map.tasks=${MAPPER}	\
	-D dps.right.line.length=148    \
	/user/s117449/disc-datasets/adult/positive.data     \
	/user/s117449/disc-datasets/adult/negative-expanded/negative-expanded-147   \
	/user/s117449/disc-datasets/adult/output/disc-sample${SAMPLE}-mapper${MAPPER}       \
	${SAMPLE}						
