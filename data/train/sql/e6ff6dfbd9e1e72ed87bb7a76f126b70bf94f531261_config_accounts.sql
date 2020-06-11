ALTER TABLE `config_accounts` MODIFY COLUMN `Credits` DECIMAL(20, 5) DEFAULT '0.0';

ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Sheet` INT(11) DEFAULT '0' AFTER `Signature`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Achieve` INT(11) DEFAULT '0' AFTER `View_Mod_Sheet`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Friends` INT(11) DEFAULT '0' AFTER `View_Mod_Achieve`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Inv` INT(11) DEFAULT '0' AFTER `View_Mod_Friends`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Pets` INT(11) DEFAULT '0' AFTER `View_Mod_Inv`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_PvP` INT(11) DEFAULT '0' AFTER `View_Mod_Pets`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Quest` INT(11) DEFAULT '0' AFTER `View_Mod_PvP`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Rep` INT(11) DEFAULT '0' AFTER `View_Mod_Quest`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Skill` INT(11) DEFAULT '0' AFTER `View_Mod_Rep`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_Talent` INT(11) DEFAULT '0' AFTER `View_Mod_Skill`;
ALTER TABLE `config_accounts` ADD COLUMN `View_Mod_View` INT(11) DEFAULT '0' AFTER `View_Mod_Talent`;