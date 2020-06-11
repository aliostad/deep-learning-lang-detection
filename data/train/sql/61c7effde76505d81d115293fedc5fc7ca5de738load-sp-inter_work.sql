truncate table inter_work.sp_info;
read protein,name,description,gene postgres+gz sptr-description.dat.gz;
insert /*+ APPEND */ into inter_work.sp_info(protein_ac,short_name,description,gene_name) values (?,?,?,?);
copy;
truncate table inter_work.sp_secondary;
read protein,secondary postgres+gz sptr-secondary.dat.gz;
insert /*+ APPEND */ into inter_work.sp_secondary(protein_ac,secondary_ac) values (?,?);
copy;
truncate table inter_work.sp_taxonomy;
read protein,organism postgres+gz sptr-organism.dat.gz;
insert /*+ APPEND */ into inter_work.sp_taxonomy(protein_ac,organism) values (?,?);
copy;


