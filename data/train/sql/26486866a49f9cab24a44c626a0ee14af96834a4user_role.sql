
CREATE TABLE PICC."user_role"
(
  "id"          VARCHAR2(64 CHAR)   NOT NULL,
  "catCode"     NUMBER(6),
  "posCode"     NUMBER(6),
  "froleCode"   NUMBER(6),
  "droleCode"   NUMBER(6),
  "statCode"    NUMBER(6),
  "corpId"      VARCHAR2(32 CHAR),
  "deptId"      VARCHAR2(32 CHAR)
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

ALTER TABLE PICC."user_role"
    ADD CONSTRAINT "user_role_PK"
    PRIMARY KEY ("id")
    ENABLE VALIDATE;