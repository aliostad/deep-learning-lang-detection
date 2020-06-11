/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index NEW_PROTIN_1_PRIMARY_AC_lwr on NEW_PROTEIN_1(lower(PRIMARY_ACCESSION)) PARALLEL NOLOGGING tablespace CABIO;
create index NEW_PROTIN_1_SECONDARY__lwr on NEW_PROTEIN_1(lower(SECONDARY_ACCESSION)) PARALLEL NOLOGGING tablespace CABIO;
create index NEW_PROTIN_1_UNIPROTCOD_lwr on NEW_PROTEIN_1(lower(UNIPROTCODE)) PARALLEL NOLOGGING tablespace CABIO;
create index NEW_PROTIN_1_KEYWORD_lwr on NEW_PROTEIN_1(lower(KEYWORD)) PARALLEL NOLOGGING tablespace CABIO;
create index NEW_PROTIN_1_COPYRIGHTS_lwr on NEW_PROTEIN_1(lower(COPYRIGHTSTATEMENT)) PARALLEL NOLOGGING tablespace CABIO;
create index NEW_PROTIN_1_NAME_lwr on NEW_PROTEIN_1(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO;

--EXIT;
