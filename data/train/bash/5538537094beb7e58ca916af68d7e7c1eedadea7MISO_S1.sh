module load python/2.7.5 intel-comp/12.1.3 intel-mkl/11.0u1
module load bowtie2
module load bowtie
module load bamtools
module load tophat
module load bedtools
module load samtools

#script for running MISO
#might not work properly

miso \
--run /scratch/DCS/CANBIO/gseed/Reference_Genomes/ensgenes/miso_indexed /scratch/DCS/CANBIO/wyuan/ngs/3.analysis/Project_A001/SPLI_0001/SPLI_0001.sort.bam \
--output-dir /scratch/DCS/CANBIO/gseed/Processed_Data/MISO/Project_A001/Sample_1 \
--read-len 100 \
--paired-end 170 50 
			
		