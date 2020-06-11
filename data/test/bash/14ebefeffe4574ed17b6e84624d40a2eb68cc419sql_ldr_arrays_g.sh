#!/bin/sh

echo "load the Affymetrix arrays"
cd $CABIO_DIR/scripts/sql_loader/arrays
sqlplus $1 @$LOAD/arrays/arrayLoad_preprocess.sql

echo "Load microarray versions"
cd "$CABIO_DIR"/scripts/sql_loader/arrays
$SQLLDR $1 readsize=1000000 rows=100000 control=microarray_versions.ctl log=microarray_versions.log bad=microarray_versions.bad direct=true errors=50000

echo "Load Affymetrix tables"

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Affymetrix/HG-U133_Plus2
sh load.sh $1 

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Affymetrix/HG-U133
sh load.sh $1 

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Affymetrix/U133B
sh load.sh $1 

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Affymetrix/HG-U95
sh load.sh $1 

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Affymetrix/HuMapping
sh load.sh $1 

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Affymetrix/HuEx10ST
sh load.sh $1 

echo "Load the Agilent arrays"

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Agilent/HumanGenome44K
sh load.sh $1 
cd "$CABIO_DIR"/scripts/sql_loader/arrays/Agilent/aCGH244K
sh load.sh $1 

echo "Load the Illumina arrays"

cd "$CABIO_DIR"/scripts/sql_loader/arrays/Illumina/HumanHap550K
sh load.sh $1 
sqlplus $1 @$LOAD/arrays/arrayLoad_postprocess.sql 
