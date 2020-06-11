if [ $# -lt 5 ]
then
	echo -e "Usage:\n\tbash $0 <read1.fastq.gz> <read2.fastq.gz> <sampleID> <outdir> <# cores>";
	exit 0;
fi
read1=$1
read2=$2
sampleID=$3
outdir=$4
num_cores=$5
echo "Read1: $read1"
echo "Read2: $read2"
echo "SampleID: $sampleID"
echo "Outdir: $outdir"

#echo "#!/bin/bash" > submit.novo.$sampleID.sh
echo "#$ -cwd" > submit.novo.$sampleID.sh
echo "#$ -N novompi" >> submit.novo.$sampleID.sh
echo "#$ -V" >> submit.novo.$sampleID.sh
echo "#$ -o \$JOB_ID.\$JOB_NAME.out" >> submit.novo.$sampleID.sh
echo "#$ -e \$JOB_ID.\$JOB_NAME.err" >> submit.novo.$sampleID.sh
echo "#$ -pe mvapich2 $num_cores" >> submit.novo.$sampleID.sh
echo >> submit.novo.$sampleID.sh
#echo "/Apps/mvapich2/bin/mpiexec.hydra -np \$NSLOTS -hostfile \$TMPDIR/machines /Apps/NOVO/novo_3.00.05/novoalignMPI/novoalignMPI -d /home/saurabh/references/hg19_GATK_Ref.nidx -f $read1 $read2 -a -r All -o SAM \"@RG\\tID:default\\tPL:illumina\\tSM:$sampleID\\tPU:illumina\" > $outdir/$sampleID\\_NovoV3.00.05.sam" >> submit.novo.$sampleID.sh
echo "/Apps/mvapich2/bin/mpiexec.hydra -np \$NSLOTS -hostfile \$TMPDIR/machines /Apps/NOVO/novo_3.02.10d/novocraft/novoalignMPI -d /home/saurabh/references/hg19_GATK_Ref.nidx -f $read1 $read2 -a -r All -o SAM \"@RG\\tID:default\\tPL:illumina\\tSM:$sampleID\\tPU:illumina\" > $outdir/$sampleID\\_NovoV3.00.05.sam" >> submit.novo.$sampleID.sh

echo "Run from master node: qsub submit.novo.$sampleID.sh"
