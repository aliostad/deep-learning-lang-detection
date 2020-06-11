#!/bin/sh

hive -e "
  USE default;
  ALTER TABLE test_load_data015 DROP PARTITION (dt = '2013-05-02');
  ALTER TABLE test_load_data015 DROP PARTITION (dt = '2013-05-03');
  ALTER TABLE test_load_data015 DROP PARTITION (dt = '2013-05-04');
  ALTER TABLE test_load_data015 DROP PARTITION (dt = '2013-05-05');
"

hdfs dfs -rm -R /user/hive/warehouse/test_load_data015/dt=2013-05-02
hadoop distcp -m 1 /user/hive/warehouse/test_load_data015/dt=2013-05-01 /user/hive/warehouse/test_load_data015/dt=2013-05-02

hdfs dfs -rm -R /user/hive/warehouse/test_load_data015/dt=2013-05-03
hadoop distcp -m 1 /user/hive/warehouse/test_load_data015/dt=2013-05-01 /user/hive/warehouse/test_load_data015/dt=2013-05-03

