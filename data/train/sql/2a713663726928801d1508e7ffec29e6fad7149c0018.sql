-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------
-- REQUERIDO 0018

ALTER TABLE `versao_db` CHANGE `requerido_0018` `requerido_0019` BIT(1) NULL DEFAULT NULL;

-- remove o campo nome
ALTER TABLE `jos_edesktop_mailing_emails` DROP `nome`;

-- remove o campo html
ALTER TABLE `jos_edesktop_mailing_emails` DROP `html`;

-- adiciona um menu
INSERT INTO `jos_menu_types` (`id`, `menutype`, `title`, `description`) VALUES ('200', 'edesktop', 'eDesktop', 'Menu para uso interno do sistema');

-- adiciona um item de menu "mailing"
INSERT INTO `jos_menu` (`id`, `menutype`, `name`, `alias`, `link`, `type`, `published`, `parent`, `componentid`, `sublevel`, `ordering`, `checked_out`, `checked_out_time`, `pollid`, `browserNav`, `access`, `utaccess`, `params`, `lft`, `rgt`, `home`) VALUES ('200', 'edesktop', 'Mailing', 'mailing', 'index.php?option=com_edesktop&view=mailing&layout=exibir', 'component', '1', '0', '69', '0', '0', '0', '0000-00-00 00:00:00', '0', '0', '0', '0', 'page_title=
show_page_title=1
pageclass_sfx=
menu_image=-1
secure=0

', '0', '0', '0');

