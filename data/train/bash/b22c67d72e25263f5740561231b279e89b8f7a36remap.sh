#!/bin/bash
#$ -cwd


# remap reads:
# 1. convert recalibrated BAMs to fastq 
# 2. bwa sampe 
# 3. realign 

heap=4 # default heap

# step 1. BAM to fastq

USAGE="Usage: $0 "

while getopts b:s:m:h opt
  do      
  case "$opt" in
      b) bam="$OPTARG";;
      m) mem="$OPTARG";;
      s) setting="$OPTARG";;
      h)    echo $USAGE
          exit 1;;
  esac
done

if [[ $bam == "" || $setting == "" ]]; then
    echo $USAGE
    exit 1
fi

. $setting 

if [[ ! $mem == ""  ]]; then
    heap=$mem
fi

# get sampleName
sampleName=`$SAMTOOLS view -H $bam | grep '^@RG' |  sed 's/\s/\n/g' | grep '^SM:' | cut -f2 -d ':' | sort -u`


if [[ $sampleName == ""  ]]; then # no interested sample
    echo "no sample of interest"
    exit 1
else
    echo $sampleName
fi

# first, samtofastq
echo "${BPATH}/samtofastq.sh  -b $bam -p $sampleName -g $setting"
sh ${BPATH}/samtofastq.sh  -b $bam -p $sampleName -g $setting -m $heap  ## setting is only useful to get programs, not $REF



# then, map 
echo "${BPATH}/mapping.sh -r $REF -i $sampleName"_1.fastq" -p $sampleName"_2.fastq" -n $sampleName -o $sampleName.sorted.bam"

sh ${BPATH}/mapping.sh -r $REF -i $sampleName"_1.fastq" -p $sampleName"_2.fastq" -n $sampleName -o $sampleName.sorted

# delete fastq files to save space
rm -f $sampleName"_1.fastq" $sampleName"_2.fastq"

# bzip2 $sampleName"_1.fastq" $sampleName"_2.fastq"

OUTDIR=$sampleName".sorted.bam_pipe"
if [ ! -d $OUTDIR ]; then
    mkdir $OUTDIR
fi  

status=$OUTDIR"/realign.status"

if [ -e $status ] ; then
    rm -f $status
fi

touch $status

## use more RAM to prevent too many jobs running at the same time. 
qmem=5 # default
heapm=4
for (( i=1; i<=24; i++ ))
  do 
  if [[ $i -lt 7 ]]; then  # mem=8 for large chr
      qmem=8
      heapm=7
  fi
  
  echo "qsub -N realign.$sampleName.$i -l mem=${qmem}G,time=48:: -o $OUTDIR/log.$i.realign.o -e $OUTDIR/log.$i.realign.e ${BPATH}/gatk_realign_atomic.scr -I $sampleName.sorted.bam  -g $setting -L $i -c $status -m $heapm"
  qsub -N realign.$sampleName.$i -l mem=${qmem}G,time=48:: -o $OUTDIR/log.$i.realign.o -e $OUTDIR/log.$i.realign.e ${BPATH}/gatk_realign_atomic.scr -I $sampleName.sorted.bam  -g $setting -L $i -c $status -m  $heapm
done

