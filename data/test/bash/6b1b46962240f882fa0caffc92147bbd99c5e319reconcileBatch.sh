#!/bin/bash

usage()
{
cat <<EOF
usage: `basename $0` options
Calls reconcileSample for several samples
OPTIONS:
   -h     Show this message and exit
   -i DIR [Required] Input directory.
   -o DIR [Required] 
   -l STR List of samples. If not provided, it will read from STDIN.
   -s STR Source file
   -c     Overwrite [0]
   -r     RNA
EOF
}

CLEAN='-c'
RNA=0
INDIR=
OUTDIR=
LIST=
while getopts "hi:o:l:s:cr" opt
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
	    SFILE=$OPTARG;;
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

source ${SFILE}
while read -r sample fq2 ; do
    #if [[ "$sample" =~ ^SNYDER_HG19_ ]]; then
    #	sample=$sample
    #else
    #    sample=${sample^^} # This will convert to uppercase
    #	if [[ "$sample" =~ ^[0-9]+ ]]; then # Correct HapMap names
    #	    sample="GM"$sample
    #	fi
    #	sample="SNYDER_HG19_${sample}"
    #fi
    sample=$sample
    inpref=${INDIR}/${sample}
    echo $sample
    echo ${inpref}
    echo ${inpref}_maternal.bam
    if [[ ( ! -s ${inpref}_maternal.bam ) || ( ! -s ${inpref}_paternal.bam ) ]]; then
	echo "Skipping $sample. Maternal and/or paternal bam file missing." 1>&2; continue;
    fi

    if [[ $RNA -eq 1 ]]; then
	nopt="-n"
	final=${OUTDIR}/dedup/nsort/${sample}_reconcile.dedup.bam
    else
	nopt=""
	final=${OUTDIR}/dedup/${sample}_reconcile.dedup.bam
    fi

    if [[ $fq2 == "NA" ]]; then
	single="-s"
    else
	single=""
    fi

    if [[ $CLEAN == "-c" || ! -f  $final ]]; then
	echo ${CODEDIR}new_ase_code/bin/reconcileSample.sh --ind $INDIR --outdir $OUTDIR --sample ${sample} --sfile ${SFILE} $CLEAN $nopt $single > ${OUTDIR}/${sample}_reconcile_script.sh
	chmod 711 ${OUTDIR}/${sample}_reconcile_script.sh
	qsub -l h_vmem=20G -l h_rt=20:00:00 -e ${OUTDIR}/${sample}_reconcile_script.sh.err -o ${OUTDIR}/${sample}_reconcile_script.sh.o ${OUTDIR}/${sample}_reconcile_script.sh
    else
    	echo "Skipping $sample. Output file exists." 1>&2; continue;
    fi
done < "${LIST:-/proc/${$}/fd/0}"
