/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index NEW_PROTTEIN_NAME_lwr on NEW_PROTEIN(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NEW_PROTTEIN_COPYRIGHTS_lwr on NEW_PROTEIN(lower(COPYRIGHTSTATEMENT)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NEW_PROTTEIN_KEYWORD_lwr on NEW_PROTEIN(lower(KEYWORD)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NEW_PROTTEIN_UNIPROTCOD_lwr on NEW_PROTEIN(lower(UNIPROTCODE)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NEW_PROTTEIN_SECONDARY__lwr on NEW_PROTEIN(lower(SECONDARY_ACCESSION)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index NEW_PROTTEIN_PRIMARY_AC_lwr on NEW_PROTEIN(lower(PRIMARY_ACCESSION)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
