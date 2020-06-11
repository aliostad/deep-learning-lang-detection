#!/bin/bash
#
#				2015-12-15
#				----------
#
# Following the advice in pyrad's tutorial, I will analyse merged and unmerged
# reads in parallel. I still need to join the two runs of each sample.
#

FASTQ='../2015-12-03/merged'
SAMPLE=(ZeroNotUsed St0001 St0003 St0006 St0015 St0016 St0019 St0037 St0039
         St0043 St0044 St0049 St0050 Bl0065 Bl0076 Bl0080 Bl0083
         Bl0104 Bl0108 Bl0091 Bl0093 Bl0094 Bl0095 Bl0098 Bl0116)

if [ ! -e pe ]; then mkdir pe; fi
if [ ! -e se ]; then mkdir se; fi

# The reads have barcodes and maybe adapter sequences as well in some cases. They
# have barcodes, while being demultiplexed, because I used both Illumina indexes
# and inline barcodes. Now, I can use SABRE to remove the barcodes and make sure
# that each file contains reads of only the correct sample. The barcodes are the
# following. Note that each barcode is reused three times.

if [ ! -d barcodes ]; then mkdir barcodes; fi

if [ ! -e barcodes/barcodes.txt ]; then
   echo 'AGCTA St0001' > barcodes/barcodes.txt
   echo 'TCGAG St0003' >> barcodes/barcodes.txt
   echo 'TAACCTG St0006' >> barcodes/barcodes.txt
   echo 'ACCGAGT St0015' >> barcodes/barcodes.txt
   echo 'TGGGTGCC St0016' >> barcodes/barcodes.txt
   echo 'GTCTTGCG St0019' >> barcodes/barcodes.txt
   echo 'CAATCC St0037' >> barcodes/barcodes.txt
   echo 'GTTCAA St0039' >> barcodes/barcodes.txt
   echo 'AGCTA St0043' >> barcodes/barcodes.txt
   echo 'TCGAG St0044' >> barcodes/barcodes.txt
   echo 'TAACCTG St0049' >> barcodes/barcodes.txt
   echo 'ACCGAGT St0050' >> barcodes/barcodes.txt
   echo 'TGGGTGCC Bl0065' >> barcodes/barcodes.txt
   echo 'GTCTTGCG Bl0076' >> barcodes/barcodes.txt
   echo 'CAATCC Bl0080' >> barcodes/barcodes.txt
   echo 'GTTCAA Bl0083' >> barcodes/barcodes.txt
   echo 'AGCTA Bl0104' >> barcodes/barcodes.txt
   echo 'TCGAG Bl0108' >> barcodes/barcodes.txt
   echo 'TAACCTG Bl0091' >> barcodes/barcodes.txt
   echo 'ACCGAGT Bl0093' >> barcodes/barcodes.txt
   echo 'TGGGTGCC Bl0094' >> barcodes/barcodes.txt
   echo 'GTCTTGCG Bl0095' >> barcodes/barcodes.txt
   echo 'CAATCC Bl0098' >> barcodes/barcodes.txt
   echo 'GTTCAA Bl0116' >> barcodes/barcodes.txt
fi

for i in `seq 1 24`; do
   if [ ! -e barcodes/${SAMPLE[$i]}_1_se_barcode.txt ] || [ ! -e barcodes/${SAMPLE[$i]}_1_pe_barcode.txt ]; then
      # These are the barcode data files required by SABRE, 4 per sample: (merged or unmerged)
      # times (run 1 or run 2). They specify the barcode and the output files for SABRE. If
      # paired-ends, two output files.
      grep ${SAMPLE[$i]} barcodes/barcodes.txt | gawk '{print $1 " " $2 "_1_se.fastq"}' > barcodes/${SAMPLE[$i]}_1_se_barcode.txt
      grep ${SAMPLE[$i]} barcodes/barcodes.txt | gawk '{print $1 " " $2 "_2_se.fastq"}' > barcodes/${SAMPLE[$i]}_2_se_barcode.txt
      grep ${SAMPLE[$i]} barcodes/barcodes.txt | gawk '{print $1 " " $2 "_1_pe_R1.fastq " $2 "_1_pe_R2.fastq"}' > barcodes/${SAMPLE[$i]}_1_pe_barcode.txt
      grep ${SAMPLE[$i]} barcodes/barcodes.txt | gawk '{print $1 " " $2 "_2_pe_R1.fastq " $2 "_2_pe_R2.fastq"}' > barcodes/${SAMPLE[$i]}_2_pe_barcode.txt
   fi
done

# To call SABRE in all 96 files, I will run them in groups of 6:
for i in 1 4 7 10 13 16 19 22; do
   for j in `seq $i $(( $i + 2 ))`; do
      if [ ! -e se/${SAMPLE[$j]}.fastq ] && [ ! -e ${SAMPLE[$j]}_1_se.fastq ]; then
         sabre se -m 1 -f $FASTQ/${SAMPLE[$j]}_1.assembled.fastq -b barcodes/${SAMPLE[$j]}_1_se_barcode.txt -u ${SAMPLE[$i]}_1_se_unknown.fastq &
         sabre se -m 1 -f $FASTQ/${SAMPLE[$j]}_2.assembled.fastq -b barcodes/${SAMPLE[$j]}_2_se_barcode.txt -u ${SAMPLE[$i]}_2_se_unknown.fastq &
      fi
   done
   wait
   for j in `seq $i $(( $i + 2 ))`; do
      if [ ! -e pe/${SAMPLE[$j]}_R1.fastq ] && [ ! -e ${SAMPLE[$i]}_1_pe_R1.fastq ]; then
         sabre pe -m 1 -c \
                  -f $FASTQ/${SAMPLE[$j]}_1.unassembled.forward.fastq \
                  -r $FASTQ/${SAMPLE[$j]}_1.unassembled.reverse.fastq \
                  -b barcodes/${SAMPLE[$j]}_1_pe_barcode.txt \
                  -u ${SAMPLE[$j]}_1_pe_unknown_R1.fastq \
                  -w ${SAMPLE[$j]}_1_pe_unknown_R2.fastq &
         sabre pe -m 1 -c \
                  -f $FASTQ/${SAMPLE[$j]}_2.unassembled.forward.fastq \
                  -r $FASTQ/${SAMPLE[$j]}_2.unassembled.reverse.fastq \
                  -b barcodes/${SAMPLE[$j]}_2_pe_barcode.txt \
                  -u ${SAMPLE[$j]}_2_pe_unknown_R1.fastq \
                  -w ${SAMPLE[$j]}_2_pe_unknown_R2.fastq &
      fi
   done
   wait
done

if [ ! -d unknown ]; then mkdir unknown; fi
for i in `seq 1 24`; do
   if [ ! -e se/${SAMPLE[$i]}.fastq ]; then
      cat ${SAMPLE[$i]}_1_se.fastq ${SAMPLE[$i]}_2_se.fastq > se/${SAMPLE[$i]}.fastq
      rm ${SAMPLE[$i]}_1_se.fastq ${SAMPLE[$i]}_2_se.fastq
   fi
   if [ -e ${SAMPLE[$i]}_1_se_unknown.fastq ] || [ -e ${SAMPLE[$i]}_2_se_unknown.fastq ]; then
      cat ${SAMPLE[$i]}_*_se_unknown.fastq > unknown/${SAMPLE[$i]}_se_unknown.fastq
      rm ${SAMPLE[$i]}_*_se_unknown.fastq
   fi
   if [ ! -e pe/${SAMPLE[$i]}_R1.fastq ]; then
      cat ${SAMPLE[$i]}_1_pe_R1.fastq ${SAMPLE[$i]}_2_pe_R1.fastq > pe/${SAMPLE[$i]}_R1.fastq
      cat ${SAMPLE[$i]}_1_pe_R2.fastq ${SAMPLE[$i]}_2_pe_R2.fastq > pe/${SAMPLE[$i]}_R2.fastq
      rm ${SAMPLE[$i]}_*_pe_R*.fastq
   fi
   if [ -e ${SAMPLE[$i]}_1_pe_unknown_R1.fastq ]; then
      # Here, I trust that the file name expansion respects the alfabetic order in both instances
      # so that pairs keep aligned in the output. I also assume that SABRE produced both reads of
      # a pair, when none of the barcodes is recognized.
      cat ${SAMPLE[$i]}_*_pe_unknown_R1.fastq > unknown/${SAMPLE[$i]}_pe_unknown_R1.fastq
      cat ${SAMPLE[$i]}_*_pe_unknown_R2.fastq > unknown/${SAMPLE[$i]}_pe_unknown_R2.fastq
      rm ${SAMPLE[$i]}_*_pe_unknown_R*.fastq
   fi
done

# Below, I count the number of lines in fastq files of paired ends, to make sure
# that the two files of the same pair have the same number of reads.
if [ ! -e PairedStats.txt ] || find . -newer PairedStats.txt | grep -q fastq; then
   echo -e "#Sample\tRun1_R1\tRun1_R2\tRun2_R1\tRun2_R2\tJoint_R1\tJoint_R2\tUnknown_R1\tUnknown_R2" > PairedStats.txt
   for i in `seq 1 24`; do
      printf "%s\t%u\t%u\t%u\t%u\t%u\t%u\t%u\t%u\n" ${SAMPLE[$i]} \
         `wc -l $FASTQ/${SAMPLE[$i]}_1.unassembled.forward.fastq | cut -d " " -f 1` \
         `wc -l $FASTQ/${SAMPLE[$i]}_1.unassembled.reverse.fastq | cut -d " " -f 1` \
         `wc -l $FASTQ/${SAMPLE[$i]}_2.unassembled.forward.fastq | cut -d " " -f 1` \
         `wc -l $FASTQ/${SAMPLE[$i]}_2.unassembled.reverse.fastq | cut -d " " -f 1` \
         `wc -l pe/${SAMPLE[$i]}_R1.fastq | cut -d " " -f 1` \
         `wc -l pe/${SAMPLE[$i]}_R2.fastq | cut -d " " -f 1` \
         `wc -l unknown/${SAMPLE[$i]}_pe_unknown_R1.fastq | cut -d " " -f 1` \
         `wc -l unknown/${SAMPLE[$i]}_pe_unknown_R2.fastq | cut -d " " -f 1` >> PairedStats.txt
   done
fi
