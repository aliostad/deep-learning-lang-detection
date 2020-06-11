#!/bin/bash
. ../bash/config.sh

echo "hive_load_tmp_data_driver.sh started execution at ${dt}" > ${LOG_PATH}/hive_load_tmp_data_driver_${dt}.log

hive -f load_tmp_msd_year.hql

echo "Temporary data for msd_year loaded" >> ${LOG_PATH}/hive_load_tmp_data_driver_${dt}.log

hive -f load_tmp_msd_hotttnesss_yearwise.hql

echo "Temporary data for msd_hotttnesss_yearwise loaded" >> ${LOG_PATH}/hive_load_tmp_data_driver_${dt}.log

hive -f load_tmp_msd_hotttnesss.hql

echo "Temporary data for msd_hotttnesss loaded" >> ${LOG_PATH}/hive_load_tmp_data_driver_${dt}.log
