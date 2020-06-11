#!/usr/local/bin/bash
#
#################################################
#	CUSTOMIZED FOR CHRX imputation by max!!!!!		#
#################################################
# For CGI:
#	1. remove extra_str; remove PRE-PHASING file check
#	2. -g $scratch113/imputed/$geno/wgs/chr$chr.gwas.gen.gz -k 100

## from Shane: /lustre/scratch106/projects/uk10k/RELEASE/UK10K_COHORT/REL-2012-06-02/v3/

k_hap=10000 #Number of reference haplotypes to use as templates when imputing missing genotypes
geno=vb121_X #prefix of unphased genotypes in plink format
genodir=/lustre/scratch113/projects/uk10k/users/jh21/imputed/vb/${geno} #folder containing unphased genotypes
refname=uk10k1kg ## 1kg, uk10k, uk10k1kg #reference panel prefix
postfix=".shapeit" ## "" or ".shapeit" #postfix for reference panel files
by_chunk=Y  ## "Y" or "N"
scratch113=/lustre/scratch113/projects/uk10k/users/jh21/jh21 #base folder on scratch113 (or any other location where you store your files)
scratch113=/lustre/scratch113/projects/uk10k/users/jh21/jh21 #base folder on scratch113 (or any other location where you store your files)
refdir=$scratch113/references_panel #reference panel folder
phasedir=$scratch113/imputed/$geno/shapeit #output folder for phased genotypes or folder containing already phased genotypes
imputedir=$scratch113/imputed/$geno/${refname}$postfix #output folder for imputation
mkdir -p ${phasedir}
mkdir -p ${imputedir}

impute2=/nfs/team151/software/bin/impute2.3.1 #impute2 command location
chunk_size=3000000 #size for a chunk on a chromosome
buffer_size=250 #buffer size for imputation
window_size=2 #window size for phasing
thread=8 
extra_str="-verbose" #"-verbose" #"-phase"
# extra_str="-exclude_samples_g /nfs/team151/jh21/data/uk10kgwas/uk10kgwas.1000.excluded -sample_h $refdir/$refname/$refname.sample_h.sample -exclude_samples_h /nfs/team151/jh21/data/uk10kgwas/uk10kgwas.1000.included"
# extra_str="-exclude_samples_g $scratch113/references_panel/uk10k/uk10k.sample.ids"

# for chr in {1..22}; do
# for chr in X_PAR1 X_PAR2 X ; do
for chr in {1..22} X_PAR1 X_PAR2 X; do
	#some checks to work on chrX: we need to impute separately 
	if [[ "$chr" == "X_PAR1" ]]; then # (60,001 - 2,699,520)
		plink_str="--chr X --from-bp 60001 --to-bp 2699520"
		chrX_phase_str=""
		chrX_impute_str="-chrX -Xpar"
	elif [[ "$chr" == "X" ]]; then
		plink_str="--chr X --from-bp 2699521 --to-bp 154931043"
		chrX_phase_str="--chrX" 
		chrX_impute_str="-chrX" ## -sample_g already specified elsewhere
	elif [[ "$chr" == "X_PAR2" ]]; then # (154,931,044-155,260,560)
		plink_str="--chr X --from-bp 154931044 --to-bp 999999999"
		chrX_phase_str=""
		chrX_impute_str="-chrX -Xpar"
	else
		plink_str="--chr $chr"
		chrX_phase_str=""
		chrX_impute_str=""
	fi

	### step 1: pre-phase ###
	# run only if there's not a prephased genotype file already
	if [[ ! -e $phasedir/chr$chr.hap.gz ]]; then
		#effective size parameter set to 11418 as per HapMapII estimation on CEU population
		echo phase $geno chr$chr
		echo -e "#!/usr/local/bin/bash
		\necho \"Starting on : \$(date); Running on : \$(hostname); Job ID : \$LSB_JOBID\"
		\n/nfs/team151/software/bin/plink --noweb --bfile $genodir/$geno  $plink_str --make-bed --out chr$chr\n\n
		\n/nfs/team151/software/bin/shapeit2 --thread $thread --window $window_size --states 200 --effective-size 11418 -B chr$chr --input-map $scratch113/references_panel/1kg/genetic_map_chr${chr}_combined_b37.txt --output-log chr$chr.shapeit --output-max chr$chr.hap.gz chr$chr.sample $chrX_phase_str
		" > $phasedir/chr$chr.cmd
		cd $phasedir
		bsub -J $geno.shapeit.chr$chr -q long -o chr$chr.shapeit.log -e chr$chr.shapeit.err -n$thread -R "span[ptile=$thread] select[mem>18000] rusage[mem=18000]" -M18000 < chr$chr.cmd
		continue
	fi

	### step 2: impute ###
	refhap=$refdir/$refname/chr$chr.hap.gz
	reflegend=$refdir/$refname/chr$chr.legend.gz	
	# reflegend=$refdir/$refname/chrX.legend.gz	
	#create chunks based on reference panel to overlap with existing hap files
	chr_begin=`zcat $reflegend | awk 'NR==2 {printf \$2}'`
	chr_end=`zcat $reflegend | tail -1 | awk '{printf \$2}'`
	let "chunk_num=($chr_end - $chr_begin)/$chunk_size" # bash rounds automatically
	if [[ $chunk_num <1 ]]; then
		chunk_num=1
	fi
	for chunk in `seq 1 $chunk_num`; do

		chunkStr=`printf "%02d" $chunk`
		# if [[ -e $imputedir/chr$chr.$chunkStr.log ]]; then
		if [[ -e $imputedir/chr$chr.$chunkStr.gen.gz ]]; then
			continue # in case this chunk already run, skip to the next one
		fi
		if [[ $chunk -gt 1 ]]; then
			chunk_begin=`echo "$chr_begin+($chunk-1)*$chunk_size+1" | bc`
		else
			chunk_begin=$chr_begin
		fi
		if [[ $chunk -eq $chunk_num ]]; then
			mem=32000
			queue=hugemem
			chunk_end=$chr_end
		else
			mem=32000
			queue=hugemem
			chunk_end=`echo "$chr_begin+($chunk*$chunk_size)" | bc`
		fi
		if [[ $chr.$chunkStr == 8.02 ]]; then
			mem=36000
			queue=hugemem
		fi
		if [[ $by_chunk == "Y" ]]; then
			refhap=$refdir/$refname/chr$chr.${chunkStr}$postfix.hap.gz
			reflegend=$refdir/$refname/chr$chr.${chunkStr}$postfix.legend.gz
		fi
		echo -e "#!/usr/local/bin/bash
		\n$impute2 -allow_large_regions -m $scratch113/references_panel/1kg/genetic_map_chr${chr}_combined_b37.txt -h $refhap -l $reflegend -known_haps_g $phasedir/chr$chr.hap.gz -sample_g $phasedir/chr$chr.sample $extra_str -use_prephased_g -k_hap $k_hap -int $chunk_begin $chunk_end -Ne 20000 -buffer $buffer_size -o chr$chr.$chunkStr.gen $chrX_impute_str
		\ngzip -f chr$chr.$chunkStr.gen
		\nif [[ -e chr$chr.$chunkStr.gen_allele_probs ]]; then
		\ngzip chr$chr.$chunkStr.gen_allele_probs chr$chr.$chunkStr.gen_haps
		\nfi
		\nN_info=\`awk 'NR>1' chr$chr.$chunkStr.gen_info | wc -l | awk '{printf \$1}'\`
		\nN_gen=\`zcat chr$chr.$chunkStr.gen.gz | wc -l | awk '{printf \$1}'\`
                if [[ \$N_info != \$N_gen ]]; then
                        echo \"chr$chr $chunkStr: \$N_info for info, \$N_gen for gen\" > ../chr$chr.$chunkStr.ERR
                fi
                " > $imputedir/chr$chr.$chunkStr.cmd
		cd $imputedir
		bsub -J ${refname}$postfix.$geno.chr$chr.$chunkStr -w "ended($geno.shapeit.chr$chr)" -q $queue -R "select[mem>$mem] rusage[mem=$mem]" -M${mem} -o chr$chr.$chunkStr.log -e chr$chr.$chunkStr.err < chr$chr.$chunkStr.cmd
	done
done
