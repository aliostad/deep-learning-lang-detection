lock tables association_qualifier write, association write, db write, dbxref write, evidence_dbxref write, evidence write, gene_product_synonym write, gene_product write, term write;

load data local infile 'association_qualifier.txt' into table association_qualifier fields terminated by '\t';
load data local infile 'association.txt' into table association fields terminated by '\t';
load data local infile 'db.txt' into table  db fields terminated by '\t';
load data local infile 'dbxref.txt' into table dbxref fields terminated by '\t';
load data local infile 'evidence_dbxref.txt' into table evidence_dbxref fields terminated by '\t';
load data local infile 'evidence.txt' into table evidence fields terminated by '\t';
load data local infile 'gene_product_synonym.txt' into table gene_product_synonym fields terminated by '\t';
load data local infile 'gene_product.txt' into table gene_product fields terminated by '\t';
load data local infile 'term.txt' into table  term fields terminated by '\t';

unlock tables;

