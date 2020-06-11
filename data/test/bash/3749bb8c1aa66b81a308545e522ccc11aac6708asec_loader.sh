#! /bin/sh


#--------------------------
# EGSO - SEC server
# INAF - Trieste Astronomical Observatory
# automatic crontab loader
#-----------------------------------------
# AUTOMATIC (crontab) DAILY UPDATING
# OF SEC DATABASE
#-----------------------------------------
# by M.Jurcev, A.Santin -  EGSO
# first revision 05-jan-2004
# last revision  17-jun-2009
#-----------------------------------------

SECROOT=/var/www/hec

#-----------------------------------------
# load and parse new data from providers
#-----------------------------------------
php -f $SECROOT/sec_load_hef.php
php -f $SECROOT/sec_load_npe.php
php -f $SECROOT/sec_load_lcl.php
php -f $SECROOT/sec_load_lcc.php
php -f $SECROOT/sec_load_ssn.php
php -f $SECROOT/sec_load_sfm.php
php -f $SECROOT/sec_load_dsd.php
php -f $SECROOT/sec_load_sgs.php
sort $SECROOT/temp/SGS2.postgres.converted | uniq > $SECROOT/temp/SGS.postgres.converted
#php -f $SECROOT/sec_load_yfc.php #closed
php -f $SECROOT/sec_load_srs.php
sort $SECROOT/temp/SRS2.postgres.converted | uniq > $SECROOT/temp/SRS.postgres.converted
#php -f $SECROOT/sec_load_bms.php #partial?
php -f $SECROOT/sec_load_goes.php
php -f $SECROOT/sec_load_soho.php
php -f $SECROOT/sec_load_kso.php
#php -f $SECROOT/sec_load_eit.php #closed
#php -f $SECROOT/sec_load_yst.php #closed
php -f $SECROOT/sec_load_ha.php #still some errors

php -f $SECROOT/hec_load_mssl.php

#-----------------------------------------
# regenerate SEC database structure 
# and online documentation
#-----------------------------------------
psql -d hec -f $SECROOT/sec_create.sql
psql -d hec -f $SECROOT/sec_fillmetadata.sql
php -f $SECROOT/sec_doc_generator.php

#-----------------------------------------
# insert SEC data
#-----------------------------------------
psql -d hec -f $SECROOT/sec_insert.sql

#-----------------------------------------
# write log and summary
#-----------------------------------------
date >> $SECROOT/sec.log

#new GUI
psql -d hec -f $SECROOT/sec_fillmetadata_cat.sql
psql -d hec -f $SECROOT/hec_views.sql

php -f $SECROOT/sec_range.php
php -f $SECROOT/hec_gui_range.php
psql -d hec -f $SECROOT/catalogues.sql
php -f $SECROOT/sec_graph.php

