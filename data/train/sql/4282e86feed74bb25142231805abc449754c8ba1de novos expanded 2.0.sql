-- -----------------------------------------
-- Firebolt Supreme De Novo Variant Finder--   (it's that fast)
-- -----------------------------------------
delete from {FAMILY}_1VCF where instr(uniLocVCF, 'GL') != 0;  #gets rid of VCF lines that don't link back to a proper chromosome (these cause trouble later)
delete from {FAMILY}_2VCF where instr(uniLocVCF, 'GL') != 0;  #same as above, but for dad
#ALTER TABLE {FAMILY}_1VCF MODIFY uniLocVCF varchar(15) NOT NULL UNIQUE;  #declares that each line of the vcf will have a locus listed and it will be unique
#ALTER TABLE {FAMILY}_2VCF MODIFY uniLocVCF varchar(15) NOT NULL UNIQUE;  #same as above, but for dad
create table {FAMILY}_genotemp1 as select uniLoc, geneList, GenotypeVCF proband_geno, FILTERVCF, Genotype_QualityVCF, Variant_Confidence_Quality_by_DepthVCF,
				Depth_CountedVCF depth_proband, Reference_readsVCF Ref_reads_proband, Alt_readsVCF Alt_read_proband, Ref_read_percentVCF Ref_read_pct_proband,
				A_readVCF A_read_proband, G_readVCF G_read_proband, T_readVCF T_read_proband, C_readVCF C_read_proband, A_percentVCF A_percent_proband, G_percentVCF G_percent_proband, T_percentVCF T_percent_proband, C_percentVCF C_percent_proband
	from {FAMILY}_0_rare_damage;  #builds a new table by extracting values from the rare_and_damage table for the patient that we will need to test the genotype
#alter table {FAMILY}_genotemp1 add primary key (uniLoc, geneList);  #adds indexing to columns we may (or definitely will) want to search on in the new table
#Alter table {FAMILY}_genotemp1 add CONSTRAINT `genotemp1`
#    FOREIGN KEY (`uniLoc`)
#    REFERENCES `{FAMILY}_1VCF` (`uniLocVCF`);  #tells mySQL that each entry in the uniLoc column is going to be connected an entry in mom's VCF table.  We are now pivoting on the uniLoc column to speed up the searches
ALTER TABLE {FAMILY}_genotemp1 ADD INDEX (uniLoc), ADD INDEX (geneList);
create table {FAMILY}_genotemp2 as select {FAMILY}_genotemp1.*, 
		{FAMILY}_1VCF.GenotypeVCF mom_geno, {FAMILY}_1VCF.Depth_CountedVCF Depth_mom, {FAMILY}_1VCF.Reference_readsVCF Ref_read_mom, {FAMILY}_1VCF.Alt_readsVCF Alt_read_mom, {FAMILY}_1VCF.Ref_read_percentVCF Ref_read_pct_mom,
		{FAMILY}_1VCF.A_readVCF A_read_mom, {FAMILY}_1VCF.G_readVCF G_read_mom, {FAMILY}_1VCF.T_readVCF T_read_mom, {FAMILY}_1VCF.C_readVCF C_read_mom, {FAMILY}_1VCF.A_percentVCF A_percent_mom, {FAMILY}_1VCF.G_percentVCF G_percent_mom, {FAMILY}_1VCF.T_percentVCF T_percent_mom, {FAMILY}_1VCF.C_percentVCF C_percent_mom
	from {FAMILY}_genotemp1
		left join {FAMILY}_1VCF on {FAMILY}_genotemp1.uniLoc = {FAMILY}_1VCF.uniLocVCF; #creates a new table using the previously generated table with the child's info and looking up mom's info based on the locus, for which we just had it build up a list of linkage (this is like telling it to find something when it already knows where it is)
#alter table {FAMILY}_genotemp2 add primary key (uniLoc, geneList);  #adds indexing like above
drop table {FAMILY}_genotemp1; #deletes genotemp1 (we no longer need it and all of its data is on genotemp2)
#Alter table {FAMILY}_genotemp2 add CONSTRAINT `genotemp2` 
#    FOREIGN KEY (`uniLoc`)
#    REFERENCES `{FAMILY}_2VCF` (`uniLocVCF`); #like above, tells SQL that the uniLoc column ties in to another table, only this time the father's locus column
ALTER TABLE {FAMILY}_genotemp2 ADD INDEX (uniLoc), ADD INDEX (geneList);
create table {FAMILY}_genotypes as select {FAMILY}_genotemp2.*, 
		{FAMILY}_2VCF.GenotypeVCF dad_geno, {FAMILY}_2VCF.Depth_CountedVCF Depth_dad, {FAMILY}_2VCF.Reference_readsVCF Ref_read_dad, {FAMILY}_2VCF.Alt_readsVCF Alt_read_dad, {FAMILY}_2VCF.Ref_read_percentVCF Ref_read_pct_dad,
		{FAMILY}_2VCF.A_readVCF A_read_dad, {FAMILY}_2VCF.G_readVCF G_read_dad, {FAMILY}_2VCF.T_readVCF T_read_dad, {FAMILY}_2VCF.C_readVCF C_read_dad, {FAMILY}_2VCF.A_percentVCF A_percent_dad, {FAMILY}_2VCF.G_percentVCF G_percent_dad, {FAMILY}_2VCF.T_percentVCF T_percent_dad, {FAMILY}_2VCF.C_percentVCF C_percent_dad
	from {FAMILY}_genotemp2
		left join {FAMILY}_2VCF on {FAMILY}_genotemp2.uniLoc = {FAMILY}_2VCF.uniLocVCF;  #creates the final genotype table by taking the table with child and mother's data and looking up dad's data to combine them
#alter table {FAMILY}_genotypes add primary key (uniLoc, geneList);  #adds indexing to the genotypes table
drop table {FAMILY}_genotemp2;  #deletes the genotemp2 table (we have all the data from it on the final table)
ALTER TABLE {FAMILY}_genotypes ADD INDEX (uniLoc), ADD INDEX (geneList);
select * from {FAMILY}_genotypes where  #this is a somewhat complex query explained in detail in the comment below
(substring_index(proband_geno, '/', 1) != substring_index(proband_geno, '/', -1)) and  #tests to exclude loci that are homozygous in proband
((substring_index(proband_geno, '/', 1) != '0' and substring_index(proband_geno, '/', 1) not in #excludes an allele that is a 0 (reference read) from further analysis
  (substring_index(mom_geno, '/', 1), substring_index(mom_geno, '/', -1),  #this line and the next see if the observed allele is seen in mom or dad
   substring_index(dad_geno, '/', 1), substring_index(dad_geno, '/', -1))
) or  
(substring_index(proband_geno, '/', -1) != '0' and substring_index(proband_geno, '/', -1) not in  #does the same as above for the proband's other allele
  (substring_index(mom_geno, '/', 1), substring_index(mom_geno, '/', -1),
   substring_index(dad_geno, '/', 1), substring_index(dad_geno, '/', -1))
));  
/*
explanation of these tests:  
proband must not be homozygous at locus 
	AND 
{[(proband allele 1 must not read reference) AND (proband allele 1 must not be the same as any parental allele)]
OR [proband allele 2 must not read reference) AND (proband allele 2 must not be the same as any parental allele]}
*/