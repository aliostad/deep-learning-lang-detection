--------------------------------------------------------
--  DDL for Table counterparty_details
--------------------------------------------------------

  CREATE TABLE counterparty_details
   (zrnr VARCHAR2(8 BYTE), 
    branch_id VARCHAR2(8 BYTE), 
    branch_name VARCHAR2(255 BYTE),
    branch_country_code VARCHAR2(8 BYTE), 
    domicile_country_code VARCHAR2(8 BYTE), 
    domicile_country VARCHAR2(255 BYTE),
    counterparty_region VARCHAR2(8 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE( INITIAL 131072 NEXT 1048576 MINEXTENTS 1
  FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT);