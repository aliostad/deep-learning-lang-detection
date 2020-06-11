DROP TRIGGER
IF EXISTS BIZ_PEODUCT_ADT_INS;

DROP TRIGGER
IF EXISTS BIZ_PEODUCT_ADT_DEL;

DROP TRIGGER
IF EXISTS BIZ_PEODUCT_ADT_UPD;

/**
*
* Add Audit Trail Triggers(insert)
*
**/
CREATE TRIGGER BIZ_PEODUCT_ADT_INS AFTER INSERT ON biz_product FOR EACH ROW
BEGIN
	-- Insert record into audit table
	INSERT INTO biz_product_history (
		product_id,
		NO,
		NAME,
		original_price,
		purchase_price,
		recommend_price,
		platform_price,
		STATUS,
		effect_time,
		begin_time,
		end_time,
		start_time,
		stop_time,
		notice,
		introduction,
		supplier_id,
		audit_flag,
		uu_pid,
		create_by,
		create_date,
		update_by,
		update_date,
		remarks,
		del_flag,
		action_code
	)
VALUES
	(
		NEW.id,
		NEW. NO,
		NEW. NAME,
		NEW.original_price,
		NEW.purchase_price,
		NEW.recommend_price,
		NEW.platform_price,
		NEW. STATUS,
		NEW.effect_time,
		NEW.begin_time,
		NEW.end_time,
		NEW.start_time,
		NEW.stop_time,
		NEW.notice,
		NEW.introduction,
		NEW.supplier_id,
		NEW.audit_flag,
		NEW.uu_pid,
		NEW.create_by,
		NEW.create_date,
		NEW.update_by,
		NEW.update_date,
		NEW.remarks,
		NEW.del_flag,
		'I'
	);


END;

/**
*
* Add Audit Trail Triggers(delete)
*
**/
CREATE TRIGGER BIZ_PEODUCT_ADT_DEL AFTER DELETE ON biz_product FOR EACH ROW
BEGIN
	-- Insert record into audit table
	INSERT INTO biz_product_history (
		product_id,
		NO,
		NAME,
		original_price,
		purchase_price,
		recommend_price,
		platform_price,
		STATUS,
		effect_time,
		begin_time,
		end_time,
		start_time,
		stop_time,
		notice,
		introduction,
		supplier_id,
		audit_flag,
		uu_pid,
		create_by,
		create_date,
		update_by,
		update_date,
		remarks,
		del_flag,
		action_code
	)
VALUES
	(
		OLD.id,
		OLD. NO,
		OLD. NAME,
		OLD.original_price,
		OLD.purchase_price,
		OLD.recommend_price,
		OLD.platform_price,
		OLD.STATUS,
		OLD.effect_time,
		OLD.begin_time,
		OLD.end_time,
		OLD.start_time,
		OLD.stop_time,
		OLD.notice,
		OLD.introduction,
		OLD.supplier_id,
		OLD.audit_flag,
		OLD.uu_pid,
		OLD.create_by,
		OLD.create_date,
		OLD.update_by,
		OLD.update_date,
		OLD.remarks,
		OLD.del_flag,
		'D'
	);


END;

/**
*
* Add Audit Trail Triggers(update)
*
**/
CREATE TRIGGER BIZ_PEODUCT_ADT_UPD AFTER UPDATE ON biz_product FOR EACH ROW
BEGIN
	-- Insert record into audit table
	INSERT INTO biz_product_history (
		product_id,
		NO,
		NAME,
		original_price,
		purchase_price,
		recommend_price,
		platform_price,
		STATUS,
		effect_time,
		begin_time,
		end_time,
		start_time,
		stop_time,
		notice,
		introduction,
		supplier_id,
		audit_flag,
		uu_pid,
		create_by,
		create_date,
		update_by,
		update_date,
		remarks,
		del_flag,
		action_code
	)
VALUES
	(
		NEW.id,
		NEW. NO,
		NEW. NAME,
		NEW.original_price,
		NEW.purchase_price,
		NEW.recommend_price,
		NEW.platform_price,
		NEW. STATUS,
		NEW.effect_time,
		NEW.begin_time,
		NEW.end_time,
		NEW.start_time,
		NEW.stop_time,
		NEW.notice,
		NEW.introduction,
		NEW.supplier_id,
		NEW.audit_flag,
		NEW.uu_pid,
		NEW.create_by,
		NEW.create_date,
		NEW.update_by,
		NEW.update_date,
		NEW.remarks,
		NEW.del_flag,
		'U'
	);


END;

