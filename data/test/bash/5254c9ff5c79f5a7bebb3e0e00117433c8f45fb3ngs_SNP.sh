#!/bin/bash

# Copyright (c) 2012-2014, Stephen Fisher, Hoa Giang and Junhyong Kim, University of
# Pennsylvania.  All Rights Reserved.
#
# You may not use this file except in compliance with the Kim Lab License
# located at
#
#     http://kim.bio.upenn.edu/software/LICENSE
#
# Unless required by applicable law or agreed to in writing, this
# software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied.  See the License
# for the specific language governing permissions and limitations
# under the License.

##########################################################################################
# INPUT: list input files here
# OUTPUT: list output files here
# REQUIRES: list any external programs required to complete COMMAND function
##########################################################################################

# "TEMPLATE" is a place holder and should be replaced by the name of the command

##########################################################################################
# USAGE
##########################################################################################

NGS_USAGE+="Usage: `basename $0` snp OPTIONS sampleID -- run SNP calling and genome coverage on bowtie alignment\n"

##########################################################################################
# HELP TEXT
##########################################################################################

ngsHelp_SNP() {
	echo -e "Usage:\n\t`basename $0` snp [-i inputDir] -s species sampleID"
	echo -e "Input:\n\tsampleID/inputDir/sampleID.bowtie.sorted.bam"
	echo -e "Output:\n\tsampleID/snp/sampleID.filtered.vcf\n\tsampleID/snp/sampleID.bigWig"
	echo -e "Requires:\n\tfreebayes ( https://github.com/ekg/freebayes )\n\tbedtools ( http://bedtools.readthedocs.org/en/latest/ )\n\tKent sources ( http://genomewiki.ucsc.edu/index.php/Kent_source_utilities )"
	echo -e "Options:"
	echo -e "\t-i inputDir - directory with unaligned reads (default: bowtie)"
	echo -e "\t-s species - species from repository: $SNP_REPO\n"
	echo -e "Run SNP calling on the sorted bam file (ie sampleID/bowtie). Output is placed in the directory sampleID/snp."
}

##########################################################################################
# LOCAL VARIABLES WITH DEFAULT VALUES. Using the naming convention to
# make sure these variables don't collide with the other modules.
##########################################################################################

ngsLocal_SNP_INP_DIR="bowtie"

##########################################################################################
# PROCESSING COMMAND LINE ARGUMENTS
# SNP args: -r value, -chrSIZE value, sampleID
##########################################################################################

ngsArgs_SNP() {
	if [ $# -lt 3 ]; then printHelp "SNP"; fi
	
   	# getopts doesn't allow for optional arguments so handle them manually
	while true; do
		case $1 in
			-i) ngsLocal_SNP_INP_DIR=$2
				shift; shift;
				;;
			-s) SPECIES=$2
				shift; shift;
				;;
			-*) printf "Illegal option: '%s'\n" "$1"
				printHelp $COMMAND
				exit 0
				;;
			*) break ;;
		esac
	done
	
	SAMPLE=$1
}

##########################################################################################
# RUNNING COMMAND ACTION
# TEMPLATE command
##########################################################################################

ngsCmd_SNP() {
	prnCmd "# BEGIN: SNP CALLING AND GENOME COVERAGE"
	
    # make relevant directory
	if [ ! -d $SAMPLE/snp ]; then 
		prnCmd "mkdir $SAMPLE/snp"
		if ! $DEBUG; then mkdir $SAMPLE/snp; fi
	fi
	
    # print version info in $SAMPLE directory
	prnCmd "# freebayes version: freebayes | grep 'version:' | awk '{print \$2}' | sed s/v//"
	prnCmd "# bedtools version: bedtools --version | awk '{print \$2}' | sed s/v//"
	if ! $DEBUG; then 
		# gets this: "version:  v9.9.2-46-gdfddc43"
		# returns this: "9.9.2-46-gdfddc43"
		ver=$(freebayes | grep 'version:' | awk '{print $2}' | sed s/v//)
		bver=$(bedtools --version | awk '{print $2}' | sed s/v//)
		prnVersion "snp" "program\tversion\tprogram\tversion\tspecies" "freebayes\t$ver\tbedtools\t$bver\t$SPECIES"
	fi

	prnCmd "freebayes -f $SNP_REPO/$SPECIES.fa $SAMPLE/$ngsLocal_SNP_INP_DIR/$SAMPLE.bowtie.sorted.bam > $SAMPLE/snp/$SAMPLE.raw.vcf"
	if ! $DEBUG; then freebayes -f $SNP_REPO/$SPECIES.fa $SAMPLE/$ngsLocal_SNP_INP_DIR/$SAMPLE.bowtie.sorted.bam > $SAMPLE/snp/$SAMPLE.raw.vcf; fi
	prnCmd "vcffilter -f \"QUAL > 20\" $SAMPLE/snp/$SAMPLE.raw.vcf > $SAMPLE/snp/$SAMPLE.filtered.vcf"
	if ! $DEBUG; then vcffilter -f 'QUAL > 20' $SAMPLE/snp/$SAMPLE.raw.vcf > $SAMPLE/snp/$SAMPLE.filtered.vcf; fi
	
	prnCmd "bedtools genomecov -bga -ibam $SAMPLE/$ngsLocal_SNP_INP_DIR/$SAMPLE.bowtie.sorted.bam > $SAMPLE/snp/$SAMPLE.bedGraph"
	if ! $DEBUG; then bedtools genomecov -bga -ibam $SAMPLE/$ngsLocal_SNP_INP_DIR/$SAMPLE.bowtie.sorted.bam > $SAMPLE/snp/$SAMPLE.bedGraph; fi

	prnCmd "sort -k1,1 -k2,2n $SAMPLE/snp/$SAMPLE.bedGraph > $SAMPLE/snp/$SAMPLE.sorted.bedGraph"
	if ! $DEBUG; then sort -k1,1 -k2,2n $SAMPLE/snp/$SAMPLE.bedGraph > $SAMPLE/snp/$SAMPLE.sorted.bedGraph; fi	

	prnCmd "bedGraphToBigWig $SAMPLE/snp/$SAMPLE.sorted.bedGraph $SNP_REPO/$SPECIES.sizes $SAMPLE/snp/$SAMPLE.bigWig"
	if ! $DEBUG; then bedGraphToBigWig $SAMPLE/snp/$SAMPLE.sorted.bedGraph $SNP_REPO/$SPECIES.sizes $SAMPLE/snp/$SAMPLE.bigWig; fi

	prnCmd "bigWigToWig $SAMPLE/snp/$SAMPLE.bigWig $SAMPLE/snp/$SAMPLE.wig"
	if ! $DEBUG; then bigWigToWig $SAMPLE/snp/$SAMPLE.bigWig $SAMPLE/snp/$SAMPLE.wig; fi

	prnCmd "bedtools genomecov -d -ibam $SAMPLE/$ngsLocal_SNP_INP_DIR/$SAMPLE.bowtie.sorted.bam > $SAMPLE/snp/$SAMPLE.cov"
	if ! $DEBUG; then bedtools genomecov -d -ibam $SAMPLE/$ngsLocal_SNP_INP_DIR/$SAMPLE.bowtie.sorted.bam > $SAMPLE/snp/$SAMPLE.cov; fi		
	
	# run error checking
	if ! $DEBUG; then ngsErrorChk_SNP $@; fi

	prnCmd "# FINISHED: SNP CALLING AND GENOME COVERAGE"
}

##########################################################################################
# ERROR CHECKING. Make sure output files exist and are not empty.
##########################################################################################

ngsErrorChk_SNP() {
	prnCmd "# SNP ERROR CHECKING: RUNNING"

	inputFile="$SAMPLE/$ngsLocal_SNP_INP_DIR/$SAMPLE.bowtie.sorted.bam"
	outputFile_1="$SAMPLE/snp/$SAMPLE.bigWig"
	outputFile_2="$SAMPLE/snp/$SAMPLE.cov"

	# make sure expected output files exists
	if [[ ! -s $outputFile_1 || ! -s $outputFile_2 ]]; then
		errorMsg="Error with output files (don't exist or are empty).\n"
		errorMsg+="\tinput file: $inputFile\n"
		errorMsg+="\toutput file (sorted alignments): $outputFile_1\n"
		errorMsg+="\toutput file (unique alignments): $outputFile_2\n"
		prnError "$errorMsg"
	fi

	prnCmd "# SNP ERROR CHECKING: DONE"
}
