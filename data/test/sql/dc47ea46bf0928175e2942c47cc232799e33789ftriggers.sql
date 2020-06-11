DELIMITER $$
DROP TRIGGER IF EXISTS tblFundsLoansMasterPct_bd$$
CREATE TRIGGER tblFundsLoansMasterPct_bd BEFORE DELETE ON tblFundsLoansMasterPct FOR EACH ROW
BEGIN
  INSERT INTO tblFundsLoansMasterPctTrash (id,master_id,fund_id,pct) VALUES (OLD.id,OLD.master_id,OLD.fund_id,OLD.pct);
END$$

DELIMITER $$
DROP TRIGGER IF EXISTS tblLoanStatusHistory_bd$$
CREATE TRIGGER tblLoanStatusHistory_bd BEFORE DELETE ON tblLoanStatusHistory FOR EACH ROW
BEGIN
  INSERT INTO tblLoanStatusHistoryTrash (id,loan_id,p_status,status,date,time,user_id,memo) VALUES (OLD.id,OLD.loan_id,OLD.p_status,OLD.status,OLD.date,OLD.time,OLD.user_id,OLD.memo);
END$$

DELIMITER $$
DROP TRIGGER IF EXISTS tblLoansMasterDetails_bd$$
CREATE TRIGGER tblLoansMasterDetails_bd BEFORE DELETE ON tblLoansMasterDetails FOR EACH ROW
BEGIN
  INSERT INTO tblLoansMasterDetailsTrash (master_id,loan_id) VALUES (OLD.master_id,OLD.loan_id);
END$$

DELIMITER $$
DROP TRIGGER IF EXISTS tblLoansMaster_bd$$
CREATE TRIGGER tblLoansMaster_bd BEFORE DELETE ON tblLoansMaster FOR EACH ROW
BEGIN
  INSERT INTO tblLoansMasterTrash (id,borrower_id,borrower_type,loan_type_id,amount,check_number,check_status,program_id,zone_id,creator_id,creator_date,editor_id,editor_date,xp_delivered_date,xp_first_payment_date,chk_process,sponsor_id,kiva_id) VALUES (OLD.id,OLD.borrower_id,OLD.borrower_type,OLD.loan_type_id,OLD.amount,OLD.check_number,OLD.check_status,OLD.program_id,OLD.zone_id,OLD.creator_id,OLD.creator_date,OLD.editor_id,OLD.editor_date,OLD.xp_delivered_date,OLD.xp_first_payment_date,OLD.chk_process,OLD.sponsor_id,OLD.kiva_id);
END$$

DELIMITER $$
DROP TRIGGER IF EXISTS tblLoans_bd$$
CREATE TRIGGER tblLoans_bd BEFORE DELETE ON tblLoans FOR EACH ROW
BEGIN
  INSERT INTO tblLoansTrash (id,loan_code,status,client_id,loan_type_id,business_id,installment,fees_at,fees_af,rates_r,rates_d,rates_e,margin_d,kp,kat,kaf,pmt,savings_p,savings_v,pg_value,pg_memo,re_value,re_memo,fgd_value,fgd_memo,fgt_value,fgt_memo,zone_id,client_zone_id,program_id,advisor_id,creator_date,creator_id,editor_date,editor_id,delivered_date,first_payment_date,xp_cancel_date,xp_num_pmt) VALUES (OLD.id,OLD.loan_code,OLD.status,OLD.client_id,OLD.loan_type_id,OLD.business_id,OLD.installment,OLD.fees_at,OLD.fees_af,OLD.rates_r,OLD.rates_d,OLD.rates_e,OLD.margin_d,OLD.kp,OLD.kat,OLD.kaf,OLD.pmt,OLD.savings_p,OLD.savings_v,OLD.pg_value,OLD.pg_memo,OLD.re_value,OLD.re_memo,OLD.fgd_value,OLD.fgd_memo,OLD.fgt_value,OLD.fgt_memo,OLD.zone_id,OLD.client_zone_id,OLD.program_id,OLD.advisor_id,OLD.creator_date,OLD.creator_id,OLD.editor_date,OLD.editor_id,OLD.delivered_date,OLD.first_payment_date,OLD.xp_cancel_date,OLD.xp_num_pmt);
END$$

DELIMITER $$
DROP TRIGGER IF EXISTS tblUsers_bu $$
CREATE TRIGGER tblUsers_bu BEFORE UPDATE ON tblUsers
FOR EACH ROW BEGIN
  if OLD.password != NEW.password then
    INSERT INTO tblPasswords (user_id,date,password) VALUES (OLD.id,curdate(),OLD.password) ON DUPLICATE KEY UPDATE password = OLD.password;
  end if;
END $$

DELIMITER ;