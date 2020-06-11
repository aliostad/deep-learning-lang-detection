/* Formatted on 8/23/2012 1:52:11 PM (QP5 v5.215.12089.38647) */
CREATE TABLE PROTECT.CUSTOMATTRIBUTESRECORD_LOG
AS
   SELECT *
     FROM PROTECT.CUSTOMATTRIBUTESRECORD
    WHERE 1 = 2;

ALTER TABLE PROTECT.CUSTOMATTRIBUTESRECORD_LOG ADD (LOGTIME TIMESTAMP(6));

CREATE OR REPLACE TRIGGER PROTECT.CUSTOMATTRIBUTESRECORD_UPDATE
   AFTER UPDATE
   ON PROTECT.CUSTOMATTRIBUTESRECORD
   REFERENCING NEW AS NEW OLD AS OLD
   FOR EACH ROW
DECLARE
BEGIN
   INSERT INTO PROTECT.CUSTOMATTRIBUTESRECORD_LOG
      (SELECT :NEW.CUSTOMATTRIBUTESRECORDID,
              :NEW.VALUE1,
              :NEW.VALUE2,
              :NEW.VALUE3,
              :NEW.VALUE4,
              :NEW.VALUE5,
              :NEW.VALUE6,
              :NEW.VALUE7,
              :NEW.VALUE8,
              :NEW.VALUE9,
              :NEW.VALUE10,
              :NEW.VALUE11,
              :NEW.VALUE12,
              :NEW.VALUE13,
              :NEW.VALUE14,
              :NEW.VALUE15,
              :NEW.VALUE16,
              :NEW.VALUE17,
              :NEW.VALUE18,
              :NEW.VALUE19,
              :NEW.VALUE20,
              :NEW.VALUE21,
              :NEW.VALUE22,
              :NEW.VALUE23,
              :NEW.VALUE24,
              :NEW.VALUE25,
              :NEW.VALUE26,
              :NEW.VALUE27,
              :NEW.VALUE28,
              :NEW.VALUE29,
              :NEW.VALUE30,
              :NEW.VALUE31,
              :NEW.VALUE32,
              :NEW.VALUE33,
              :NEW.VALUE34,
              :NEW.VALUE35,
              :NEW.VALUE36,
              :NEW.VALUE37,
              :NEW.VALUE38,
              :NEW.VALUE39,
              :NEW.VALUE40,
              :NEW.VALUE41,
              :NEW.VALUE42,
              :NEW.VALUE43,
              :NEW.VALUE44,
              :NEW.VALUE45,
              :NEW.VALUE46,
              :NEW.VALUE47,
              :NEW.VALUE48,
              :NEW.VALUE49,
              :NEW.VALUE50,
              CURRENT_TIMESTAMP
         FROM DUAL);
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END CUSTOMATTRIBUTESRECORD_UPDATE;