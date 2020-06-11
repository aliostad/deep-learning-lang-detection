--CREATE EXTENSION "xml2";
drop table if exists zkir_xml;
create table zkir_xml(region text, data xml);

insert into zkir_xml
select 'UA-C',XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('osm\UA-C.mp_addr.xml'), 'UTF8'));
insert into zkir_xml
select 'UA-E',XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('osm\UA-E.mp_addr.xml'), 'UTF8'));
insert into zkir_xml
select 'UA-N',XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('osm\UA-N.mp_addr.xml'), 'UTF8'));
insert into zkir_xml
select 'UA-S',XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('osm\UA-S.mp_addr.xml'), 'UTF8'));
insert into zkir_xml
select 'UA-W',XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('osm\UA-W.mp_addr.xml'), 'UTF8'));
insert into zkir_xml
select 'UA-S',XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('osm\RU-KRM.mp_addr.xml'), 'UTF8'));
/*insert into zkir_xml
select 'UA-OVRV',XMLPARSE(DOCUMENT convert_from(pg_read_binary_file('osm\UA-OVRV.mp_addr.xml'), 'UTF8'));*/