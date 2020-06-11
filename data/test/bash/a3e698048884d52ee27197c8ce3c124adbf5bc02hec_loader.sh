#! /bin/sh

#--------------------------
# HELIO 2010 HEC server - by Andrej Santin
# INAF - Trieste Astronomical Observatory
# automatic crontab loader
#-----------------------------------------
# AUTOMATIC (crontab) DAILY UPDATING
# OF HEC DATABASE
#-----------------------------------------
# last 28-jun-2011
#-----------------------------------------

HECROOT=/var/www/hec

#-----------------------------------------
# load and parse new data from providers
#-----------------------------------------
php -f $HECROOT/hec_load_hef.php
php -f $HECROOT/hec_load_npe.php
php -f $HECROOT/hec_load_lcl.php
php -f $HECROOT/hec_load_lcc.php
php -f $HECROOT/hec_load_ssn.php
php -f $HECROOT/hec_load_sfm.php
php -f $HECROOT/hec_load_dsd.php
php -f $HECROOT/hec_load_sgs.php
sort $HECROOT/temp/SGS2.postgres.converted | uniq > $HECROOT/temp/SGS.postgres.converted
#php -f $HECROOT/hec_load_yfc.php #closed
php -f $HECROOT/hec_load_srs.php
sort $HECROOT/temp/SRS2.postgres.converted | uniq > $HECROOT/temp/SRS.postgres.converted
#php -f $HECROOT/hec_load_bms.php #partial?
php -f $HECROOT/hec_load_goes.php
php -f $HECROOT/hec_load_soho.php
php -f $HECROOT/hec_load_kso.php
#php -f $HECROOT/hec_load_eit.php #closed
#php -f $HECROOT/hec_load_yst.php #closed
php -f $HECROOT/hec_load_ha.php #still some errors

php -f $HECROOT/hec_load_mssl.php

#-----------------------------------------
# regenerate SEC database structure 
# and online documentation
#-----------------------------------------
psql -d hec -f $HECROOT/hec_create.sql
psql -d hec -f $HECROOT/hec_fillmetadata.sql
php -f $HECROOT/hec_doc_generator.php

#-----------------------------------------
# insert HEC data
#-----------------------------------------
psql -d hec -f $HECROOT/hec_insert.sql

#-----------------------------------------
# write log and summary
#-----------------------------------------
date >> $HECROOT/hec.log

#new GUI
psql -d hec -f $HECROOT/hec_fillmetadata_cat.sql
psql -d hec -f $HECROOT/hec_views.sql

php -f $HECROOT/hec_range.php
php -f $HECROOT/hec_gui_range.php
psql -d hec -f $HECROOT/catalogues.sql
php -f $HECROOT/hec_graph.php

