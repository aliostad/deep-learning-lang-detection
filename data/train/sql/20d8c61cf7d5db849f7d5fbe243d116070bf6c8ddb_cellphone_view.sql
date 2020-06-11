use wigi_log;

drop view if exists view_active_wigi_codes;
CREATE VIEW view_active_wigi_codes AS
SELECT wigi_code_id, from_mobile_id,amount,date_expires,date_added from
wigi_code where status = '0' order by date_added desc;

drop view if exists view_history;
CREATE VIEW view_history AS
SELECT `transaction_id`,`direction`,`amount`,`from`,`to`,`description`,`stamp`,`from_description`,`to_description`,`viewed` from 
transaction order by stamp desc limit 50;

drop view if exists view_expired_codes;
CREATE VIEW view_expired_codes AS
SELECT wigi_code_id,from_mobile_id,amount from wigi_code where status = '0' and date_expires < now();

use wigi;
drop view if exists view_mobile_prefs;
CREATE VIEW view_mobile_prefs AS
SELECT * from user_mobile_ext where `category` = '1';

drop view if exists view_linked_credit_cards;
CREATE VIEW view_linked_credit_cards AS
select cc.last4 as last4,cc.description as description,cc.user_credit_card_id as id, 1 as type, mc.mobile_id as mobile_id from user_mobile_credit_card as mc, user_credit_card as cc where mc.user_credit_card_id = cc.user_credit_card_id;

drop view if exists view_linked_bank_accounts;
CREATE VIEW view_linked_bank_accounts AS
select ba.last4 as last4,ba.description as description,ba.user_bank_account_id as id, 2 as type, mc.mobile_id as mobile_id from user_mobile_bank_account as mc, user_bank_account as ba where mc.user_bank_account_id = ba.user_bank_account_id;
