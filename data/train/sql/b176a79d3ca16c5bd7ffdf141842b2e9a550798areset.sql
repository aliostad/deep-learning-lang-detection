DELETE FROM tx_evchat_domain_model_administrator;
DELETE FROM tx_evchat_domain_model_conversation;
DELETE FROM tx_evchat_domain_model_event;
DELETE FROM tx_evchat_domain_model_message;
DELETE FROM tx_evchat_domain_model_visitor;

ALTER TABLE tx_evchat_domain_model_administrator AUTO_INCREMENT = 1;
ALTER TABLE tx_evchat_domain_model_conversation AUTO_INCREMENT = 1;
ALTER TABLE tx_evchat_domain_model_event AUTO_INCREMENT = 1;
ALTER TABLE tx_evchat_domain_model_message AUTO_INCREMENT = 1;
ALTER TABLE tx_evchat_domain_model_visitor AUTO_INCREMENT = 1;