#!/bin/bash
# Created by : Alen Frantz
# Desc		: This script is used to trigger the click-stream synthesis jobs.

USER_PATH_CS_SYNTHESIS="${BASH_SOURCE[0]}";
SCRIPT_HOME_CS_SYNTHESIS=`dirname $USER_PATH_CS_SYNTHESIS`

. $SCRIPT_HOME_CS_SYNTHESIS/../run_common_clickstream_synthesis.sh

# Export Variables
export HCAT_HOME=$HCAT_HOME

#get start date and end date
start_date=$(getStartDateSession);
end_date=$(getEndDateSession);

proc_start_year=`echo $start_date|cut -d'-' -f 1`
proc_start_month=`echo $start_date|cut -d'-' -f 2`
proc_start_day=`echo $start_date|cut -d'-' -f 3`
proc_end_year=`echo $end_date|cut -d'-' -f 1`
proc_end_month=`echo $end_date|cut -d'-' -f 2`
proc_end_day=`echo $end_date|cut -d'-' -f 3`

#echo variables
echo "ScriptName : 1_one_time_create_master_tables.pig";
echo "StartDate : $start_date EndDatec : $end_date";
echo "proc_start_year : $proc_start_year"
echo "proc_start_month : $proc_start_month"
echo "proc_start_day : $proc_start_day"
echo "proc_end_year : $proc_end_year"
echo "proc_end_month : $proc_end_month"
echo "proc_end_day : $proc_end_day"

#input table variables
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
load_clickstreambrowsertyperecord="$hive_db_gold.$clickstreambrowsertyperecord"

#output table name
clickstreamrecord_denorm_temp_table="$hive_db_work.$clickstreamrecord_denorm_temp"

#product tables
load_gold_ecom_atg_product_catalogue_kls_sku="$hive_db_gold.$gold_ecom_atg_product_catalogue_kls_sku"
load_gold_ecom_atg_product_catalogue_dcs_product_child_sku="$hive_db_gold.$gold_ecom_atg_product_catalogue_dcs_product_child_sku"
load_gold_ecom_atg_product_catalogue_dcs_product="$hive_db_gold.$gold_ecom_atg_product_catalogue_dcs_product"
load_atg_kls_product="$hive_db_gold.$atg_kls_product"

#remove hdfs path for temp table
hadoop fs -rm -r "$hive_db_work_path/$clickstreamrecord_denorm_temp/*"

#job start time for audit logging
job_start_time=`date`;


echo "Command executed : pig -useHCatalog -D mapreduce.job.queuename=$job_queuename -param load_clickstreambrowsertyperecord=$load_clickstreambrowsertyperecord -param load_gold_ecom_atg_product_catalogue_dcs_product=$load_gold_ecom_atg_product_catalogue_dcs_product -param load_gold_ecom_atg_product_catalogue_dcs_product_child_sku=$load_gold_ecom_atg_product_catalogue_dcs_product_child_sku -param SCRIPT_HOME_CS_SYNTHESIS=$SCRIPT_HOME_CS_SYNTHESIS -param load_clickstreamrecord=$load_clickstreamrecord -param load_gold_ecom_atg_product_catalogue_kls_sku=$load_gold_ecom_atg_product_catalogue_kls_sku -param load_clickstreambrowserrecord=$load_clickstreambrowserrecord -param load_clickstreamcolordepthrecord=$load_clickstreamcolordepthrecord -param load_clickstreamconnectiontyperecord=$load_clickstreamconnectiontyperecord -param load_clickstreamcountryrecord=$load_clickstreamcountryrecord -param load_clickstreamjavascriptrecord=$load_clickstreamjavascriptrecord -param load_clickstreamlanguagerecord=$load_clickstreamlanguagerecord -param load_clickstreamoperatingsystemrecord=$load_clickstreamoperatingsystemrecord -param load_clickstreampluginsrecord=$load_clickstreampluginsrecord -param load_clickstreamreferrertyperecord=$load_clickstreamreferrertyperecord -param load_clickstreamresolutionrecord=$load_clickstreamresolutionrecord -param load_clickstreamsearchenginesrecord=$load_clickstreamsearchenginesrecord -param clickstreamrecord_denorm_temp_table=$clickstreamrecord_denorm_temp_table -param ua_parser=$ua_parser -param product_jar=$product_jar -param event_jar=$event_jar -param load_atg_kls_product=$load_atg_kls_product -param proc_start_year=$proc_start_year -param proc_start_month=$proc_start_month -param proc_start_day=$proc_start_day -param proc_end_year=$proc_end_year -param proc_end_month=$proc_end_month -param proc_end_day=$proc_end_day -param proc_year=$proc_end_year -param proc_month=$proc_end_month -param proc_day=$proc_end_day -f $SCRIPT_HOME_CS_SYNTHESIS/1_denorm_first_phase.pig -l $log_home"

pig -useHCatalog -D mapreduce.job.queuename=$job_queuename -param load_clickstreambrowsertyperecord=$load_clickstreambrowsertyperecord -param load_gold_ecom_atg_product_catalogue_dcs_product=$load_gold_ecom_atg_product_catalogue_dcs_product -param load_gold_ecom_atg_product_catalogue_dcs_product_child_sku=$load_gold_ecom_atg_product_catalogue_dcs_product_child_sku -param SCRIPT_HOME_CS_SYNTHESIS=$SCRIPT_HOME_CS_SYNTHESIS -param load_clickstreamrecord=$load_clickstreamrecord -param load_gold_ecom_atg_product_catalogue_kls_sku=$load_gold_ecom_atg_product_catalogue_kls_sku -param load_clickstreambrowserrecord=$load_clickstreambrowserrecord -param load_clickstreamcolordepthrecord=$load_clickstreamcolordepthrecord -param load_clickstreamconnectiontyperecord=$load_clickstreamconnectiontyperecord -param load_clickstreamcountryrecord=$load_clickstreamcountryrecord -param load_clickstreamjavascriptrecord=$load_clickstreamjavascriptrecord -param load_clickstreamlanguagerecord=$load_clickstreamlanguagerecord -param load_clickstreamoperatingsystemrecord=$load_clickstreamoperatingsystemrecord -param load_clickstreampluginsrecord=$load_clickstreampluginsrecord -param load_clickstreamreferrertyperecord=$load_clickstreamreferrertyperecord -param load_clickstreamresolutionrecord=$load_clickstreamresolutionrecord -param load_clickstreamsearchenginesrecord=$load_clickstreamsearchenginesrecord -param clickstreamrecord_denorm_temp_table=$clickstreamrecord_denorm_temp_table -param ua_parser=$ua_parser -param product_jar=$product_jar -param event_jar=$event_jar -param load_atg_kls_product=$load_atg_kls_product -param proc_start_year=$proc_start_year -param proc_start_month=$proc_start_month -param proc_start_day=$proc_start_day -param proc_end_year=$proc_end_year -param proc_end_month=$proc_end_month -param proc_end_day=$proc_end_day -param proc_year=$proc_end_year -param proc_month=$proc_end_month -param proc_day=$proc_end_day -f $SCRIPT_HOME_CS_SYNTHESIS/1_denorm_first_phase.pig -l $log_home

if [ $? -eq 0 ];
then
        echo "1_denorm_first_phase.pig successfully completed."
		###### AUDIT LOGS #################
	 job_end_time=`date`;	
	WriteIntoAuditForSession "$SESSION_ID" "111" "$job_start_time" "$job_end_time" "$load_date_time" "SUCCESS" "NA" "$start_date" "$end_date";	
	###### AUDIT LOGS ENDS #################
else
    echo "1_denorm_first_phase.pig failed to execute."
	###### AUDIT LOGS #################
	 job_end_time=`date`;	
	WriteIntoAuditForSession "$SESSION_ID" "111" "$job_start_time" "$job_end_time" "$load_date_time" "FAILED" "NA" "$start_date" "$end_date";	
	###### AUDIT LOGS ENDS #################
    exit 100
fi