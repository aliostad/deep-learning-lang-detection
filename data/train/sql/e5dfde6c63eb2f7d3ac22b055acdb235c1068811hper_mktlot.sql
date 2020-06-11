--------------------------------------------------------
--  File created - Wednesday-May-28-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HPER_MKTLOT
--------------------------------------------------------

  CREATE TABLE HPER_MKTLOT 
   (	SECURITY VARCHAR2(500 BYTE), 
	MKTLOT NUMBER(16,2), 
	MKTLOT_DATE DATE, 
	UPD_DT DATE, 
	VALUE_DATE DATE, 
	STATUS VARCHAR2(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE HHI_TBS ;


