set linesize 160
set pagesize 50
col currently_used format a16
col host format a25
spool /home/oracle/amchecks/dba_licence.txt APPEND

SELECT d.name as database, (select host_name from v$instance) as host, dfus.name, dfus.detected_usages, dfus.currently_used, dfus.version
FROM   dba_feature_usage_statistics dfus, v$database d
WHERE  version = (SELECT MAX(dfus2.version) FROM dba_feature_usage_statistics dfus2
                                         WHERE dfus2.name = dfus.name)
AND    detected_usages > 0
AND    d.dbid = dfus.dbid
AND    (dfus.name in ('Partitioning (user)', 'Active Data Guard - Real-Time Query on Physical Standby', 'Transparent Data Encryption', 'Data Redaction',
                      'SecureFile Encryption (user)', 'SecureFile Compression (user)', 'SecureFile Deduplication (user)', 'Backup HIGH Compression', 'Backup LOW Compression',
                      'Backup MEDIUM Compression', 'Backup ZLIB Compression', 'HeapCompression', 'Hybrid Columnar Compression')
    OR (dfus.name = 'Data Guard' and feature_info like '%Compression used: TRUE%')
    OR (dfus.name = 'Oracle Utility Datapump (Export)' and feature_info like '%compression used: >0%')
    OR (dfus.name = 'Oracle Utility Datapump (Import)' and feature_info like '%compression used: >0%'))
ORDER BY dfus.name;

spool off

exit
