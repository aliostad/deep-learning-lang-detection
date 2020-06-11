#!/bin/bash -login
### Job name
### Resources
#PBS -l nodes=1:ppn=5,walltime=05:00:00:00,mem=44gb
### Send email if the job encounters an error
#PBS –m a
### Output files to where you submitted your batch file
#PBS -e ./jobs/$PBS_JOBNAME.err
#PBS -o ./jobs/$PBS_JOBNAME.log
#PBS -j oe

# Change to working directory
cd $PBS_O_WORKDIR

# Load appropriate modules
module load Java/1.8.0_31
module load Python/3.3.2
module load FastQC/0.11.3
module load Trimmomatic/0.33
module load sickle/1.33
module load SAMTools/1.2
module load picardTools/1.113
module load GATK/3.7.0

# Execute via python script
python ./scripts/fastq2bam.py ${Var}

# Collect stats on run
qstat -f ${PBS_JOBID}

