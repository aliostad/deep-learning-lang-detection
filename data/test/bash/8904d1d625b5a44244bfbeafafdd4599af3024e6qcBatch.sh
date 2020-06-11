#!/bin/bash

usage()
{
cat <<EOF
usage: `basename $0` options
Calls qcSample for several samples
OPTIONS:
   -h     Show this message and exit
   -i DIR [Required] Input directory.
   -o DIR [Required] Output directory.
   -l STR List of samples. If not provided, it will read from STDIN.
   -s FILE Output file [<outdir>/qc.stat]
EOF
}

STATS=
INDIR=
OUTDIR=
LIST=
while getopts "hi:o:l:s:" opt
do
    case $opt in
	h)
	    usage; exit;;
	i)
	    INDIR=$OPTARG;;
	o)
	    OUTDIR=$OPTARG;;
	l)
	    LIST=$OPTARG;;
	s) 
	    STATS=$OPTARG;;
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
if [ -z $STATS ]; then
    STATS=${OUTDIR}/qc.stats
fi
touch $STATS

while read -r sample; do
    if [[ "$sample" =~ ^SNYDER_HG19_ ]]; then
	sample=$sample
    else
	sample=${sample^^} # This will convert to uppercase
	if [[ "$sample" =~ ^[0-9]+ ]]; then # Correct HapMap names
	    sample="GM"$sample
	fi
	sample="SNYDER_HG19_${sample}"
    fi
    pref=${sample}_reconcile.dedup
    infile=${INDIR}/${pref}.bam
    outfile=${OUTDIR}/${pref}.pdf
    if [ ! -f $infile ]; then
	echo "Skipping $sample. Input file is missing." 1>&2; continue;
    fi
    if [ ! -s $outfile ]; then
	echo $sample
	bsub -J ${sample}_qc -e /dev/null -o /dev/null -q research-rh6 -W 24:00 -M 8192 -R "rusage[mem=8192]" "${MAYAROOT}/src/bin/qcSample.sh -i $infile -o $OUTDIR -s $STATS"
    else
	echo "Skipping $sample. Output file exists." 1>&2; continue;
    fi
done < "${LIST:-/proc/${$}/fd/0}"