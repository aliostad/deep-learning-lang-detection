#!/bin/bash

usage()
{
cat <<EOF
usage: `basename $0` options
Calls fixReconcileSample for several samples
OPTIONS:
   -h     Show this message and exit
   -i DIR [Required] Input directory.
   -o DIR [Required] 
   -f DIR Fastq directory [Default: \$MAYAROOT/rawdata/fastq].
   -l STR List of samples. If not provided, it will read from STDIN.
   -c     Overwrite [0]
   -r     RNA
EOF
}

CLEAN=''
RNA=0
INDIR=
OUTDIR=
FQDIR=${MAYAROOT}/rawdata/fastq
LIST=
while getopts "hi:o:l:f:cr" opt
do
    case $opt in
	h)
	    usage; exit;;
	i)
	    INDIR=$OPTARG;;
	o)
	    OUTDIR=$OPTARG;;
	f) 
	    FQDIR=$OPTARG;;
	l)
	    LIST=$OPTARG;;
	c) 
	    CLEAN='-c';;
	r)
	    RNA=1;;
	?)
	    usage
	    exit 1;;
    esac	    
done

if [[ -z $OUTDIR || -z $INDIR ]]; then
    usage; exit 1;
fi
if [ ! -d $OUTDIR ]; then
    mkdir -p $OUTDIR
fi
if [ ! -d $INDIR ]; then
    echo 'Indir does not exist' 1>&2; exit 1;
fi
if [ ! -d $FQDIR ]; then
    echo 'Fqdir does not exist' 1>&2; exit 1;
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
    inpref=${INDIR}/${sample}

    fq1=${FQDIR}/$(basename $fq)

    if [[ ! -f ${INDIR}/${sample}_reconcile.bam ]]; then
	echo "Skipping $sample. Nothing to fix." 1>&2; continue;
    fi
    if [[ $RNA -eq 0 ]]; then
	if [[ $CLEAN == "-c" || ! -f ${OUTDIR}/dedup/${sample}_reconcile.dedup.bam ]]; then
	    bsub -J ${sample}_fix -eo ${OUTDIR}/${sample}_reconcile_bjob.err -o /dev/null -n 1 -q research-rh6 -W 24:00 -M 16384 -R "rusage[mem=16384]" "${MAYAROOT}/src/bin/fixReconcileSample.sh --indir $INDIR --outdir $OUTDIR --sample ${sample} --fq $fq1 $CLEAN"
	else
	    echo "Skipping $sample. Output file exists." 1>&2; continue;
	fi
    fi
done < "${LIST:-/proc/${$}/fd/0}"
