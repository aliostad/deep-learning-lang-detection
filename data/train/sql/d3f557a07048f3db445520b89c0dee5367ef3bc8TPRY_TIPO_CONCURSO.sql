--------------------------------------------------------
-- Archivo creado  - viernes-abril-04-2014   
--------------------------------------------------------
DROP TABLE "REFERENCIA"."TPRY_TIPO_CONCURSO" cascade constraints;
--------------------------------------------------------
--  DDL for Table TPRY_TIPO_CONCURSO
--------------------------------------------------------

  CREATE TABLE "REFERENCIA"."TPRY_TIPO_CONCURSO" 
   (	"TCON_ID" NUMBER, 
	"TCON_NOMBRE" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
REM INSERTING into REFERENCIA.TPRY_TIPO_CONCURSO
SET DEFINE OFF;
Insert into REFERENCIA.TPRY_TIPO_CONCURSO (TCON_ID,TCON_NOMBRE) values (1,'Concurso inicial');
Insert into REFERENCIA.TPRY_TIPO_CONCURSO (TCON_ID,TCON_NOMBRE) values (2,'Reconcurso');
Insert into REFERENCIA.TPRY_TIPO_CONCURSO (TCON_ID,TCON_NOMBRE) values (3,'Recotización');
Insert into REFERENCIA.TPRY_TIPO_CONCURSO (TCON_ID,TCON_NOMBRE) values (4,'Solo cotización');
Insert into REFERENCIA.TPRY_TIPO_CONCURSO (TCON_ID,TCON_NOMBRE) values (5,'Modificación Catálogo');
Insert into REFERENCIA.TPRY_TIPO_CONCURSO (TCON_ID,TCON_NOMBRE) values (6,'Concurso detenido');
Insert into REFERENCIA.TPRY_TIPO_CONCURSO (TCON_ID,TCON_NOMBRE) values (7,'Concurso cancelado');
--------------------------------------------------------
--  DDL for Index TGENTIPOCONCURSO_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "REFERENCIA"."TGENTIPOCONCURSO_PK" ON "REFERENCIA"."TPRY_TIPO_CONCURSO" ("TCON_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA" ;
--------------------------------------------------------
--  Constraints for Table TPRY_TIPO_CONCURSO
--------------------------------------------------------

  ALTER TABLE "REFERENCIA"."TPRY_TIPO_CONCURSO" ADD CONSTRAINT "PK01_TCON_ID" PRIMARY KEY ("TCON_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "DATA"  ENABLE;
  ALTER TABLE "REFERENCIA"."TPRY_TIPO_CONCURSO" MODIFY ("TCON_ID" NOT NULL ENABLE);