#!/bin/sh
output=$1
ff=$2
pph=$3
script_path=$4
GenomeBuild=$5
sample=$6
thread=$7
    cat $output/$ff.SNV.vcf | awk '$0 !~ /^#/' | awk '$5 !~ /,/' |awk '{print $1":"$2"\t"$4"/"$5}' > $output/$sample.SNV.poly
    $script_path/parallel.poly.pl $thread $output/$sample.SNV.poly $GenomeBuild $pph $output/$sample.SNV.poly.uniprot
    rm $output/$sample.SNV.poly
    uniprot=`awk '{ for(i=1;i<=NF;i++){ if ($i == "spacc") {print i} } }' $output/$sample.SNV.poly.uniprot`
    aa1=`awk '{ for(i=1;i<=NF;i++){ if ($i == "aa1") {print i} } }' $output/$sample.SNV.poly.uniprot`
    aa2=`awk '{ for(i=1;i<=NF;i++){ if ($i == "aa2") {print i} } }' $output/$sample.SNV.poly.uniprot`
    aapos=`awk '{ for(i=1;i<=NF;i++){ if ($i == "cdnpos") {print i} } }' $output/$sample.SNV.poly.uniprot`
    
    cat $output/$sample.SNV.poly.uniprot | awk 'NR>1' | awk -v a1=$aa1 -v a2=$aa2  -F '\t' '$a1 !~ $a2' |  awk -v uni=$uniprot 'length($uni)>1' | awk -v chr=$snp_pos -v uni=$uniprot -v a1=$aa1 -v a2=$aa2 -v pos=$aapos -F '\t' '{print $uni"\t"$pos"\t"$a1"\t"$a2}' > $output/$sample.SNV.poly.uniprot.in
    $script_path/split.pl $thread $output/$sample.SNV.poly.uniprot.in $GenomeBuild $pph $output/$sample.SNV.poly.uniprot.in.predict 
    rm $output/$sample.SNV.poly.uniprot.in
    perl $script_path/map.polyphen.pl $output/$sample.SNV.poly.uniprot $output/$sample.SNV.poly.uniprot.in.predict > $output/$sample.polyphen.txt 
    rm $output/$sample.SNV.poly.uniprot.in.predict
    rm $output/$sample.SNV.poly.uniprot
    echo " POLYPHEN is done "