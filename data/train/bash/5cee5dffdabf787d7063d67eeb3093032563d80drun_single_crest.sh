#!/bin/bash

########################################################
###### 	SV CALLER FOR WHOLE GENOME ANALYSIS PIPELINE

######		Program:			run_cnvnator.sh
######		Date:				09/26/2011
######		Summary:			Calls CNVnator
######		Input 
######		$1	=	samplename
######		$2	=	input_bam
######		$3	=	/path/to/output directory
######		$4	=	/path/to/run_info.txt
######		Output files:	BAM files. 
########################################################

if [ $# -le 4 ]
then
	echo -e "script to run CREST on a bam file\nUsage: <samplename> </path/to/align directory/> <bam file name> </path/to/output directory> </path/to/run_info.txt><SGE_TASK_ID(optional)>";
else
	set -x
	echo `date`
	sample=$1
	input=$2
	input_bam=$3
	output_dir=$4
	run_info=$5
	if [ $6 ]
	then
		SGE_TASK_ID=$6
	fi	
	
########################################################	
######		Reading run_info.txt and assigning to variables
#SGE_TASK_ID=2
	tool_info=$( cat $run_info | grep -w '^TOOL_INFO' | cut -d '=' -f2)
	script_path=$( cat $tool_info | grep -w '^WORKFLOW_PATH' | cut -d '=' -f2 )
	picard=$( cat $tool_info | grep -w '^PICARD' | cut -d '=' -f2 ) 
	java=$( cat $tool_info | grep -w '^JAVA' | cut -d '=' -f2)
	samtools=$( cat $tool_info | grep -w '^SAMTOOLS' | cut -d '=' -f2 )
	crest=$( cat $tool_info | grep -w '^CREST' | cut -d '=' -f2 )
	perllib=$( cat $tool_info | grep -w '^PERLLIB' | cut -d '=' -f2 )
	cap3=$( cat $tool_info | grep -w '^CAP3' | cut -d '=' -f2 )
	blat=$( cat $tool_info | grep -w '^BLAT' | cut -d '=' -f2 )
	blat_port=$( cat $tool_info | grep -w '^BLAT_PORT' | cut -d '=' -f2 )
	blat_ref=$( cat $tool_info | grep -w '^BLAT_REF' | cut -d '=' -f2 )
	blat_server=$( cat $tool_info | grep -w '^BLAT_SERVER' | cut -d '=' -f2 )
	chr=$(cat $run_info | grep -w '^CHRINDEX' | cut -d '=' -f2 | tr ":" "\n" | head -n $SGE_TASK_ID | tail -n 1)
	ref_genome=$( cat $tool_info | grep -w '^REF_GENOME' | cut -d '=' -f2 )
	min_read=$( cat $tool_info | grep -w '^STRUCT_MIN_SUPPORT' | cut -d '=' -f2)
	min_id=$( cat $tool_info | grep -w '^STRUCT_MIN_IDENTITY' | cut -d '=' -f2)
	blacklist_sv=$( cat $tool_info | grep -w '^BLACKLIST_SV' | cut -d '=' -f2 )
	bedtools=$( cat $tool_info | grep -w '^BEDTOOLS' | cut -d '=' -f2 )
	analysis=$( cat $run_info | grep -w '^ANALYSIS' | cut -d '=' -f2 | tr "[A-Z]" "[a-z]" )
	crest_params=$( cat $tool_info | grep -w '^CREST_params' | cut -d '=' -f2 )
##############################################################		
    if [ $analysis == "variant" ]
	then
		previous="reformat_BAM"
	else
		previous="processBAM.sh"		
	fi	
########################################################	
######		
	pid=""
	$samtools/samtools view -H $input/$input_bam 1>$input/$input_bam.crest.$chr.header 2>$input/$input_bam.$chr.fix.crest.log
	if [ `cat $input/$input_bam.$chr.fix.crest.log | wc -l` -gt 0 ]
	then
		$script_path/email.sh $input/$input_bam "truncated or corrupt bam" $previous $run_info
		$script_path/wait.sh $input/$input_bam.$chr.fix.crest.log
	else
		rm $input/$input_bam.$chr.fix.crest.log
	fi	
	rm $input/$input_bam.crest.$chr.header
	SORT_FLAG=`$script_path/checkBAMsorted.pl -i $input/$input_bam -s $samtools`
	if [ $SORT_FLAG == 0 ]
	then
		$script_path/errorlog.sh $input/$input_bam run_single_crest.sh ERROR "bam is not sorted"
		exit 1;
	fi
    if [ ! -s $input/$input_bam.bai ]
	then
	    $samtools/samtools index $input/$input_bam 
	fi

    export PERL5LIB=$perllib:$crest
	PATH=$PATH:$blat:$crest:$perllib
	mkdir -p $output_dir/$sample
	$samtools/samtools view -b $input/$input_bam chr$chr > $output_dir/$sample/$sample.chr${chr}.cleaned.bam
	$samtools/samtools index $output_dir/$sample/$sample.chr${chr}.cleaned.bam
	
	mkdir -p $output_dir/$sample/log
    export TMPDIR=$output_dir/$sample/log
	range=20000
	let blat_port+=$RANDOM%range
	status=`$blat/gfServer status localhost $blat_port | wc -l`;
	input_bam=$output_dir/$sample/$sample.chr${chr}.cleaned.bam
    
	if [ "$status" -le 1 ]
	then
		$blat/gfServer start localhost $blat_port -log=$output_dir/$sample/log/blat.$sample.$chr.txt $blat_ref  &
		pid=$!
		sleep 5m
	fi
	$crest/extractSClip.pl -i $input_bam -r chr$chr --ref_genome $ref_genome -o $output_dir/$sample -p $sample
	status=`$blat/gfServer status localhost $blat_port | wc -l`;
	let count=0
	while [[ "$status" -le 1 && $count -le 5 ]]
	do
		`kill -9 $pid`
		blat_port=$( cat $tool_info | grep -w '^BLAT_PORT' | cut -d '=' -f2 )
		range=20000
		let blat_port+=$RANDOM%range
		status=`$blat/gfServer status localhost $blat_port | wc -l`;
		if [ "$status" -le 1 ]
		then
			rm $output_dir/$sample/log/blat.$sample.$chr.txt
			$blat/gfServer start localhost $blat_port -log=$output_dir/$sample/log/blat.$sample.$chr.txt $blat_ref  &
			pid=$!
			sleep 5m
		fi
		status=`$blat/gfServer status localhost $blat_port | wc -l`;
		let count=count+1
	done 	
	
	if [ $count -ge 5 ]
	then
		$script_path/errorlog.sh GFSERVER run_single_crest.sh ERROR "failed to create gfserver"
		exit 1;
	fi	
	cd $crest    
	if [ -f $output_dir/$sample/$sample.chr$chr.cover ]
	then
		$crest/CREST.pl -f $output_dir/$sample/$sample.chr$chr.cover -d $input_bam \
		--ref_genome $ref_genome -t $blat_ref \
		--blatport $blat_port -blatserver localhost \
		--cap3 $cap3/cap3 \
		-o $output_dir/$sample -p $sample.$chr $crest_params
        rm $input_bam $input_bam.bai
		$script_path/CREST2VCF.pl -i $output_dir/$sample/$sample.$chr.predSV.txt -f $ref_genome -o $output_dir/$sample/$sample.$chr.vcf -s $sample -t $samtools
		if [ ! -s $output_dir/$sample/$sample.$chr.vcf.fail ]
        then
            rm $output_dir/$sample/$sample.$chr.vcf.fail
        fi  
		$script_path/vcfsort.pl ${ref_genome}.fai $output_dir/$sample/$sample.$chr.vcf > $output_dir/$sample/$sample.$chr.vcf.sort
		mv $output_dir/$sample/$sample.$chr.vcf.sort $output_dir/$sample/$sample.$chr.vcf
		awk "((\$10>=$min_read)&&(\$11>=$min_read)&&(\$14>=$min_id)&&(\$16>=$min_id))" $output_dir/$sample/$sample.$chr.predSV.txt | awk '{print $1"\t"$2"\t"$2+1"\t"$5"\t"$6"\t"$6+1}' | $bedtools/pairToBed -a stdin -b $blacklist_sv -type neither | $script_path/report_original.pl $output_dir/$sample/$sample.$chr.predSV.txt > $output_dir/$sample/$sample.$chr.final.predSV.txt
		### convert the output to VCF format
		$script_path/CREST2VCF.pl -i $output_dir/$sample/$sample.$chr.final.predSV.txt -f $ref_genome -o $output_dir/$sample/$sample.$chr.final.vcf -s $sample -t $samtools
		if [ ! -s $output_dir/$sample/$sample.$chr.final.vcf.fail ]
        then
            rm $output_dir/$sample/$sample.$chr.final.vcf.fail
        fi  
		$script_path/vcfsort.pl ${ref_genome}.fai $output_dir/$sample/$sample.$chr.final.vcf > $output_dir/$sample/$sample.$chr.final.vcf.sort
		mv $output_dir/$sample/$sample.$chr.final.vcf.sort $output_dir/$sample/$sample.$chr.final.vcf
		if [ -f $output_dir/$sample/$sample.$chr.predSV.txt ]
		then
			rm $output_dir/$sample/$sample.chr$chr.cover $output_dir/$sample/$sample.chr$chr.sclip.txt 
		else
			$script_path/errorlog.sh $output_dir/$sample/$sample.$chr.predSV.txt run_single_crest.sh ERROR "failed to create"
			exit 1;
		fi			
	else
		$script_path/errorlog.sh $output_dir/$sample/$sample.chr$chr.cover run_single_crest.sh ERROR "failed to create"
		touch $output_dir/$sample/$sample.$chr.predSV.txt
		$script_path/CREST2VCF.pl -i $output_dir/$sample/$sample.$chr.predSV.txt -f $ref_genome -o $output_dir/$sample/$sample.$chr.vcf -s $sample -t $samtools
		rm $output_dir/$sample/$sample.$chr.vcf.fail
		touch  $output_dir/$sample/$sample.$chr.final.predSV.txt
		$script_path/CREST2VCF.pl -i $output_dir/$sample/$sample.$chr.final.predSV.txt -f $ref_genome -o $output_dir/$sample/$sample.$chr.final.vcf -s $sample -t $samtools
		rm $output_dir/$sample/$sample.$chr.final.vcf.fail
	fi
	`kill -9 $pid`
    echo `date`
fi
