/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021126_idx on NEW_PROTEIN
(NAME,COPYRIGHTSTATEMENT,KEYWORD,UNIPROTCODE,SECONDARY_ACCESSION,PRIMARY_ACCESSION,PROTEIN_ID) tablespace CABIO_FUT;
alter table NEW_PROTEIN enable constraint SYS_C0021126 using index SYS_C0021126_idx;
create unique index NP_PK_idx on NEW_PROTEIN
(PROTEIN_ID) tablespace CABIO_FUT;
alter table NEW_PROTEIN enable constraint NP_PK using index NP_PK_idx;
create unique index PROTUNIQ_idx on NEW_PROTEIN
(PRIMARY_ACCESSION) tablespace CABIO_FUT;
alter table NEW_PROTEIN enable constraint PROTUNIQ using index PROTUNIQ_idx;

alter table NEW_PROTEIN enable constraint SYS_C0021126;
alter table NEW_PROTEIN enable constraint SYS_C0021126;
alter table NEW_PROTEIN enable constraint SYS_C0021126;
alter table NEW_PROTEIN enable constraint SYS_C0021126;
alter table NEW_PROTEIN enable constraint SYS_C0021126;
alter table NEW_PROTEIN enable constraint SYS_C0021126;
alter table NEW_PROTEIN enable constraint SYS_C0021126;
alter table NEW_PROTEIN enable constraint SYS_C004603;
alter table NEW_PROTEIN enable constraint SYS_C004604;
alter table NEW_PROTEIN enable constraint SYS_C004605;
alter table NEW_PROTEIN enable constraint SYS_C004606;
alter table NEW_PROTEIN enable constraint SYS_C004607;
alter table NEW_PROTEIN enable constraint NP_PK;
alter table NEW_PROTEIN enable constraint PROTUNIQ;

alter table NEW_PROTEIN enable primary key;

--EXIT;
