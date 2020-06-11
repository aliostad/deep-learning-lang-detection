/* Formatted on 21.07.2014 13:53:42 (QP5 v5.227.12220.39754) */
CREATE TABLE my_udr_btk_report
AS
   SELECT ROWID rwd, a.*
     FROM udr_lt a
    WHERE 1 = 0;

DECLARE

   v_date      DATE;
   v_cust_id   INTEGER;
BEGIN
   FOR c1
      IN (SELECT *
            FROM ro_agile.my_btk_report_5
           WHERE     (   DELIVERED_100TL = 'NO'
                      OR DELIVERED_100TL = 'YES' AND DELIVERED_250TL = 'NO')
                 AND DATE_100TL > TO_DATE ('01.01.2014', 'dd.mm.yyyy')
                 AND REFUND_TL IS NULL)
   LOOP
      IF c1.DELIVERED_100TL = 'NO'
      THEN
         v_date := c1.DATE_100TL;
      ELSE
         IF c1.DELIVERED_100TL = 'YES' AND c1.DELIVERED_250TL = 'NO'
         THEN
            v_date := c1.DATE_250TL;
         END IF;
      END IF;

      SELECT customer_id
        INTO v_cust_id
        FROM contract_all
       WHERE co_id = c1.co_id;

      INSERT /*+ APPEND_VALUES */
            INTO  my_udr_btk_report
         SELECT a.ROWID rwd, a.*
           FROM udr_lt a
          WHERE     v_cust_id = cust_info_customer_id
                AND c1.CO_ID = cust_info_contract_id
                AND   START_TIME_TIMESTAMP
                    + NVL ( (START_TIME_OFFSET * 1 / 86400), 0) >= v_date
                AND   START_TIME_TIMESTAMP
                    + NVL ( (START_TIME_OFFSET * 1 / 86400), 0) >= v_date
                AND   START_TIME_TIMESTAMP
                    + NVL ( (START_TIME_OFFSET * 1 / 86400), 0) <
                       c1.bucket_end_date
                AND   START_TIME_TIMESTAMP
                    + NVL ( (START_TIME_OFFSET * 1 / 86400), 0) >=
                       TO_DATE ('01.01.2014', 'dd.mm.yyyy')
                AND (   (    CALL_TYPE IN (11, 12, 13)
                         AND XFILE_IND = 'V'                   -- data roaming
                         AND TARIFF_INFO_SNCODE = 63)
                     OR (    TARIFF_INFO_SNCODE = 63
                         AND TARIFF_INFO_ZNCODE IN (1008) ----- KKTC data roaming
                         AND XFILE_IND = 'V'));

      COMMIT;
   END LOOP;
END;