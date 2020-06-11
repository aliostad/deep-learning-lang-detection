UPDATE `srp_new`.`tipo_mpo` SET `nome`='MPO ou GCO - Prospecção Caixa Crescer' WHERE `id`='1';
UPDATE `srp_new`.`tipo_mpo` SET `nome`='MPO ou GCO - Renovação Caixa Crescer' WHERE `id`='2';
UPDATE `srp_new`.`tipo_mpo` SET `nome`='MPO ou GCO - Caixa Renovação' WHERE `id`='3';
INSERT INTO `srp_new`.`tipo_mpo` (`nome`, `ativo`) VALUES ('Somente Seguro', '1');
INSERT INTO `srp_new`.`tipo_mpo` (`nome`, `ativo`) VALUES ('Orientação', '1');


ALTER TABLE `srp_new`.`producao`
CHANGE COLUMN `id_status_contrato` `id_status_contrato` INT(11) NULL ;
