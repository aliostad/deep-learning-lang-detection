CREATE MATERIALIZED VIEW LOG ON T_XRD_RAW_FILE WITH SEQUENCE, ROWID
(
user_dn,
user_vo,
file_lfn,
client_host,
client_domain,
server_host,
server_domain,
server_username,
unique_id, 
start_time, 
end_time,
write_bytes_at_close, 
read_bytes_at_close, 
starttimestamp,
endtimestamp,
inserttimestamp ,

file_size             ,
read_vector_bytes                ,
read_single_average              ,
read_vector_count_average             ,
read_vector_min           ,
read_vector_count_max             ,
read_min                  ,
read_bytes               ,
read_vector_count_min             ,
read_vector_average       ,              
read_vector_sigma         ,       
read_max                 ,
read_vector_operations            ,
read_operations           ,
read_single_min           ,
read_single_bytes                 ,
read_single_max           ,
read_average             ,
read_sigma                ,
read_vector_count_sigma           ,
read_single_sigma                 ,
read_single_operations            ,
read_vector_max          ,

app_info 
)
INCLUDING NEW VALUES;

commit;

CREATE MATERIALIZED VIEW LOG ON T_XRD_LFC WITH SEQUENCE, ROWID
(
lfn,
blockname,
dsname,
fullname
)
INCLUDING NEW VALUES;

commit;

CREATE MATERIALIZED VIEW LOG ON T_XRD_USERFILE WITH SEQUENCE, ROWID
(
lfn,
username
)
INCLUDING NEW VALUES;

commit;
