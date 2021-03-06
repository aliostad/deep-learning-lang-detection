--------------------------------------------------------
--  File created - Wednesday-May-28-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HPER_DIVIDEND
--------------------------------------------------------

  CREATE TABLE HPER_DIVIDEND 
   (	SCHEME VARCHAR2(50 BYTE), 
	VALUE_DATE DATE, 
	SCHEME_CLASS VARCHAR2(50 BYTE), 
	EX_DIVIDEND_NAV NUMBER(21,5), 
	PU_DIVIDEND_NAV NUMBER(21,5), 
	UPLOAD_DT DATE, 
	STATUS VARCHAR2(2 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE HHI_TBS ;


