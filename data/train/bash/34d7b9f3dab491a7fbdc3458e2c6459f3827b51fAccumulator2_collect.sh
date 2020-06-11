#!/bin/sh
#Takes a single argument, the folder to be processed, which is expected to have a Trinity file to be processed.
#Trinity assemblies have come from a previous version of the script - see commented out Assembly section.

#############################################
#Load relevant modules 						#
#. /nas02/apps/Modules/default/init/bash		#
#module load python/2.7.1 					#
#module load bedtools 						#
#module load samtools 						#
#module load blast 							#
#module load blat 							#
#module load bedops 							#
#module load bowtie 							#
#module load bwa 							#
#############################################

DATA_DIR='/netscr/csoeder/1kGen/data'
SCRIPT_DIR='/netscr/csoeder/1kGen/v3.5'

#	$1 is the input junction seed. 
#	$2 is the RNA-Seq reads alignment file
#	$3 is the junctions BED file

touch old.bed

bedtools intersect -split -bed -wa -abam ../$2 -b $1 > new.bed

echo INTERSECTED 
cmp --silent old.bed new.bed || sh $SCRIPT_DIR/churning_collect.sh $2

mv new.bed Accumulation.bed


















