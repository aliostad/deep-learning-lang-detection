CREATE  TABLE `mycrm`.`nav_category` (
  `id` BIGINT NOT NULL ,
  `label` VARCHAR(45) NULL ,
  `account` VARCHAR(45) NULL ,
  `seq_number` INT NULL ,
  `delete_flag` INT NULL ,
  `last_modified_by` VARCHAR(45) NULL ,
  `created` TIMESTAMP NULL ,
  `last_modified` TIMESTAMP NULL ,
  `created_by` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) );

CREATE  TABLE `mycrm`.`nav_form` (
  `id` BIGINT NOT NULL ,
  `nav_category_id` BIGINT NULL ,
  `form_metadata_id` BIGINT NULL ,
  `related_nav_form_id` BIGINT NULL ,
  `type` INT NULL ,
  `account` VARCHAR(45) NULL ,
  `label` VARCHAR(45) NULL ,
  `url` VARCHAR(45) NULL ,
  `seq_number` INT NULL ,
  `last_modified_by` VARCHAR(45) NULL ,
  `created` TIMESTAMP NULL ,
  `last_modified` TIMESTAMP NULL ,
  `created_by` VARCHAR(45) NULL ,
  PRIMARY KEY (`id`) );

ALTER TABLE `mycrm`.`form_metadata` CHANGE COLUMN `seq_number` `seq_number` INT NULL DEFAULT NULL  , ADD COLUMN `nav_category_id` VARCHAR(45) NULL  AFTER `seq_number` ;