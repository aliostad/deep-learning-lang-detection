/*******************
step one.  Get all tables to generate the sql down the line.
*******************/
show tables in study;
show tables in lims;
show tables in geno;
show tables in pheno;
show tables in admin;
show tables in audit;
show tables in reporting;

/*******************
step 2...do all the delete froms in order that they are permitted.
*******************/
-- show tables in audit;
 -- 	run deleteFromAllAuditTables.sql script 
-- show tables in admin;
-- show tables in reporting;
-- show tables in geno;
-- show tables in pheno;
-- show tables in lims;
-- show tables in study;

