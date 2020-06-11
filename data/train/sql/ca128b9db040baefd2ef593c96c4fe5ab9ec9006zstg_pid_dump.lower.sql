/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDDUMP_FIELD6_lwr on ZSTG_PID_DUMP(lower(FIELD6)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDDUMP_FIELD5_lwr on ZSTG_PID_DUMP(lower(FIELD5)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDDUMP_FIELD4_lwr on ZSTG_PID_DUMP(lower(FIELD4)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDDUMP_FIELD3_lwr on ZSTG_PID_DUMP(lower(FIELD3)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDDUMP_FIELD2_lwr on ZSTG_PID_DUMP(lower(FIELD2)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDDUMP_FIELD1_lwr on ZSTG_PID_DUMP(lower(FIELD1)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDDUMP_IDENTIFIER_lwr on ZSTG_PID_DUMP(lower(IDENTIFIER)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
