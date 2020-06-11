#!/bin/sh
#$-S /bin/bash
#$-cwd
#$-V


#########################################################################
# -- Author: Amos Folarin                                               #
# -- Organisation: KCL/SLaM                                             #
# -- Email: amosfolarin@gmail.com                                       #
#########################################################################

#DESC:
# This script reconstructs the full opticall .calls file from the chromosome chunked files
# running opticall on chromosome chunks is recommended in the Opticall docs.

#USAGE:
# qsub sge_opticall_concat.sh <basename>

#ARGS:
basename=${1} #genome studio report file basename

#------------------------------------------------------------------------
# Concatenate:
# 1. all the chunked calls from opticall
#------------------------------------------------------------------------

#final file to hold all the concatenated .calls chunks
concat_calls="${basename}_filt_opticall-cat.calls"
#a temporary file for chunks cache
tmp_chunk="opticall_collate_chunk.tmp"


> ${concat_calls} #create empty file, and clobber
> ${tmp_chunk} #create empty file, and clobber

# concatenate the opticall chunk files
for i in `seq 1 26`;
do
	#autosomes
	if [ ${i} -le 22 ]
	then
		if [ ${i} -eq 1 ]
	        then
                	cat ${basename}_filt.report_Chr_1_opticall-out.calls > ${concat_calls}
       		else
                	cp ${basename}_filt.report_Chr_${i}_opticall-out.calls ${tmp_chunk}   
                	sed -i -e '1d' ${tmp_chunk} #strip header after first chunk
                	cat ${tmp_chunk} >> ${concat_calls}
        	fi

	fi
	
	# Other chromosomes 
	if [ ${i} -eq 23 ]
	then
		cp ${basename}_filt.report_Chr_X_opticall-out.calls ${tmp_chunk} 
                sed -i -e '1d' ${tmp_chunk} #strip header after first chunk
                cat ${tmp_chunk} >> ${concat_calls}
	fi

	if [ ${i} -eq 24 ]
	then
		cp ${basename}_filt.report_Chr_Y_opticall-out.calls ${tmp_chunk} 
                sed -i -e '1d' ${tmp_chunk} #strip header after first chunk
                cat ${tmp_chunk} >> ${concat_calls}
	fi
	
	if [ ${i} -eq 25 ]
	then
		cp ${basename}_filt.report_Chr_XY_opticall-out.calls ${tmp_chunk}  
                sed -i -e '1d' ${tmp_chunk} #strip header after first chunk
		cat ${tmp_chunk} >> ${concat_calls}
	fi
	
	
	if [ ${i} -eq 26 ]
	then
		cp ${basename}_filt.report_Chr_MT_opticall-out.calls ${tmp_chunk}   
       		sed -i -e '1d' ${tmp_chunk} #strip header after first chunk
		cat ${tmp_chunk} >> ${concat_calls}
	fi

done

#cleanup tmp file
rm ${tmp_chunk}
