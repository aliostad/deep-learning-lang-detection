CREATE OR REPLACE TRIGGER "TRG_INSERT_GLDL"
   AFTER INSERT OR UPDATE
   ON gld_gmr_link_detail
   FOR EACH ROW
BEGIN
   IF UPDATING
   THEN
      IF :NEW.is_active = 'Y'
      THEN
         INSERT INTO gldl_gmr_link_detail_log
                     (gld_id, internal_action_ref_no,
                      activity_ref_no, activity_date,
                      product_id, product_name, quality_id,
                      quality_name, source_internal_gmr_ref_no,
                      source_gmr_ref_no,
                      source_int_contract_ref_no,
                      source_contract_ref_no,
                      source_int_contract_item_no,
                      source_contract_item_ref_no,
                      source_contract_type, source_corporate_id,
                      target_internal_gmr_ref_no,
                      target_gmr_ref_no,
                      target_int_contract_ref_no,
                      target_contract_ref_no,
                      target_int_contract_item_no,
                      target_contract_item_ref_no,
                      target_contract_type, target_corporate_id,
                      is_active, created_by, created_date,
                      updated_by, updated_date, VERSION,
                      entry_type
                     )
              VALUES (:NEW.gld_id, :NEW.internal_action_ref_no,
                      :NEW.activity_ref_no, :NEW.activity_date,
                      :NEW.product_id, :NEW.product_name, :NEW.quality_id,
                      :NEW.quality_name, :NEW.source_internal_gmr_ref_no,
                      :NEW.source_gmr_ref_no,
                      :NEW.source_int_contract_ref_no,
                      :NEW.source_contract_ref_no,
                      :NEW.source_int_contract_item_no,
                      :NEW.source_contract_item_ref_no,
                      :NEW.source_contract_type, :NEW.source_corporate_id,
                      :NEW.target_internal_gmr_ref_no,
                      :NEW.target_gmr_ref_no,
                      :NEW.target_int_contract_ref_no,
                      :NEW.target_contract_ref_no,
                      :NEW.target_int_contract_item_no,
                      :NEW.target_contract_item_ref_no,
                      :NEW.target_contract_type, :NEW.target_corporate_id,
                      'Y', :NEW.created_by, :NEW.created_date,
                      :NEW.updated_by, :NEW.updated_date, :NEW.VERSION,
                      'Update'
                     );
      ELSE
         -- IsActive is Cancelled
         INSERT INTO gldl_gmr_link_detail_log
                     (gld_id, internal_action_ref_no,
                      activity_ref_no, activity_date,
                      product_id, product_name, quality_id,
                      quality_name, source_internal_gmr_ref_no,
                      source_gmr_ref_no,
                      source_int_contract_ref_no,
                      source_contract_ref_no,
                      source_int_contract_item_no,
                      source_contract_item_ref_no,
                      source_contract_type, source_corporate_id,
                      target_internal_gmr_ref_no,
                      target_gmr_ref_no,
                      target_int_contract_ref_no,
                      target_contract_ref_no,
                      target_int_contract_item_no,
                      target_contract_item_ref_no,
                      target_contract_type, target_corporate_id,
                      is_active, created_by, created_date,
                      updated_by, updated_date, VERSION,
                      entry_type
                     )
              VALUES (:NEW.gld_id, :NEW.internal_action_ref_no,
                      :NEW.activity_ref_no, :NEW.activity_date,
                      :NEW.product_id, :NEW.product_name, :NEW.quality_id,
                      :NEW.quality_name, :NEW.source_internal_gmr_ref_no,
                      :NEW.source_gmr_ref_no,
                      :NEW.source_int_contract_ref_no,
                      :NEW.source_contract_ref_no,
                      :NEW.source_int_contract_item_no,
                      :NEW.source_contract_item_ref_no,
                      :NEW.source_contract_type, :NEW.source_corporate_id,
                      :NEW.target_internal_gmr_ref_no,
                      :NEW.target_gmr_ref_no,
                      :NEW.target_int_contract_ref_no,
                      :NEW.target_contract_ref_no,
                      :NEW.target_int_contract_item_no,
                      :NEW.target_contract_item_ref_no,
                      :NEW.target_contract_type, :NEW.target_corporate_id,
                      'N', :NEW.created_by, :NEW.created_date,
                      :NEW.updated_by, :NEW.updated_date, :NEW.VERSION,
                      'Update'
                     );
      END IF;
   ELSE
      -- New Entry ( Entry Type=Insert)
      INSERT INTO gldl_gmr_link_detail_log
                  (gld_id, internal_action_ref_no,
                   activity_ref_no, activity_date,
                   product_id, product_name, quality_id,
                   quality_name, source_internal_gmr_ref_no,
                   source_gmr_ref_no, source_int_contract_ref_no,
                   source_contract_ref_no,
                   source_int_contract_item_no,
                   source_contract_item_ref_no,
                   source_contract_type, source_corporate_id,
                   target_internal_gmr_ref_no, target_gmr_ref_no,
                   target_int_contract_ref_no,
                   target_contract_ref_no,
                   target_int_contract_item_no,
                   target_contract_item_ref_no,
                   target_contract_type, target_corporate_id, is_active,
                   created_by, created_date, updated_by,
                   updated_date, VERSION, entry_type
                  )
           VALUES (:NEW.gld_id, :NEW.internal_action_ref_no,
                   :NEW.activity_ref_no, :NEW.activity_date,
                   :NEW.product_id, :NEW.product_name, :NEW.quality_id,
                   :NEW.quality_name, :NEW.source_internal_gmr_ref_no,
                   :NEW.source_gmr_ref_no, :NEW.source_int_contract_ref_no,
                   :NEW.source_contract_ref_no,
                   :NEW.source_int_contract_item_no,
                   :NEW.source_contract_item_ref_no,
                   :NEW.source_contract_type, :NEW.source_corporate_id,
                   :NEW.target_internal_gmr_ref_no, :NEW.target_gmr_ref_no,
                   :NEW.target_int_contract_ref_no,
                   :NEW.target_contract_ref_no,
                   :NEW.target_int_contract_item_no,
                   :NEW.target_contract_item_ref_no,
                   :NEW.target_contract_type, :NEW.target_corporate_id, 'Y',
                   :NEW.created_by, :NEW.created_date, :NEW.updated_by,
                   :NEW.updated_date, :NEW.VERSION, 'Insert'
                  );
   END IF;
END;
/