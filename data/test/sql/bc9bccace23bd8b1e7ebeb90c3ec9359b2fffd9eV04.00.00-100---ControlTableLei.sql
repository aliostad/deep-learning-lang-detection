CREATE TABLE CONTROL_TABLE_LEI
  (
    ZRNR               VARCHAR2(8 BYTE) NOT NULL ENABLE,
    LEI                VARCHAR2(20 BYTE),
    REPORTING          VARCHAR2(1 BYTE),
    OTC_ETD            VARCHAR2(11 BYTE),
    TRADE_PRTY1_BRANCH VARCHAR2(2 BYTE),
    PRTY_REGION        VARCHAR2(6 BYTE),
    TRADE_PRTY1_FIN    VARCHAR2(4 BYTE),
    TRADE_PRTY1_NONFIN VARCHAR2(4 BYTE),
    TRADE_PRTY1_CORP   VARCHAR2(1 BYTE),
    DL_COM_ACT_PRTY1   VARCHAR2(5 BYTE),
    CLEAR_THRES_PRTY1  VARCHAR2(5 BYTE),
    TRADE_CAP_PRTY1    VARCHAR2(9 BYTE),
    BRK_ID_PRTY1_PRE   VARCHAR2(14 BYTE),
    BRK_ID_PRTY1_VAL   VARCHAR2(50 BYTE),
    CL_BRK_PRTY1_PRE   VARCHAR2(14 BYTE),
    CL_BRK_PRTY1_VAL   VARCHAR2(50 BYTE),
    BEN_ID_PRTY1_PRE   VARCHAR2(14 BYTE),
    BEN_ID_PRTY1_VAL   VARCHAR2(50 BYTE),
    COMMENTS           VARCHAR2(50 BYTE),
    FROM_DATE DATE,
    TO_DATE DATE,
    CREA_BY VARCHAR2(30 BYTE),
    CREA_DATE DATE,
    CONSTRAINT CONTROL_TABLE_LEI_PK PRIMARY KEY (ZRNR) USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS NOCOMPRESS LOGGING STORAGE( INITIAL 131072 NEXT 1048576 MINEXTENTS 1 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT) ENABLE
  )
  SEGMENT CREATION DEFERRED PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING STORAGE
  (
    INITIAL 524288 NEXT 131072 MINEXTENTS 1 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT
  );