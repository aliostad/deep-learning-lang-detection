-- supplier relation table
-- @author leo
-- @data 2013-05-15

CREATE TABLE PICC."supplier_relation"
(
  "corpId"       VARCHAR2(32 CHAR),
  "supplierId"   VARCHAR2(32 CHAR),
  "startTime"    TIMESTAMP(6),
  "endTime"      TIMESTAMP(6)
)

TABLESPACE PICCTABLE
RESULT_CACHE (MODE DEFAULT)
PCTUSED    40
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            NEXT             1M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            FREELISTS        1
            FREELIST GROUPS  1
            BUFFER_POOL      DEFAULT
            FLASH_CACHE      DEFAULT
            CELL_FLASH_CACHE DEFAULT
           )
LOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE PICC."supplier_relation" ADD (
  CONSTRAINT "supplier_relation_PK"
  PRIMARY KEY
  ("corpId", "supplierId")
  ENABLE VALIDATE);
