set echo on

alter tablespace tts_ex1 read only;

alter tablespace tts_ex2 read only;

host exp userid="""sys/change_on_install as sysdba""" transport_tablespace=y  tablespaces=(tts_ex1,tts_ex2)


host XCOPY c:\oracle\oradata\tkyte816\tts_ex?.dbf c:\temp

alter tablespace tts_ex1 read write;

alter tablespace tts_ex2 read write;


imp file=expdat.dmp userid="""sys/change_on_install as sysdba""" transport_tablespace=y "datafiles=(c:\temp\tts_ex1.dbf,c:\temp\tts_ex2.dbf)"


update emp set ename=lower(ename);

alter tablespace tts_ex1 read write;

alter tablespace tts_ex2 read write;

update emp set ename=lower(ename);

