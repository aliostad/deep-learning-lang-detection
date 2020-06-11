DELIMITER $$
DROP TRIGGER IF EXISTS tblLoansMaster_bd$$
CREATE TRIGGER tblLoansMaster_bd BEFORE DELETE ON tblLoansMaster FOR EACH ROW
BEGIN
  INSERT INTO tblLoansMasterTrash (id,borrower_id,borrower_type,loan_type_id,amount,check_number,check_status,program_id,zone_id,creator_id,creator_date,editor_id,editor_date,xp_delivered_date,xp_first_payment_date,chk_process,sponsor_id,kiva_id) VALUES (OLD.id,OLD.borrower_id,OLD.borrower_type,OLD.loan_type_id,OLD.amount,OLD.check_number,OLD.check_status,OLD.program_id,OLD.zone_id,OLD.creator_id,OLD.creator_date,OLD.editor_id,OLD.editor_date,OLD.xp_delivered_date,OLD.xp_first_payment_date,OLD.chk_process,OLD.sponsor_id,OLD.kiva_id);
END$$


