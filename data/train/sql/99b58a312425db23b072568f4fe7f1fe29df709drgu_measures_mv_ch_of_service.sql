CREATE OR REPLACE VIEW rgu_measures_mv_ch_of_service
AS 
WITH mv_ch_of_service
AS 
(
SELECT 
-- This view derives measures for 'Moves' and 'Change of Service'
-- For measures that are RGU-adds values of the new contract are selected, 
-- for measures that are RGU-drops values of the old contract are selected. 
       v_old.auftrag__no            auftrag__no_old
,      v_new.auftrag__no            auftrag__no_new       
,      v_old.service_elem__no       service_elem__no_old
,      v_new.service_elem__no       service_elem__no_new
,      v_old.ext_service_id         ext_service_id_old
,      v_new.ext_service_id         ext_service_id_new
,      v_old.cust_no                cust_no_old
,      v_new.cust_no                cust_no_new
,      v_old.oe__no                 oe__no_old
,      v_new.oe__no                 oe__no_new
,      v_old.is_price_0             is_price_0_old
,      v_new.is_price_0             is_price_0_new
,      v_old.con_contract_id        con_contract_id_old
,      v_new.con_contract_id        con_contract_id_new
,      v_new.contract_updowngrade   -- only relevant for new
,      v_old.charge_from            charge_from_old
,      v_new.charge_from            charge_from_new
,      v_new.charge_to              charge_to_new
,      v_old.charge_to              charge_to_old
,      v_old.charge_from_rep        charge_from_rep_old
,      v_new.charge_from_rep        charge_from_rep_new
,      v_new.charge_to_rep          charge_to_rep_new
,      v_old.charge_to_rep          charge_to_rep_old
,      CASE
          WHEN v_new.contract_updowngrade = 'Übersiedlung'
           AND v_old.oe__no = v_new.oe__no
          THEN 1
          ELSE 0
       END     is_move
,      CASE       
          WHEN v_new.contract_updowngrade IN
                  ('Übernahme', 'Upgrade', 'Downgrade')
           AND v_new.product_group = v_old.product_group
          THEN 1
          ELSE 0
       END     is_change_of_service_no_move
,      CASE       
          WHEN v_new.contract_updowngrade = 'Übersiedlung'
           -- Different product but same product_group
           AND v_old.oe__no != v_new.oe__no          
           AND v_new.product_group = v_old.product_group
          THEN 1
          ELSE 0
       END     is_change_of_service_move
FROM   rgu_measures_base    v_old
,      rgu_measures_base    v_new
WHERE  v_old.cust_no = v_new.cust_no
AND    v_old.is_drop_plain = 1
AND    v_new.is_add_plain  = 1
AND    v_new.contract_updowngrade IN 
            ( 'Übernahme'
            , 'Upgrade'
            , 'Übersiedlung'
            , 'Downgrade' )
AND    EXISTS
          (SELECT 'Hit'
           FROM   contractupdowngrade  cud
           WHERE  cud.contract_id_old = v_old.con_contract_id
           AND    cud.contract_id_new = v_new.con_contract_id
          )
)
-- begin main query
SELECT 1                            is_add -- new
,      auftrag__no_new              auftrag__no
,      service_elem__no_new         service_elem__no
,      ext_service_id_new           ext_service_id
,      cust_no_new                  cust_no
,      oe__no_new                   oe__no
,      is_price_0_new               is_price_0  
,      con_contract_id_new          con_contract_id
,      contract_updowngrade
,      charge_from_new              charge_from
,      charge_to_new                charge_to
,      charge_from_rep_new          charge_from_rep
,      charge_to_rep_new            charge_to_rep
,      is_move
,      is_change_of_service_no_move
,      is_change_of_service_move
FROM   mv_ch_of_service
UNION
SELECT 0                            id_add -- old
,      auftrag__no_old              auftrag__no
,      service_elem__no_old         service_elem__no
,      ext_service_id_old           ext_service_id
,      cust_no_old                  cust_no
,      oe__no_old                   oe__no
,      is_price_0_old               is_price_0
,      con_contract_id_old          con_contract_id
,      contract_updowngrade
,      charge_from_old              charge_from
,      charge_to_old                charge_to
,      charge_from_rep_old          charge_from_rep
,      charge_to_rep_old            charge_to_rep
,      is_move
,      is_change_of_service_no_move
,      is_change_of_service_move
FROM   mv_ch_of_service;
