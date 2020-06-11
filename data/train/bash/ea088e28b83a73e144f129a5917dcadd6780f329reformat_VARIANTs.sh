#!/bin/bash

#	INFO
#	reformat the inputs to chop into chromsome to make it faster fro vraiant module

if [ $# != 4 ]
then
    echo -e "script to reformat the vcf files for the annotation module of the workflow\nUsage: ./reformat_VARIANTs.sh </path/to/output><sample><run_info><marker>";
else	
    set -x
    echo `date`
    output=$1
    sample=$2
    run_info=$3
    marker=$4
    
    input=$( cat $run_info | grep -w '^INPUT_DIR' | cut -d '=' -f2)
    tool_info=$( cat $run_info | grep -w '^TOOL_INFO' | cut -d '=' -f2)
    sample_info=$( cat $run_info | grep -w '^SAMPLE_INFO' | cut -d '=' -f2)
    variant_type=$( cat $run_info | grep -w '^VARIANT_TYPE' | cut -d '=' -f2| tr "[a-z]" "[A-Z]")
    script_path=$( cat $tool_info | grep -w '^WORKFLOW_PATH' | cut -d '=' -f2)
    chrs=$( cat $run_info | grep -w '^CHRINDEX' | cut -d '=' -f2 | tr ":" " " )
    sample_info=$( cat $run_info | grep -w '^SAMPLE_INFO' | cut -d '=' -f2)
    distance=$( cat $tool_info | grep -w '^SNP_DISTANCE_INDEL' | cut -d '=' -f2 )
	blat=$( cat $tool_info | grep -w '^BLAT' | cut -d '=' -f2 )
    blat_ref=$( cat $tool_info | grep -w '^BLAT_REF' | cut -d '=' -f2 )
	samtools=$( cat $tool_info | grep -w '^SAMTOOLS' | cut -d '=' -f2 )
	ref=$( cat $tool_info | grep -w '^REF_GENOME' | cut -d '=' -f2)
	perllib=$( cat $tool_info | grep -w '^PERLLIB' | cut -d '=' -f2)
	blat_params=$( cat $tool_info | grep -w '^BLAT_params' | cut -d '=' -f2 )
	export PERL5LIB=$perllib:$PERL5LIB
	export PATH=$PERL5LIB:$PATH
	
    if [ $marker -eq 2 ]
    then
        snv_file=$( cat $sample_info | grep -w SNV:${sample} | cut -d '=' -f2)
        indel_file=$( cat $sample_info | grep -w INDEL:${sample} | cut -d '=' -f2)
        
		if [ "$input/$snv_file" != "$input/$indel_file" ]
		then
			## format the vcf file to text delimited file
			## determine if the file is vcf or text input
			type=`cat $input/$snv_file | head -1 | awk '{if ($0 ~ /^##/) print "vcf";else print "txt"}'`
			if [ $type == "txt" ]
			then
				$script_path/convert_txt_vcf.pl $input/$snv_file $sample > $output/$sample.SNV.vcf
				$script_path/convert_txt_vcf.pl $input/$indel_file $sample > $output/$sample.INDEL.vcf
			else
				cp $input/$snv_file $output/$sample.SNV.vcf
				cp $input/$indel_file $output/$sample.INDEL.vcf 
			fi
			n=`cat $output/$sample.SNV.vcf |  awk '$0 ~ /^##INFO=<ID=ED/' | wc -l`
			if [ $n == 0 ]
			then
				$script_path/vcf_blat_verify.pl -i $output/$sample.SNV.vcf -o $output/$sample.SNV.vcf.tmp -r $ref -b $blat -sam $samtools -br $blat_ref $blat_params
				$script_path/vcfsort.pl $ref.fai $output/$sample.SNV.vcf.tmp > $output/$sample.SNV.vcf
				rm $output/$sample.SNV.vcf.tmp
			else
				$script_path/vcfsort.pl $ref.fai $output/$sample.SNV.vcf > $output/$sample.SNV.vcf.tmp
				mv $output/$sample.SNV.vcf.tmp $output/$sample.SNV.vcf
			fi	
			n=`cat $output/$sample.INDEL.vcf |  awk '$0 ~ /^##INFO=<ID=ED/' | wc -l`
			if [ $n == 0 ]
			then
				$script_path/vcf_blat_verify.pl -i $output/$sample.INDEL.vcf -o $output/$sample.INDEL.vcf.tmp -r $ref -b $blat -sam $samtools -br $blat_ref $blat_params
				$script_path/vcfsort.pl $ref.fai $output/$sample.INDEL.vcf.tmp > $output/$sample.INDEL.vcf
				rm $output/$sample.INDEL.vcf.tmp 
			else
				$script_path/vcfsort.pl $ref.fai $output/$sample.INDEL.vcf > $output/$sample.INDEL.vcf.tmp
				mv $output/$sample.INDEL.vcf.tmp $output/$sample.INDEL.vcf 
			fi
		else
			type=`cat $input/$snv_file | head -1 | awk '{if ($0 ~ /^##/) print "vcf";else print "txt"}'`
			if [ $type == "txt" ]
			then
				$script_path/convert_txt_vcf.pl $input/$snv_file $sample > $output/$sample.vcf
			else
				cp $input/$snv_file $output/$sample.vcf
			fi
			n=`cat $output/$sample.vcf |  awk '$0 ~ /^##INFO=<ID=ED/' | wc -l`
			if [ $n == 0 ]
			then
				$script_path/vcf_blat_verify.pl -i $output/$sample.vcf -o $output/$sample.vcf.tmp -r $ref -b $blat -sam $samtools -br $blat_ref $blat_params
				$script_path/vcfsort.pl $ref.fai $output/$sample.vcf.tmp > $output/$sample.vcf
				rm $output/$sample.vcf.tmp
			else
				$script_path/vcfsort.pl $ref.fai $output/$sample.vcf > $output/$sample.vcf.tmp
				mv $output/$sample.vcf.tmp $output/$sample.vcf
			fi
			$script_path/vcf_to_variant_vcf.pl -i $output/$sample.vcf -v $output/$sample.SNV.vcf -l $output/$sample.INDEL.vcf -t both
			rm $output/$sample.vcf
		fi	
			
		for chr in $chrs
        do
            $script_path/vcf_to_variant_vcf.pl -i $output/$sample.SNV.vcf -v $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf -t snv -c chr$chr -s $sample
            $script_path/vcf_to_variant_vcf.pl -i $output/$sample.INDEL.vcf -t indel -l $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf -c chr$chr -s $sample
            cat $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf | $script_path/add.info.capture.vcf.pl > $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf.tmp
            mv $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf.tmp $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf
            if [ `cat $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf | awk '$0 !~ /^#/' | wc -l` -ge 1 ]
			then
				$script_path/markSnv_IndelnPos.pl -s $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf -i $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf -n $distance -o $output/$sample.variants.chr$chr.SNV.filter.i.c.pos.vcf
				cat $output/$sample.variants.chr$chr.SNV.filter.i.c.pos.vcf | $script_path/add.info.close2indel.vcf.pl > $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf  
				rm $output/$sample.variants.chr$chr.SNV.filter.i.c.pos.vcf
			else
				cat $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf | $script_path/add.info.close2indel.vcf.pl > $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf.tmp
				mv $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf.tmp $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf	
			fi		
        done
        rm $output/$sample.SNV.vcf $output/$sample.INDEL.vcf 
    else
        if [ $variant_type == "SNV" ]
        then
            snv_file=$( cat $sample_info | grep -w SNV:${sample} | cut -d '=' -f2)
            type=`cat $input/$snv_file | head -1 | awk '{if ($0 ~ /^##/) print "vcf";else print "txt"}'`
            if [ $type == "txt" ]
            then
                $script_path/convert_txt_vcf.pl $input/$snv_file $sample > $output/$sample.SNV.vcf
            else
                cp $input/$snv_file $output/$sample.SNV.vcf
            fi 
			n=`cat $output/$sample.SNV.vcf |  awk '$0 ~ /^##INFO=<ID=ED/' | wc -l`
			if [ $n == 0 ]
			then
				$script_path/vcf_blat_verify.pl -i $output/$sample.SNV.vcf -o $output/$sample.SNV.vcf.tmp -r $ref -b $blat -sam $samtools -br $blat_ref $blat_params
				$script_path/vcfsort.pl $ref.fai $output/$sample.SNV.vcf.tmp > $output/$sample.SNV.vcf
				rm $output/$sample.SNV.vcf.tmp
			else
				$script_path/vcfsort.pl $ref.fai $output/$sample.SNV.vcf > $output/$sample.SNV.vcf.tmp
				mv $output/$sample.SNV.vcf.tmp $output/$sample.SNV.vcf
			fi	
            for chr in $chrs	
            do
                $script_path/vcf_to_variant_vcf.pl -i $output/$sample.SNV.vcf -v $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf -t snv -c chr$chr -s $sample 
                cat $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf | $script_path/add.info.close2indel.vcf.pl |  $script_path/add.info.capture.vcf.pl > $output/$sample.variants.chr$chr.SNV.filter.i.c.pos.vcf
				mv $output/$sample.variants.chr$chr.SNV.filter.i.c.pos.vcf $output/$sample.variants.chr$chr.SNV.filter.i.c.vcf
            done
            rm $output/$sample.SNV.vcf
        elif [ $variant_type == "INDEL" ]
        then
            indel_file=$( cat $sample_info | grep -w INDEL:${sample} | cut -d '=' -f2)
            type=`cat $input/$indel_file | head -1 | awk '{if ($0 ~ /^##/) print "vcf";else print "txt"}'`
            if [ $type == "txt" ]
            then
                $script_path/convert_txt_vcf.pl $input/$indel_file $sample > $output/$sample.INDEL.vcf 
            else
                cp $input/$indel_file $output/$sample.INDEL.vcf 
            fi    
            n=`cat $output/$sample.INDEL.vcf |  awk '$0 ~ /^##INFO=<ID=ED/' | wc -l`
			if [ $n == 0 ]
			then
				$script_path/vcf_blat_verify.pl -i $output/$sample.INDEL.vcf -o $output/$sample.INDEL.vcf.tmp -r $ref -b $blat -sam $samtools -br $blat_ref $blat_params
				$script_path/vcfsort.pl $ref.fai $output/$sample.INDEL.vcf.tmp > $output/$sample.INDEL.vcf
				rm $output/$sample.INDEL.vcf.tmp 
			else
				$script_path/vcfsort.pl $ref.fai $output/$sample.INDEL.vcf > $output/$sample.INDEL.vcf.tmp
				mv $output/$sample.INDEL.vcf.tmp $output/$sample.INDEL.vcf 
			fi
			for chr in $chrs		
            do
                $script_path/vcf_to_variant_vcf.pl -i $output/$sample.INDEL.vcf -t indel -l $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf -c chr$chr -s $sample
                cat $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf | $script_path/add.info.capture.vcf.pl > $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf.tmp
				mv $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf.tmp $output/$sample.variants.chr$chr.INDEL.filter.i.c.vcf
            done
            rm $output/$sample.INDEL.vcf 
        fi		
    fi
    echo `date`	
fi	
	
	
	
	
	
	
	
		
