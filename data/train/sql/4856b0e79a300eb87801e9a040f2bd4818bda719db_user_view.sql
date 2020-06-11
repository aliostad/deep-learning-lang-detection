use wigi;

drop view if exists view_user_cellphones;
CREATE VIEW view_user_cellphones AS
SELECT user_id,mobile_id,cellphone from user_mobile where status = '1';

drop view if exists view_credit_cards;
CREATE VIEW view_credit_cards AS
SELECT user_credit_card_id as id,user_id,last4,description,'1' as `type` from user_credit_card;

drop view if exists view_bank_accounts;
CREATE VIEW view_bank_accounts AS
SELECT user_bank_account_id as id,user_id,last4,description,'2' as `type` from user_bank_account;

drop view if exists view_account_summary;
CREATE VIEW view_account_summary AS
SELECT user_id,mobile_id,cellphone,sum(balance) as balance,sum(temp_balance) as temp_balance from user_mobile group by mobile_id,user_id,cellphone;

drop view if exists view_unconfirmed_bank_accounts;
CREATE VIEW view_unconfirmed_bank_accounts AS
SELECT * from user_bank_account where status = '0';

drop view if exists view_unconfirmed_credit_cards;
CREATE VIEW view_unconfirmed_credit_cards AS
SELECT * from user_credit_card where status = '0';

drop view if exists view_unconfirmed_users;
CREATE VIEW view_confirmed_users AS
SELECT * from user where user.date_added <  ADDDATE(NOW(), INTERVAL - 12 HOUR) and user.status = '0';
