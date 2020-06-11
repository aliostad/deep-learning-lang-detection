INSERT IGNORE INTO `m_permission` (`grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES ('inventory', 'READ_INVENTORY', 'INVENTORY', 'READ', 0);

INSERT IGNORE INTO `m_permission` (`grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES ('inventory', 'READ_SUPPLIER', 'SUPPLIER', 'READ', 0);

INSERT IGNORE INTO `m_permission` (`grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES ('inventory', 
'READ_ITEM', 'ITEM', 'READ', 0);

INSERT IGNORE INTO `m_permission` (`grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES ('inventory', 
'READ_MRN', 'MRN', 'READ', 0);

INSERT IGNORE INTO `m_permission` (`grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES ('inventory', 
'READ_GRN', 'GRN', 'READ', 0);

INSERT IGNORE INTO `m_permission` (`grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES ('inventory', 'READ_ITEMSALE', 'ITEMSALE', 'READ', 0);

INSERT IGNORE INTO `m_permission` (`grouping`, `code`, `entity_name`, `action_name`, `can_maker_checker`) VALUES ('administration', 'READ_ADMIN', 'ADMIN', 'READ', 0);

insert IGNORE INTO m_role values(null,'Sale','For Exclusively sale user');

SET @ROLEID=(select id from m_role where name='Sale');
SET @ID=(select id from m_permission where code='READ_LOANPRODUCT');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='READ_LOAN');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='READ_CLIENT');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='CREATE_CLIENT');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='UPDATE_CLIENT');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='READ_CLIENTIMAGE');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='CREATE_CLIENTIMAGE');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='CREATE_LOANTAXMAPPING');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='CREATE_PROSPECT');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='READ_PROSPECT');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
SET @ID=(select id from m_permission where code='UPDATE_PROSPECT');
INSERT IGNORE INTO m_role_permission VALUES (@ROLEID,@ID);
