--------------------------------------------------------
--  DDL for Table APEX_MENU_TEMP
--------------------------------------------------------

  CREATE TABLE "APEX_MENU_TEMP" 
   (	"USER_ID" NUMBER(12,0), 
	"TYPE_ID" NUMBER(12,0), 
	"PARENT_ID" NUMBER(12,0), 
	"CNAMES" VARCHAR2(4000 BYTE), 
	"URL_LINK" VARCHAR2(255 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
 

   COMMENT ON COLUMN "APEX_MENU_TEMP"."CNAMES" IS 'Apex menű neve (fejléce)';
 
   COMMENT ON TABLE "APEX_MENU_TEMP"  IS 'Apex menu strukturák nyilvántartási táblája';
