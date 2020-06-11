DROP TRIGGER TRG_INSERT_POFHL;
CREATE OR REPLACE TRIGGER TRG_INSERT_POFHL
   AFTER INSERT OR UPDATE
   ON pofh_price_opt_fixation_header
   FOR EACH ROW
BEGIN
   --
   IF UPDATING
   THEN
      INSERT INTO pofhl_price_opt_fixat_head_log
                  (pofh_id, pocd_id, internal_gmr_ref_no,
                   entry_type, qp_start_date, qp_end_date,
                   qty_to_be_fixed_delta,
                   priced_qty_delta,
                   no_of_prompt_days_delta,
                   per_day_pricing_qty_delta,
                   final_price_delta,
                   finalize_date, VERSION, is_active,
                   avg_pri_in_pri_in_cur_delta,
                   avg_fx_delta,
                   no_of_prompt_days_fixed,
                   event_name,
                   delta_priced_qty_delta,
                   final_pri_in_pric_cur_delta,
                   internal_action_ref_no,
                   hedge_correction_qty_delta,
                   qp_start_qty_delta,
                   is_provesional_assay_exist,
                   balance_priced_qty_delta,
                   per_day_hedge_corr_qty_delta,
                   total_hedge_corre_qty_delta
                  )
           VALUES (:NEW.pofh_id, :NEW.pocd_id, :NEW.internal_gmr_ref_no,
                   'Update', :NEW.qp_start_date, :NEW.qp_end_date,
                   :NEW.qty_to_be_fixed - :OLD.qty_to_be_fixed,
                   NVL (:NEW.priced_qty, 0) - NVL (:OLD.priced_qty, 0),
                   :NEW.no_of_prompt_days - :OLD.no_of_prompt_days,
                   :NEW.per_day_pricing_qty - :OLD.per_day_pricing_qty,
                   NVL (:NEW.final_price, 0) - NVL (:OLD.final_price, 0),
                   :NEW.finalize_date, :NEW.VERSION, :NEW.is_active,
                     NVL (:NEW.avg_price_in_price_in_cur, 0)
                   - NVL (:OLD.avg_price_in_price_in_cur, 0),
                   NVL (:NEW.avg_fx, 0) - NVL (:OLD.avg_fx, 0),
                     NVL (:NEW.no_of_prompt_days_fixed, 0)
                   - NVL (:OLD.no_of_prompt_days_fixed, 0),
                   :NEW.event_name,
                     NVL (:NEW.delta_priced_qty, 0)
                   - NVL (:OLD.delta_priced_qty, 0),
                     NVL (:NEW.final_price_in_pricing_cur, 0)
                   - NVL (:OLD.final_price_in_pricing_cur, 0),
                   :NEW.internal_action_ref_no,
                     NVL (:NEW.hedge_correction_qty, 0)
                   - NVL (:OLD.hedge_correction_qty, 0),
                   NVL (:NEW.qp_start_qty, 0) - NVL (:OLD.qp_start_qty, 0),
                   :NEW.is_provesional_assay_exist,
                     NVL (:NEW.balance_priced_qty, 0)
                   - NVL (:OLD.balance_priced_qty, 0),
                     NVL (:NEW.per_day_hedge_correction_qty, 0)
                   - NVL (:OLD.per_day_hedge_correction_qty, 0),
                     NVL (:NEW.total_hedge_corrected_qty, 0)
                   - NVL (:OLD.total_hedge_corrected_qty, 0)
                  );
   ELSE
      --
      -- New Entry ( Entry Type=Insert)
      --
      INSERT INTO pofhl_price_opt_fixat_head_log
                  (pofh_id, pocd_id, internal_gmr_ref_no,
                   entry_type, qp_start_date, qp_end_date,
                   qty_to_be_fixed_delta, priced_qty_delta,
                   no_of_prompt_days_delta, per_day_pricing_qty_delta,
                   final_price_delta, finalize_date, VERSION,
                   is_active, avg_pri_in_pri_in_cur_delta,
                   avg_fx_delta, no_of_prompt_days_fixed,
                   event_name, delta_priced_qty_delta,
                   final_pri_in_pric_cur_delta,
                   internal_action_ref_no, hedge_correction_qty_delta,
                   qp_start_qty_delta, is_provesional_assay_exist,
                   balance_priced_qty_delta,
                   per_day_hedge_corr_qty_delta,
                   total_hedge_corre_qty_delta
                  )
           VALUES (:NEW.pofh_id, :NEW.pocd_id, :NEW.internal_gmr_ref_no,
                   'Insert', :NEW.qp_start_date, :NEW.qp_end_date,
                   :NEW.qty_to_be_fixed, :NEW.priced_qty,
                   :NEW.no_of_prompt_days, :NEW.per_day_pricing_qty,
                   :NEW.final_price, :NEW.finalize_date, :NEW.VERSION,
                   :NEW.is_active, :NEW.avg_price_in_price_in_cur,
                   :NEW.avg_fx, :NEW.no_of_prompt_days_fixed,
                   :NEW.event_name, :NEW.delta_priced_qty,
                   :NEW.final_price_in_pricing_cur,
                   :NEW.internal_action_ref_no, :NEW.hedge_correction_qty,
                   :NEW.qp_start_qty, :NEW.is_provesional_assay_exist,
                   :NEW.balance_priced_qty,
                   :NEW.per_day_hedge_correction_qty,
                   :NEW.total_hedge_corrected_qty
                  );
   END IF;
END;