#!/bin/sh

matlab -r run\(\'batch.m\'\)

shdir=${PWD}
cat ./list.txt | while read line
do
	dir=${line%/*}
	file=${line##*/}
	if test ${file##*.} = "slx"; then
		model=${file%.slx}
	else
		model=${file%.mdl}
	fi
	cd ${dir}
	echo ""
	echo ${file}
	qgenc $line -s eps -t ${model}_types.txt -m ${model}_ws.m -i
	cp ${shdir}/SimulinkModel.xsd ./
	${shdir}/qgen-xmi_parser ${line}_generated/${model}_0.xmi -o xx_${model}.xml
	${shdir}/rtw_test -c ${model}_ert_rtw/${model}.c -h ${model}_ert_rtw/${model}.h xx_${model}.xml yy_${model}.xml
	${shdir}/csp_translator -v -s yy_${model}.xml -i testout-${model}_res.c -i testout-${model}.h -T mcos -X testout-${model}.c --create-t0=y
	perl ${shdir}/mcos/genres.pl testout-${model}.c > testout-${model}_res.c
	#make -f ${shdir}/Makefile TARGET=${model} TARGET_DIR=${dir} SH_DIR=${shdir}
done	
cd ${shdir}