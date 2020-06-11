#!/usr/local/bin/bash
#
#Script to launch fastqc on each fastaq file for each sample..

if [ $# -lt 2 ]
then
	echo -e "**********************\nWRONG ARGUMENT NUMBER!!!\n**********************"
        echo -e "USAGE:\n fastqc_launcher.sh <sample_file_path> <output file path> \n"
	exit 1
fi

sample_file_path=$1
# sampledir=`dirname $sample_file_path`
samplename=`echo ${sample_file_path##*/}`
outdir=$2/${samplename}
# file_count=0

mkdir -p $outdir

# /nfs/team151/software/bin/fastqc $sample_file_path --casava --outdir=$outdir
/nfs/team151/software/bin/fastqc --casava -t 4 $sample_file_path/*.fastq.gz --outdir=$outdir

# for file in `ls $sample_file_path/*.fastq.gz`
# do
# 	filecount=$[filecount+1]
# 	echo $filecount
# 	echo ${sample_file_path#*Sample_}
# 	# qsub -N $filecount_${sample_file_path#*Sample_} -e $outdir/$filecount_fastqc.err -o $outdir/$filecount_fastqc.log -q workq -- /lustre1/tools/bin/fastqc $file --outdir=$outdir
# 	bsub -J"$filecount_${sample_file_path#*Sample_}" -o"$outdir/$filecount_fastqc.o" -M4000 -R"select[mem>=4000] rusage[mem=4000]" -q normal -- /nfs/team151/software/bin/fastqc $file --outdir=$outdir
# done
