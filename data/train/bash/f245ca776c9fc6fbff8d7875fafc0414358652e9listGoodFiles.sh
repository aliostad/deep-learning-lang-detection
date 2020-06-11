#!/bin/bash

syntax="Syntax ${0} {sampleName}"
if [[ -z ${1} ]]
then
  echo ${syntax}
  exit 1
fi
sample=${1}

NbOfXmlFiles=`'ls' ${sample}/res/*xml | wc -l`

NbOfReportedJobs=`grep "Total Jobs : " ${sample}/log/crab.log | tail -n 1 | awk '{print $4}'`

echo "(Nb of xml files / Nb of Reported Jobs) = ( ${NbOfXmlFiles} / ${NbOfReportedJobs} )"

#if [[ "${NbOfXmlFiles}" != "${NbOfReportedJobs}" ]]; then echo "WARNING, DISCREPANCY, EMERGENCY STOP"; exit 222; fi

if [[ -e listFiles_${sample} ]]
then
#	echo "listFiles_${sample} exists!"
	rm listFiles_${sample}
#else
#	echo "file listFiles_${sample} does not exist"
fi

for ixml in `seq 1 ${NbOfXmlFiles}`
do
	XMLfield=`grep "PFN Value" ${sample}/res/crab_fjr_${ixml}.xml`
	echo ${XMLfield} | cut -d = -f 3 | cut -d \" -f 1 >> listFiles_${sample}
#	break;
done

echo "****** file listFiles_${sample} created ******"
#exit 1

exit 0
