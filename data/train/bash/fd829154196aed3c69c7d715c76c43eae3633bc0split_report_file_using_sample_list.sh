#!/bin/bash

report_file=$1

sample_list=$2

head -1 ${report_file} | sed 's/\t/\n/g' | sed -e 's/.GType//g' -e 's/.X//g' -e 's/.Y//g' | awk '{print NR"\t"$1}' > ${report_file}_header_transposed_temp

echo -e "1\n2\n3" >${sample_list}_to_extract_temp

fgrep -wf ${sample_list} ${report_file}_header_transposed_temp | awk '{print $1}' | sed ':a;N;$!ba;s/\n/,/g' >> ${sample_list}_to_extract_temp

sed ':a;N;$!ba;s/\n/,/g' ${sample_list}_to_extract_temp > ${sample_list}_to_extract

cut -f$(cat ${sample_list}_to_extract) ${report_file} > ${report_file}_${sample_list}_only.report

rm ${report_file}_header_transposed_temp ${sample_list}_to_extract_temp
