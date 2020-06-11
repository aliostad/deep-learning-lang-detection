# Created by : Alen Frantz
# Desc		: Trigger the pig script for denormalization of Clickstream table.

# Initialize

PARAM_FILE_NAME="param_file"
PARAM_FILE_PATH="$SCRIPT_HOME/../param/$PARAM_FILE_NAME"

. $PARAM_FILE_PATH


USER_PATH="${BASH_SOURCE[0]}";
SCRIPT_HOME=`dirname $USER_PATH`
PIG_SCRIPT_PATH="$SCRIPT_HOME/../scripts/$PIG_FILE_NAME"

#echo variables

load_clickstreamrecord="$hive_db_gold.$clickstreamrecord"
load_clickstreambrowserrecord="$hive_db_gold.$clickstreambrowserrecord"
load_clickstreamcolordepthrecord="$hive_db_gold.$clickstreamcolordepthrecord"
load_clickstreamconnectiontyperecord="$hive_db_gold.$clickstreamconnectiontyperecord"
load_clickstreamcountryrecord="$hive_db_gold.$clickstreamcountryrecord"
load_clickstreamjavascriptrecord="$hive_db_gold.$clickstreamjavascriptrecord"
load_clickstreamlanguagerecord="$hive_db_gold.$clickstreamlanguagerecord"
load_clickstreamoperatingsystemrecord="$hive_db_gold.$clickstreamoperatingsystemrecord"
load_clickstreampluginsrecord="$hive_db_gold.$clickstreampluginsrecord"
load_clickstreamreferrertyperecord="$hive_db_gold.$clickstreamreferrertyperecord"
load_clickstreamresolutionrecord="$hive_db_gold.$clickstreamresolutionrecord"
load_clickstreamsearchenginesrecord="$hive_db_gold.$clickstreamsearchenginesrecord"
store_clickstream_record_denorm="$hive_db_gold.$clickstream_record_denorm"

#export variables
export HCAT_HOME=$HCAT_HOME
export USER_PATH=$USER_PATH
export SCRIPT_HOME=$SCRIPT_HOME
export proc_day=$proc_day
export proc_month=$proc_month
export proc_year=$proc_year


hcat -e "use $hive_db_gold; alter table $clickstream_record_denorm drop partition (year=$proc_year,month=$proc_month,day=$proc_day);"

hadoop fs -rmr "$hdfs_path_db_gold/$clickstream_record_denorm/year=$proc_year/month=$proc_month/day=$proc_day"


pig -useHCatalog -D mapreduce.job.queuename=$job_queuename -param SCRIPT_HOME=$SCRIPT_HOME -param load_clickstreamrecord=$load_clickstreamrecord -param load_clickstreambrowserrecord=$load_clickstreambrowserrecord -param load_clickstreamcolordepthrecord=$load_clickstreamcolordepthrecord -param load_clickstreamconnectiontyperecord=$load_clickstreamconnectiontyperecord -param load_clickstreamcountryrecord=$load_clickstreamcountryrecord -param load_clickstreamjavascriptrecord=$load_clickstreamjavascriptrecord -param load_clickstreamlanguagerecord=$load_clickstreamlanguagerecord -param load_clickstreamoperatingsystemrecord=$load_clickstreamoperatingsystemrecord -param load_clickstreampluginsrecord=$load_clickstreampluginsrecord -param load_clickstreamreferrertyperecord=$load_clickstreamreferrertyperecord -param load_clickstreamresolutionrecord=$load_clickstreamresolutionrecord -param load_clickstreamsearchenginesrecord=$load_clickstreamsearchenginesrecord -param store_clickstream_record_denorm=$store_clickstream_record_denorm -param proc_day=$proc_day -param proc_month=$proc_month -param proc_year=$proc_year -param ua_parser=$ua_parser -param product_jar=$product_jar -param event_jar=$event_jar -f $PIG_SCRIPT_PATH -l $log_home


if [ $? -eq 0 ];
then
	echo "Final result is generated."
else
    echo "Final result generation is Failed."
    exit 100
fi
