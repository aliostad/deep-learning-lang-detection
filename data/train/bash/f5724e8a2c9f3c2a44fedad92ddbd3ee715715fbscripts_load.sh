#!/bin/sh
rm indexes/*
rm constraints/*
rm triggers/*
rm *.log *.bad

cd $LOAD/arrays
rm *.log
rm *.bad
echo "Loading Array Staging tables"
time sh sql_ldr_arrays_g.sh $1 1>arrayLoad.log 2>&1 

mail -s "ARRAY Staging Log " $EMAIL < $LOAD/arrays/arrayLoad.log 

cd $LOAD/snp
echo "Loading dbSNP Data"
rm *.bad *.log
time sh NCBI_SNPData_SQLLdr_DataLoader.sh $1 1>snp_load.log 2>&1 &

cd $LOAD/protein
echo "Loading  Uniprot PROTEIN_* objects"
rm *.bad *.log
time sh UniprotProtein_SQLLdr_DataLoader.sh $1 1> protein_load.log 2>&1 &

cd $LOAD/unigene/gene 
echo "Loading gene, Unigene, Clone and UnigeneTmpData"
rm *.bad *.log
time sh geneTv_sqlldr.sh $1 1>geneTv_load.log 2>&1 

cd $LOAD/unigene/nas 
echo "Loading nucleicacidsequence (Unigene)"
time sh nas_sqlldr.sh $1 1>nas_load.log 2>&1 &

cd $LOAD/unigene/clone 
echo "Loading clone, clone_relative_location (Unigene)"
time sh cloneTables_sqlldr.sh $1 1>cloneTables_load.log 2>&1 &

cd $LOAD/unigene/unigeneTempData 
echo "Loading unigene2gene, etc."
time sh unigene_sqlldr.sh $1 1>unigene_sqlldr.log 2>&1 &

cd $LOAD/unigene2gene 
echo "Loading zstg_gene2unigene, zstg_omim2gene, zstg_gene2accession and other Entrez-Id mapping tables"
rm *.bad *.log
time sh unigene2gene_sqlldr.sh $1 1>unigene2gene_load.log 2>&1 &

cd $LOAD/relative_clone
echo "Loading EST and mRNA Staging tables (UCSC)"
rm *.bad *.log
time sh all_est_mrna_sqlldr.sh $1 1>estmrna_load.log 2>&1 &


wait
cd $LOAD/unigene/unigeneTempData/
#Add Entrez data in Gene, NucleicAcidSequence and update HUGO Symbol
echo "loading entrez)"
rm *.bad *.log
time sh entrez_load.sh $1 1>entrez.log 2>&1 &

cd $LOAD/cytoband
echo "Loading cytobands (UCSC)"
rm *.bad *.log
time sh Cytoband_SQLLdr_DataLoader.sh $1 1>cytoband_load.log 2>&1 

cd $LOAD/marker
echo "Loading UniSTS Marker Data"
rm *.bad *.log
time sh markerLoad.sh $1 1>marker_load.log 2>&1 &

wait
mail -s "dbSNP Load log" $EMAIL < $LOAD/snp/snp_load.log
mail -s "Entrez Load log" $EMAIL < $LOAD/unigene/unigeneTempData/entrez.log
mail -s "Uniprot Protein Load log" $EMAIL < $LOAD/protein/protein_load.log
mail -s "UniSTS Marker load Log " $EMAIL < $LOAD/marker/marker_load.log 
mail -s "UCSC cytoband Load Log " $EMAIL < $LOAD/cytoband/cytoband_load.log 
mail -s "UCSC est mrna Log " $EMAIL < $LOAD/relative_clone/estmrna_load.log 
mail -s "Unigene nas Log " $EMAIL < $LOAD/unigene/nas/nas_load.log 
mail -s "Unigene Gene Log " $EMAIL < $LOAD/unigene/gene/geneTv_load.log 
mail -s "NCBI Unigene2Gene Log " $EMAIL < $LOAD/unigene2gene/unigene2gene_load.log 
mail -s "Unigene Clone Log " $EMAIL < $LOAD/unigene/clone/cloneTables_load.log 
mail -s "Unigene tempdata Log " $EMAIL < $LOAD/unigene/unigeneTempData/unigene_sqlldr.log 


cd $LOAD/dbcrossref
echo "Loading database_cross_reference"
time sh DatabaseCrossReference.sh $1 1>dbCrossRef.log 2>&1 &

cd $LOAD/homologene
echo "Loading homologous_association (CGAP)"
time sqlplus $1 @homoloGene_ld.sql 1>homoloGene.log 2>&1 &

#Add Entrez here
cd $LOAD/GO
echo "Loading gene_ontology tables (GO, CGAP)"
time sqlplus $1 @loadGo.sql 1>GO.log 2>&1 & 

#Add associations to Protein
cd $LOAD/sql
echo "Loading gene_protein_tv association"
time sqlplus $1 @Gene_Protein_TV_LD.sql 1>sqlLoad.log 2>&1 &

cd $LOAD/sql
echo "Loading gene_organontology table"
time sqlplus $1 @gene_organontology.sql 1>>sqlLoad.log 2>&1 &

#Add Entrez here
cd $LOAD/sql
echo "Loading PATHWAYS tables (BioCarta)"
time sqlplus $1 @loadPathways.sql 1>>sqlLoad.log 2>&1 

#Add Entrez here
cd $LOAD/sql
echo "Loading Gene-Alias tables"
time sqlplus $1 @geneAlias_ld.sql 1>>sqlLoad.log 2>&1 

wait

mail -s "Misc SQL Load Log " $EMAIL < $LOAD/sql/sqlLoad.log 
mail -s "GO Load Log " $EMAIL < $LOAD/GO/GO.log 
mail -s "Homologene Load Log " $EMAIL < $LOAD/homologene/homoloGene.log 
mail -s "DatabaseCrossReference Log " $EMAIL < $LOAD/dbcrossref/dbCrossRef.log 
#mail -s "PID (not related to model) Log " $EMAIL < $LOAD/pid/pidLoader.log 

cd $LOAD/location
echo "Loading LOCATION tables (Part 1)"
rm *.bad *.log
time sh locationLoad.sh $1 1>locationLoad.log 2>&1 &

cd $LOAD/histopathology
echo "Loading gene-histopathology tables"
time sh hist_update.sh $1 1>histLoad.log 2>&1 &

cd $CABIO_DIR/scripts/sql_loader/arrays
echo "Loading arrayreporter (snp reporter, expression array reporter, etc.) tables"
rm *.bad *.log
time sh load.sh $1 1>Array_PLSQL_Ld.log 2>&1 &

cd $LOAD/cgdc
echo "Loading cancer-gene-index data"
rm *.bad *.log
time sh cgdc_sqlldr.sh $1 1>cgdcLoad.log 2>&1 &

wait

cd $LOAD/pid_dump 
echo "Loading PID tables (PID Dump)"
time sh pidLoader.sh $1 1>pidLoader.log 2>&1 

mail -s "Histopathology Load Log " $EMAIL < $LOAD/histopathology/histLoad.log 
mail -s "ArrayReporter, etc. Load Log " $EMAIL < $LOAD/arrays/Array_PLSQL_Ld.log 
mail -s "Cancer Gene Data Curation Load Log " $EMAIL < $LOAD/cgdc/cgdcLoad.log 
mail -s "PID Dump Load Log " $EMAIL < $LOAD/pid_dump/pidLoader.log 

echo "Finished Load P4 " 

cd $LOAD/provenance
echo "Loading provenance, source_reference, url_source_reference tables"
rm *.bad *.log
time sh provenance_DataLoader.sh $1 1>provenance_load.log 2>&1 &

time sqlplus $1  @$LOAD/keywords/keyword_load.sql &

cd $CABIO_DIR/scripts/sql_loader/arrays
echo "Starting post big id load -> arrays (array reporter class hierarchy tables)"
time sh post_bigid_load.sh $1 1>postbigid.log 2>&1 

cd $LOAD/mergedSnpRsIds_processing
echo "Loading MergedSNP Ids tables"
rm *.bad *.log
time sh MergedSNPIds_Wrapper.sh $1 1>mergedIdProcessing.log 2>&1 

cd $LOAD/location
echo "Loading other location tables (Location Load Part 2 for 4.1, 4.2, etc. location hierarchy tables)"
time sh postbigid.sh $1 1>>locationLoad.log 2>&1 

cd $LOAD/compara
echo "Loading Compara tables (Ensembl Compara)"
time sh load.sh $1 1>compara.log 2>&1 

cd $LOAD/drugbank
echo "Loading drugbank tables (Canada Drug Bank)"
time sh load.sh $1 1>drugbank.log 2>&1 

cd $LOAD/ctep
echo "Loading CTEP data (NCI Ctep)"
rm *.bad *.log
time sh ctep.sh $1 1>ctep_load.log 2>&1 &

sqlplus $1 @$LOAD/unigene/unigeneTempData/coalse_unigene.sql 1>$LOAD/unigene/unigeneTempData/coalse_unigene.log

# indexes for some objects not covered above 
sqlplus $1 @$LOAD/misc_indexes.sql 

mail -s " ArrayReporters Class Hierarchy Load Log " $EMAIL < $LOAD/arrays/postbigid.log 
mail -s " Merged SNPs Load Log " $EMAIL < $LOAD/mergedSnpRsIds_processing/mergedIdProcessing.log 
mail -s " Location Load Log " $EMAIL < $LOAD/location/locationLoad.log 
mail -s " Compara Load Log " $EMAIL < $LOAD/compara/compara.log 
mail -s " DrugBank Load Log " $EMAIL < $LOAD/drugbank/drugbank.log 
mail -s "NCI CTEP Load Log " $EMAIL < $LOAD/ctep/ctep_load.log 

echo "Finished Data Load" |  mail -s " Finished Load P8; finished enabling ref constraints " $EMAIL < refConstraints.log

exit
