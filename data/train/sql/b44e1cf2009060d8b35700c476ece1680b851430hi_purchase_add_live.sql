--------------------------------------------------------
--  File created - Wednesday-May-28-2014   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table HI_PURCHASE_ADD_LIVE
--------------------------------------------------------

  CREATE TABLE HI_PURCHASE_ADD_LIVE 
   (	SCHEME VARCHAR2(100 BYTE), 
	NAV_DATE DATE, 
	TOTAL_PURCHASE_ADDITION_AMOUNT NUMBER(21,5)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 65536 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE HHI_TBS ;


