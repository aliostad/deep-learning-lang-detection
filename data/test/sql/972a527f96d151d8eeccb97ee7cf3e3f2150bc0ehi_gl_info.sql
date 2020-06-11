--------------------------------------------------------
--  File created - Wednesday-May-28-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HI_GL_INFO
--------------------------------------------------------

  CREATE TABLE HI_GL_INFO 
   (	LEVEL_1 VARCHAR2(6 BYTE), 
	ACCOUNT_NAME VARCHAR2(50 BYTE), 
	CODE VARCHAR2(4 BYTE), 
	SCHEME VARCHAR2(10 BYTE), 
	TYPE VARCHAR2(10 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE HHI_TBS ;


