--INSERT +append parallel(t 4)
--      INTO  opers t

    
   SELECT event_dt AS transaction_dt
        , transaction_id AS transaction_id
        , st.store_id
        , st.store_name
        , cst.first_name AS cust_first_name
        , cst.last_name AS cust_last_name
        , cst.birth_day AS cust_birth_day
        , prd.product_id
        , prd.product_name
        , o.pay_metod AS pay_metod_id
        , ( CASE o.pay_metod
              WHEN 1 THEN 'CASH'
              WHEN 2 THEN 'CARD'
              WHEN 3 THEN 'Others'
              ELSE 'N.A.'
           END )
             AS pay_metod_desc
        , o.quantity
        , prd.prd_unit
        , o.price        
        , o.price * o.quantity AS value_full
        , o.disc AS discount_percent
        , ROUND ( o.disc * ( o.price * o.quantity )
                , 2 )
             AS discount_sum
        , ( o.price * o.quantity ) - o.disc * ( o.price * o.quantity ) AS value_clear
        , emp.emp_id AS emp_id
        , emp.first_name AS emp_first_name
        , emp.last_name AS emp_last_name
     FROM tmp_opers o
        , (SELECT ROWNUM AS rn
                , st.store_id
                , store_name
             FROM tmp_stores st) st
        , (SELECT ROWNUM AS rn
                , first_name
                , last_name
                , birth_day
                , cntr_desc
             FROM tmp_cust st) cst
        , (SELECT ROWNUM AS rn
                , product_id
                , product_name
                , st.prd_unit
             FROM tmp_products st) prd
        , (SELECT ROWNUM AS rn
                , emp_id
                , first_name
                , last_name
             FROM tmp_emp st) emp
    WHERE st.rn = o.cntr_str
      AND cst.rn = o.cust_num
      AND prd.rn = o.cntr_prd
      AND emp.rn = o.emp_num
 
     