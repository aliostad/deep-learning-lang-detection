#Example of trimming adapters
java -jar /usr/local/bin/trimmomatic-0.30.jar PE -trimlog Sample_DR10/DR10_ACTTGA_L003.trimlog Sample_DR10/DR10_ACTTGA_L003*R1*gz Sample_DR10/DR10_ACTTGA_L003*R2*gz Sample_DR10/DR10_ACTTGA_L003.s1_pe Sample_DR10/DR10_ACTTGA_L003.s1_se Sample_DR10/DR10_ACTTGA_L003.s2_pe Sample_DR10/DR10_ACTTGA_L003.s2_se ILLUMINACLIP:/home/ubuntu/Trimmomatic-0.30/adapters/TruSeq2-PE.fa:2:30:10 2> Sample_DR10/DR10_ACTTGA_L003.trimcounts 1> Sample_DR10/DR10_ACTTGA_L003.trimcounts2

#Example of merging paired ends
/home/ubuntu/pandaseq/pandaseq -f Sample_DR10/DR10_ACTTGA_L003.s1_pe -r Sample_DR10/DR10_ACTTGA_L003.s2_pe -F -d rbkms -u Sample_DR10/DR10_ACTTGA_L003_unassembled.fa 2> Sample_DR10/DR10_ACTTGA_L003.assembled_stat.txt 1> Sample_DR10/DR10_ACTTGA_L003_assembled.fastq
