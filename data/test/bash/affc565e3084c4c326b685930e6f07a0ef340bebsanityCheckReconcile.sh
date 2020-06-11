#!/bin/bash

usage()
{
cat <<EOF
usage: `basename $0` options
Checks whether a bam file has the right number of pairs.
OPTIONS:
   -h     Show this message and exit
   -b DIR [Required] Input directory with BAM files.
   -f DIR [Required] Input directory with FASTQ files.
   -d FILE File with samples that have been checked already.
   -l STR List of input samples. If not provided, it will read from STDIN.
EOF
}

BAMDIR=
FQDIR=
LIST=
CHECKED=
while getopts "hb:f:l:d:" opt
do
    case $opt in
	h)
	    usage; exit;;
	b)
	    BAMDIR=$OPTARG;;
	f)
	    FQDIR=$OPTARG;;
	l)
	    LIST=$OPTARG;;
	d) 
	    CHECKED=$OPTARG;;
	?)
	    usage
	    exit 1;;
    esac	    
done

if [[ -z $BAMDIR || -z $FQDIR ]]; then
    usage; exit 1;
fi
if [ ! -d $BAMDIR ]; then
    echo 'Input directory does not exist' 1>&2; exit 1;
fi
if [ ! -d $FQDIR ]; then
    echo 'Fastq directory does not exist' 1>&2; exit 1;
fi

while read -r sample fq; do
    if [[ "$sample" =~ ^SNYDER_HG19_ ]]; then
	sample=$sample
    else
	sample=${sample^^} # This will convert to uppercase
	if [[ "$sample" =~ ^[0-9]+ ]]; then # Correct HapMap names
	    sample="GM"$sample
	fi
	sample="SNYDER_HG19_${sample}"
    fi
    if [[ ! -z $CHECKED ]]; then
	hit=`egrep $sample $CHECKED | wc -l`
	if [[ $hit -gt 0 ]]; then
	    echo "Skipping $sample. Missing input files." 1>&2; continue;
	fi
    fi
    fq=`basename $fq`
    bamout=${BAMDIR}/${sample}_reconcile.out
    if [[ -f $bamout && -f ${FQDIR}/${fq} ]]; then
	tot=`egrep "Total alignments" $bamout | cut -f2`
	pairs=`zcat ${FQDIR}/${fq} | wc -l | awk '{print $1/4}'`
	if [[ tot -eq pairs ]]; then
	    echo -e "${sample}\t${tot}\t${pairs}\tOK"
	else
	    echo -e "${sample}\t${tot}\t${pairs}\tWRONG"
	fi
    else
	echo "Skipping $sample. Missing input files." 1>&2
    fi
done < "${LIST:-/proc/${$}/fd/0}"