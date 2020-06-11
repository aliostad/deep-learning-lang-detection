#!/usr/local/bin/bash

#Pipeline script for imputation
#this is the case of updated positions with liftover!

#Args (toBe substitute)
#$1 = genotype file path
#$2= chr
#$3= reference file path
#$4= output file
#$5= geno mode TRUE/FALSE

function my_trap_handler()
{
        MYSELF="$0"               # equals to my script name
        LASTLINE="$1"            # argument 1: last line of error occurence
        LASTERR="$2"             # argument 2: error code of last command
        echo "${MYSELF}: line ${LASTLINE}: exit status of last command: ${LASTERR}"

        # do additional processing: send email or SNMP trap, write result to database, etc.
	exit 1
}


if [ $# -lt 5 ]
then
	echo -e "**********************\nWRONG ARGUMENT NUMBER!!!\n**********************"
	echo -e "USAGE:\n impute_imputation_pipeline.sh <genotype files path> <chr> <reference files path> <output file path> [imputation mode]\n"
	echo -e "- <genotype files path> : path for genotypes files"
	echo -e "- <chr> : chromosome number"
	echo -e "- <reference files path> : path for reference files"
	echo -e "- <output files path> : output path"
	echo -e "- <chunk> : chunk number"
	echo -e "- [imputation mode] : if specified a 'geno' argument, the imputation will be performed using the genotypes otherwise the pre-phased haplotypes\n"

exit 1
fi

# trap commands with non-zero exit code
#
trap 'my_trap_handler ${LINENO} $?' ERR

##PART 3: IMPUTATION

#function to create the script to be launched for each chunk
function build_chunk_template(){
cat << EOF
#!/bin/bash
#BSUB -J "i_c$1_c$7"
#BSUB -o "%J_i_c$1_c$7.log"
#BSUB -e "%J_i_c$1_c$7.err"

chr=$1
start=$2
end=$3
ref_path=$4
geno_path=$5
out_path=$6
chunk_n=$7
strand_file=$9
geno_mode="${10}"

#ARGS passed
#\$1=chr ($1)
#\$2=start ($2)
#\$3=end ($3)
#\$4=ref_path ($4)
#\$5=geno_path ($5)
#\$6=out_path ($6)
#\$7=chunk_n ($7)

if [ -n \$geno_mode ]
then
	bash /nfs/users/nfs_m/mc14/Work/bash_scripts/impute2_launcher_script.sh \${chr} \${start} \${end} \${ref_path} \${geno_path} \${out_path} \${chunk_n} \${strand_file} \${geno_mode}
else
	bash /nfs/users/nfs_m/mc14/Work/bash_scripts/impute2_launcher_script.sh \${chr} \${start} \${end} \${ref_path} \${geno_path} \${out_path} \${chunk_n} \${strand_file}
fi
#impute2_launcher_script.sh ${chr} ${start} ${end} ${ref_path} ${geno_path} ${out_path} ${chunk_n}
EOF
}

#convert genotypes in impute format, if not using pre-phased data
if [ $# -eq 6 ]
then
	echo "SIX ARGUMENTS!!!..."

	if [ $6 == "geno" ]
	then
	echo "Genotype conversion...."
		gtool -P --map $1/CHR$2/IMPUTE_INPUT/chr$2_to_convert.map --ped $1/CHR$2/IMPUTE_INPUT/chr$2_to_convert.ped --og $1/CHR$2/IMPUTE_INPUT/chr$2.geno --os $1/CHR$2/IMPUTE_INPUT/chr$2.sample
	fi
fi

#now we can launch impute2

#create the output folder for current chr
mkdir -p $4/CHR$2/IMPUTE_INPUT

current_out_dir=$4/CHR$2

#we need to generate chromosome chunks aware scripts
#use same approach used by Cinzia Sala:
chunk=$5

# legend=`ls $3/chr$2.${chunk}.*.legend.gz`
# hap=`ls $3/chr$2.${chunk}.*.hap.gz`
whole_ref_legend=`ls $3/chr$2.legend.gz`
# filename=`basename ${legend}`
filename=`basename ${whole_ref_legend}`

chrom_start=`zcat ${whole_ref_legend} | grep -v position | awk '{print $2}' | head -n 1`
# chrom_start=`echo ${filename} | cut -f 3 -d "." | cut -f 1 -d "_"`
# chrom_end=`echo ${filename} | cut -f 3 -d "." | cut -f 2 -d "_"`
chrom_end=`zcat ${whole_ref_legend} | grep -v position | awk '{print $2}' | tail -n 1`

#find_start_end.sh $3/ALL_1000G_phase1integrated_v3_chr$2_impute.legend.gz $2 $3

#once done this, we can generate our chunks and launch impute
#initilize the chunk counter
chunk_start=$chrom_start
chunk_count=0
# chunk_end=$chrom_end
chunk_end=0
c_size=3000000
echo ${chrom_start}
echo ${chrom_end}
echo ${filename}

while [ $chunk_end -ne $chrom_end ]
do
	let chunk_count=$[chunk_count + 1]
	let chunk_end=$[chunk_start + c_size - 1]
	
	if [ $chunk_end -gt $chrom_end -o $chunk_end -eq $chrom_end ]
	then
		let chunk_end=$chrom_end
	fi
	
	#check if there is space left for another chunk
	next_start=$[chunk_end + 1]
	next_size=$[chrom_end - next_start]

	echo ${next_start}
	echo ${chrom_end}
	echo ${next_size}

	if [ $next_size -lt $[c_size -1] ]
	then
		let chunk_end=$chrom_end
	fi

	if [ $chunk_count -lt 10 ]
	then
		chunk_n="0$chunk_count"
	else
		chunk_n=$chunk_count
	fi
	echo -e "Processing CHROMOSOME $2 ....\nCreated chunk $chunk_count \nStart: $chunk_start \nEnd: $chunk_end"

	#create a strand file for eventually flipped sites
	#Flipping strand means changing alleles
	#A -> T
	#C -> G
	#G -> C
	#T -> A
	awk 'NR==FNR{
		a[$3,$4,$5]=$3;next;
		}
		{
		if(a[$2,$3,$4] && length($4)==1 && length($3)==1)
			 print a[$2,$3,$4],"+";
		else if($3 == "A" && $4=="T" && a[$2,$4,$3] && length($4)==1 && length($3)==1)
			 print a[$2,$3,$4],"-";
		}' $1/$2.phased.haps <(zcat ${whole_ref_legend}) > ${current_out_dir}/IMPUTE_INPUT/c${chunk_n}.strand
		# }' $1/$2.phased.haps <(zcat ${legend}) > ${current_out_dir}/IMPUTE_INPUT/c${chunk}.strand

	chr=$2
	start=$chunk_start
	end=$chunk_end
	ref_path=$3
	geno_path=$1
	out_path=$current_out_dir
	strand_file=${current_out_dir}/IMPUTE_INPUT/c${chunk_n}.strand
	# strand_file=${current_out_dir}/IMPUTE_INPUT/c${chunk}.strand
	
	
	legend=`ls $3/chr$2.${chunk_n}.*.legend.gz`
	hap=`ls $3/chr$2.${chunk_n}.*.hap.gz`

	if [ $# -eq 6 ]
	then
		if [ $6 == "geno" ]
		then
			build_chunk_template ${chr} ${start} ${end} $ref_path $geno_path $out_path ${chunk_n} ${current_out_dir}/IMPUTE_INPUT ${strand_file} $5 > ${current_out_dir}/IMPUTE_INPUT/chr${chr}.${chunk}.${start}_${end}.lsf
			# build_chunk_template ${chr} ${start} ${end} $ref_path $geno_path $out_path ${chunk} ${current_out_dir}/IMPUTE_INPUT ${strand_file} $5 > ${current_out_dir}/IMPUTE_INPUT/chr${chr}.${chunk}.${start}_${end}.lsf
		fi
	else
		# build_chunk_template ${chr} ${start} ${end} $ref_path $geno_path $out_path ${chunk} ${current_out_dir}/IMPUTE_INPUT ${strand_file} > ${current_out_dir}/IMPUTE_INPUT/chr${chr}.${chunk}.${start}_${end}.lsf
		build_chunk_template ${chr} ${start} ${end} $ref_path $geno_path $out_path ${chunk_n} ${current_out_dir}/IMPUTE_INPUT ${strand_file} > ${current_out_dir}/IMPUTE_INPUT/chr${chr}.${chunk_n}.${start}_${end}.lsf
	fi
	#change permission
	chmod ug+x ${current_out_dir}/IMPUTE_INPUT/chr${chr}.${chunk_n}.${start}_${end}.lsf
	
	let chunk_start=$[chunk_end + 1]

done




