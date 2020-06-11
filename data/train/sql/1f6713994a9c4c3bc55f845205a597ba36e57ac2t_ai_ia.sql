delimiter //

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------


CREATE DEFINER=`root`@`%`
TRIGGER ai_ia AFTER INSERT ON investment_account2
FOR EACH ROW

BEGIN

  INSERT INTO ia_log (action,ts,ia_id,inv_num,inv_type, contract_type, inv_length,inv_doc,inv_amount,support_type,support_amount, support_value,support_doc,revenue_type, revenue_value,inv_start_date,inv_end_date, inv_state,investor_id,executive_id, creation_date,creation_user, comm_schema_id, comm_schema_r_id, ref_inv_num, monthly_revenue, lastmod_user, lastmod_date)
  VALUES('create',NOW(),NEW.id, NEW.inv_num, NEW.inv_type, NEW.contract_type, NEW.inv_length, NEW.inv_doc, NEW.inv_amount, NEW.support_type, NEW.support_amount, NEW.support_value, NEW.support_doc, NEW.revenue_type, NEW.revenue_value, NEW.inv_start_date,inv_end_date, NEW.inv_state, NEW.investor_id, NEW.executive_id, NEW.creation_date, NEW.creation_user, NEW.comm_schema_id, NEW.comm_schema_r_id, NEW.ref_inv_num, NEW.monthly_revenue, NEW.lastmod_user, NEW.lastmod_date);

END;


