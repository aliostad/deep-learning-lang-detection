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
    if [ ! -f $infile ]; then
	echo "Skipping $sample. Input file is missing." 1>&2; continue;
    fi
    if [ ! -s ${outpref}.recal.bam ]; then
	bsub -J ${sample}_qc -e /dev/null -o /dev/null -q research-rh6 -W 24:00 -M 8192 -R "rusage[mem=8192]" "${MAYAROOT}/src/bin/qcSample.sh -i $infile -o $OUTDIR -s $STATS"
    else
	echo "Skipping $sample. Output file exists." 1>&2; continue;
    fi
done < "${LIST:-/proc/${$}/fd/0}"