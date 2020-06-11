#!/bin/bash

 
if [ $# -ne 3 ]; then
    echo "need three  arguments:"
    echo "1.  script path,  such as:  /home/scidb/variant_warehouse/load_tcga"
    echo "2.  geneFile, such as: /home/scidb/variant_warehouse/load_gene_37/tcga_python_pipe/newGene.tsv"
    echo "3. Date, such as: 2015_06_01"
    exit 1
fi

current_wd=$1
gene_file=$2
DATE=$3

logfile=${current_wd}/loader_log.txt
rm -f ${logfile}
exec > >(tee ${logfile})
exec 2>&1

bash  $1/tcga_array_initialization.sh $1
m_gene_file=$1/gene_symbol_as_id.tsv
gene_tmp_file1=$1/gene_tmp.tsv
gene_tmp_file2=$1/gene_tmp2.tsv
python gene_symbol_as_geneID.py ${gene_file} ${gene_tmp_file1} ${gene_tmp_file2} ${m_gene_file}

# rm -f ${gene_tmp_file1}
# rm -f ${gene_tmp_file2}
# rm -f ${m_gene_file}


# load gene list 
bash $1/load_gene.sh ${DATE} ${m_gene_file}

echo "start protein loading @: `date`"
  for tumor_type in `cat tumor_type.tsv`; do
    bash $1/load_protein_exp.sh ${DATE} $tumor_type ${current_wd} ${gene_file}
  done
echo "finished protein loading @: `date`"

echo "start loading mutation data @ `date`"
bash $1/load_mutation_data.sh $3 $1 ACC 39 40
bash $1/load_mutation_data.sh $3 $1 BLCA 40 42
bash $1/load_mutation_data.sh $3 $1 BRCA 49 50
bash $1/load_mutation_data.sh $3 $1 CESC 49 50
bash $1/load_mutation_data.sh $3 $1 CHOL 39 40
bash $1/load_mutation_data.sh $3 $1 COAD 35 36
bash $1/load_mutation_data.sh $3 $1 GBM 40 42
bash $1/load_mutation_data.sh $3 $1 HNSC 40 42
bash $1/load_mutation_data.sh $3 $1 KICH 40 42
bash $1/load_mutation_data.sh $3 $1 KIRC 39 40
bash $1/load_mutation_data.sh $3 $1 KIRP 39 40
bash $1/load_mutation_data.sh $3 $1 LAML 49 50
bash $1/load_mutation_data.sh $3 $1 LGG 49 50
bash $1/load_mutation_data.sh $3 $1 LIHC 39 40
bash $1/load_mutation_data.sh $3 $1 LUAD 40 42
bash $1/load_mutation_data.sh $3 $1 LUSC 40 42
bash $1/load_mutation_data.sh $3 $1 OV 40 42
bash $1/load_mutation_data.sh $3 $1 PAAD 40 42
bash $1/load_mutation_data.sh $3 $1 PCPG 40 42
bash $1/load_mutation_data.sh $3 $1 PRAD 40 42
bash $1/load_mutation_data.sh $3 $1 READ 35 36
bash $1/load_mutation_data.sh $3 $1 SARC 49 50
bash $1/load_mutation_data.sh $3 $1 SKCM 40 42
bash $1/load_mutation_data.sh $3 $1 STAD 40 42

bash $1/load_mutation_data.sh $3 $1 TGCT 39 40
bash $1/load_mutation_data.sh $3 $1 STES 40 42


bash $1/load_mutation_data.sh $3 $1 THCA 40 42

# no field of cDNA pos for UCEC; using out of range field 100
bash $1/load_mutation_data.sh $3 $1 UCEC 100 38

bash $1/load_mutation_data.sh $3 $1 UCS 40 42
bash $1/load_mutation_data.sh $3 $1 UVM 40 42

bash $1/load_mutation_data.sh $3 $1 COADREAD 35 36
bash $1/load_mutation_data.sh $3 $1 GBMLGG 40 42
bash $1/load_mutation_data.sh $3 $1 KIPAN 39 40


echo "finished loading mutation data @`date`"


echo "start mirnaseq loading @: `date`"
  for tumor_type in `cat tumor_type.tsv`; do
    bash $1/load_mirna.sh ${DATE} $tumor_type ${current_wd} ${gene_file}
  done
echo "finished mirnaseq loading @: `date`"



echo "start RNA seq loading @: `date`"
  for tumor_type in `cat tumor_type.tsv`; do
    bash $1/load_RNAseq_raw.sh ${DATE} $tumor_type ${current_wd} ${gene_file}
  done
echo "finished RNA seq loading @: `date`"


echo "start RNA seq loading @: `date`"
  for tumor_type in `cat tumor_type.tsv`; do
    bash $1/load_RNAseqV2_v2.sh ${DATE} $tumor_type ${current_wd} ${gene_file}
  done
echo "finished RNA v2 seq loading @: `date`"


echo "start cnv data loading @ `date`"
for tumor_type in `cat tumor_type.tsv`; do
  bash $1/load_cnv.sh $3 $tumor_type $1 $2
done
echo "finished loading cnv data @ `date`"


echo "start clinical data loading @ `date`"
for tumor_type in `cat tumor_type.tsv`; do
  bash $1/load_clinical_data.sh $3 $tumor_type $1
done
echo "finished loading clinical data @ `date`"
 
 
 echo "start methylation loading @: `date`"
   for tumor_type in `cat tumor_type.tsv`; do
     bash $1/load_methylation.sh $3 $tumor_type $1
   done
 echo "finished methylation loading @: `date`"


