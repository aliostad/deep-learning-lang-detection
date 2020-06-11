#!/bin/bash
DB=$1

if [ ! $DB ]; then

echo "USAGE: $0 DATABASE"

echo "Where the DATABASE name corresponds to the credentials specified in ./dbic.conf"
exit

fi

# Drop/create the db
mysqladmin -u root -p3l3g@nz drop $DB
mysqladmin -u root -p3l3g@nz create $DB

# Load the schema
mysql -u root -p3l3g@nz $DB < schema/cgc.sql 

# Regenerate the schema files
cd schema
./regenerate_schema.sh $DB
cd ../

# Load data from WormBase
cd util/import/wormbase
./load_species.pl
./load_gene_classes.pl
./load_laboratories.pl
./load_strains.pl
./load_variations.pl
exit
./load_transgenes.pl
./load_rearrengements.pl
./load_genes.pl

# Merge data from the cgc 
cd ../../../
./util/import/merge_cgc_data.pl --dir $IMPORT_DIR

