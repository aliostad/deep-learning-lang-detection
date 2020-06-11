#!/bin/bash

ROOT=$HOME
src=$ROOT/../local/home/DValenzano/shared/personal/DValenzano


# #
# # Plate 5
# #

process_radtags -p $src/plate5/ \
                -b $src/barcodes/plate5_barcodes_2 \
                -o $src/samples/plate5/ -i fastq -y fastq -c -q -r -e sbfI -E phred33
mv $src/samples/plate5/process_radtags.log $src/samples/plate5/plate5_2.log 
#mv $src/samples/plate5/sample_AAACGG $src/samples/plate5/z701F.fq
#mv $src/samples/plate5/sample_AACGTT $src/samples/plate5/z5R18d.fq
#mv $src/samples/plate5/sample_AACTGA $src/samples/plate5/z5Y06F.fq
#mv $src/samples/plate5/sample_AAGACG $src/samples/plate5/z7012F1.fq
#mv $src/samples/plate5/sample_AAGCTA $src/samples/plate5/1AA2F0051.fq
#mv $src/samples/plate5/sample_AATATC $src/samples/plate5/1AA2M0117.fq
#mv $src/samples/plate5/sample_AATGAG $src/samples/plate5/z1018d.fq
#mv $src/samples/plate5/sample_ACAAGA $src/samples/plate5/G299.fq
#mv $src/samples/plate5/sample_ACAGCG $src/samples/plate5/G262.fq
#mv $src/samples/plate5/sample_ACATAC $src/samples/plate5/z708f2.fq
#mv $src/samples/plate5/sample_ACCATG $src/samples/plate5/G212.fq
#mv $src/samples/plate5/sample_ACCCCC $src/samples/plate5/4aa2m0014.fq
#mv $src/samples/plate5/sample_ACTCTT $src/samples/plate5/z711D.fq
#mv $src/samples/plate5/sample_ACTGGC $src/samples/plate5/z5R07F.fq
#mv $src/samples/plate5/sample_AGCCAT $src/samples/plate5/z5Y08F.fq
#mv $src/samples/plate5/sample_AGCGCA $src/samples/plate5/z6014F.fq
#mv $src/samples/plate5/sample_AGGGTC $src/samples/plate5/1AA2M0053.fq
#mv $src/samples/plate5/sample_AGGTGT $src/samples/plate5/1AA2F0056.fq
#mv $src/samples/plate5/sample_AGTAGG $src/samples/plate5/z104F.fq
#mv $src/samples/plate5/sample_AGTTAA $src/samples/plate5/G104.fq
#mv $src/samples/plate5/sample_ATAGTA $src/samples/plate5/G272.fq
#mv $src/samples/plate5/sample_ATCAAA $src/samples/plate5/G172.fq
#mv $src/samples/plate5/sample_ATGCAC $src/samples/plate5/ADBELL.fq
#mv $src/samples/plate5/sample_ATGTTG $src/samples/plate5/ck1005R_050812.fq
#mv $src/samples/plate5/sample_ATTCCG $src/samples/plate5/z5_16d.fq
#mv $src/samples/plate5/sample_CAAAAA $src/samples/plate5/z5R011.fq
#mv $src/samples/plate5/sample_CAATCG $src/samples/plate5/z5Y01F.fq
#mv $src/samples/plate5/sample_CACCTC $src/samples/plate5/z6009F.fq
#mv $src/samples/plate5/sample_CAGGCA $src/samples/plate5/3AA2M0087.fq
#mv $src/samples/plate5/sample_CATACT $src/samples/plate5/1AA2M0023.fq
#mv $src/samples/plate5/sample_CCATTT $src/samples/plate5/z1017d.fq
#mv $src/samples/plate5/sample_CCCGGT $src/samples/plate5/G107.fq
#mv $src/samples/plate5/sample_CCCTAA $src/samples/plate5/G282.fq
#mv $src/samples/plate5/sample_CCGAGG $src/samples/plate5/G144.fq
#mv $src/samples/plate5/sample_CCGCAT $src/samples/plate5/Daniel1.fq
#mv $src/samples/plate5/sample_CCTAAC $src/samples/plate5/paul1.fq
#mv $src/samples/plate5/sample_CGAGGC $src/samples/plate5/z1015d.fq
#mv $src/samples/plate5/sample_CGCAGA $src/samples/plate5/z5R03F.fq
#mv $src/samples/plate5/sample_CGCGTG $src/samples/plate5/Z5Y05F.fq
#mv $src/samples/plate5/sample_CGGTCC $src/samples/plate5/z6015d.fq
#mv $src/samples/plate5/sample_CGTCTA $src/samples/plate5/5AA2F0074.fq
#mv $src/samples/plate5/sample_CGTGAT $src/samples/plate5/3AA2M0044.fq
#mv $src/samples/plate5/sample_CTACAG $src/samples/plate5/z208F1.fq
#mv $src/samples/plate5/sample_CTCGCC $src/samples/plate5/G138.fq
#mv $src/samples/plate5/sample_CTGCGA $src/samples/plate5/G292.fq
#mv $src/samples/plate5/sample_CTGGTT $src/samples/plate5/1aa2m0062.fq
#mv $src/samples/plate5/sample_CTTATG $src/samples/plate5/Danielle1.fq
#mv $src/samples/plate5/sample_CTTTGC $src/samples/plate5/Josephine 1.fq
#mv $src/samples/plate5/sample_GAAATG $src/samples/plate5/z102f.fq
#mv $src/samples/plate5/sample_GAACCA $src/samples/plate5/z5R09F.fq
#mv $src/samples/plate5/sample_GACGAC $src/samples/plate5/z5Y02F.fq
#mv $src/samples/plate5/sample_GACTCT $src/samples/plate5/z6006d.fq
#mv $src/samples/plate5/sample_GAGAGA $src/samples/plate5/1AA2M0049.fq
#mv $src/samples/plate5/sample_GATCGT $src/samples/plate5/G174.fq
#mv $src/samples/plate5/sample_GCAGAT $src/samples/plate5/z212d.fq
#mv $src/samples/plate5/sample_GCATGG $src/samples/plate5/G163.fq
#mv $src/samples/plate5/sample_GCCGTA $src/samples/plate5/G320.fq
#mv $src/samples/plate5/sample_GCGACC $src/samples/plate5/G454.fq
#mv $src/samples/plate5/sample_GCGCTG $src/samples/plate5/D4.fq
#mv $src/samples/plate5/sample_GCTCAA $src/samples/plate5/G399.fq
#mv $src/samples/plate5/sample_GGACTT $src/samples/plate5/z103f.fq
#mv $src/samples/plate5/sample_GGCAAG $src/samples/plate5/z521d.fq
#mv $src/samples/plate5/sample_GGGCGC $src/samples/plate5/z709F1.fq
#mv $src/samples/plate5/sample_GGGGCG $src/samples/plate5/z6010d.fq
#mv $src/samples/plate5/sample_GGTACA $src/samples/plate5/1AA2F0049.fq
#mv $src/samples/plate5/sample_GGTTTG $src/samples/plate5/G264.fq
#mv $src/samples/plate5/sample_GTAAGT $src/samples/plate5/z202F.fq
#mv $src/samples/plate5/sample_GTATCC $src/samples/plate5/G169.fq
#mv $src/samples/plate5/sample_GTCATC $src/samples/plate5/G332.fq
#mv $src/samples/plate5/sample_GTGCCT $src/samples/plate5/z1019d.fq
#mv $src/samples/plate5/sample_GTGTAA $src/samples/plate5/Paul2a.fq
#mv $src/samples/plate5/sample_GTTGGA $src/samples/plate5/G415.fq
#mv $src/samples/plate5/sample_TAAGCT $src/samples/plate5/g245.fq
#mv $src/samples/plate5/sample_TAATTC $src/samples/plate5/z5014F.fq
#mv $src/samples/plate5/sample_TACACA $src/samples/plate5/z707F1.fq
#mv $src/samples/plate5/sample_TACGGG $src/samples/plate5/z6012F.fq
#mv $src/samples/plate5/sample_TAGTAT $src/samples/plate5/1AA2M0121.fq
#mv $src/samples/plate5/sample_TATCAC $src/samples/plate5/G164.fq
#mv $src/samples/plate5/sample_TCAAAG $src/samples/plate5/z211F1.fq
#mv $src/samples/plate5/sample_TCCTGC $src/samples/plate5/G188.fq
#mv $src/samples/plate5/sample_TCGATT $src/samples/plate5/Z2014F2.fq
#mv $src/samples/plate5/sample_TCGCCA $src/samples/plate5/G280.fq
#mv $src/samples/plate5/sample_TCGGAC $src/samples/plate5/zmz1005Rf4F.fq
#mv $src/samples/plate5/sample_TCTCGG $src/samples/plate5/G457.fq
#mv $src/samples/plate5/sample_TGAACC $src/samples/plate5/z5013F.fq
#mv $src/samples/plate5/sample_TGACAA $src/samples/plate5/z7010F1.fq
#mv $src/samples/plate5/sample_TGCCCG $src/samples/plate5/1AA2F0004.fq
#mv $src/samples/plate5/sample_TGCTTA $src/samples/plate5/3AA2M0018.fq
#mv $src/samples/plate5/sample_TGGGGA $src/samples/plate5/G41.fq
#mv $src/samples/plate5/sample_TTATGA $src/samples/plate5/z213d.fq
#mv $src/samples/plate5/sample_TTCCGT $src/samples/plate5/G243.fq
#mv $src/samples/plate5/sample_TTCTAG $src/samples/plate5/G345.fq
#mv $src/samples/plate5/sample_TTGAGC $src/samples/plate5/G166.fq
#mv $src/samples/plate5/sample_TTTAAT $src/samples/plate5/z6019.fq
#mv $src/samples/plate5/sample_TTTGTC $src/samples/plate5/G85.fq
mv $src/samples/plate5/sample_CGATA $src/samples/plate5/Joseph1.fq
mv $src/samples/plate5/sample_CGGCG $src/samples/plate5/Joseph2a.fq
mv $src/samples/plate5/sample_TAATG $src/samples/plate5/1002J1xJ2.fq
mv $src/samples/plate5/sample_TAGCA $src/samples/plate5/z210F1.fq
