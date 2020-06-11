#!/bin/bash

# this script creates the kinship matrix
# USE: interrupt_kin_step2.sh <sample_list>

file=${1}
dir=/lscr2/andersenlab/kml436/git_repos2/Transposons2/data
new_positions=/lscr2/andersenlab/kml436/git_repos2/Transposons2/kintest/TE_matrix/cleaned_positions_new.gff
reference_positions=/lscr2/andersenlab/kml436/git_repos2/Transposons2/kintest/TE_matrix/cleaned_positions_reference.gff
absent_positions=/lscr2/andersenlab/kml436/git_repos2/Transposons2/kintest/TE_matrix/cleaned_positions_absent.gff


sed -e '/^#/d' -e '/^$/d' $file > tmp && mv tmp $file
# use bedtools window with -w 25 to extend gene by 25 base pairs on either side
while read -r sample
do
	bedtools window -a $new_positions -b ${dir}/${sample}/final_results/${sample}_temp_insertion_nonredundant.bed -w 25 >intermediateA.txt
	cat intermediateA.txt | awk -v sample="$sample" '{print sample"\tinsertion\t"$0}' >> insertions_bedt.txt
	bedtools window -a $absent_positions -b ${dir}/${sample}/final_results/${sample}_temp_absence_nonredundant.bed -w 25 >intermediateB.txt
	cat intermediateB.txt | awk -v sample="$sample" '{print sample"\tabsence\t"$0}' >> absences_bedt.txt
	bedtools window -a $reference_positions -b ${dir}/${sample}/final_results/${sample}_telocate_nonredundant.bed -w 25 >intermediateC.txt
	cat intermediateC.txt | awk -v sample="$sample" '{print sample"\treference\t"$0}' >> references_bedt.txt

done < "${file}"

#cat insertions_into_genes.txt absences_from_genes.txt references_in_genes.txt > all_gene_insertions_and_excisions.txt