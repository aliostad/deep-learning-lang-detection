-- ---------------------------------------------------------------------------
-- Table t_model_data
--
-- Each repository model has versionable name and description properties.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `t_model_data` (
    `model_uuid` BINARY(16) NOT NULL,
    `name` VARCHAR(45) NOT NULL,
    `description` VARCHAR(255) NULL DEFAULT NULL,
    `version_uuid` BINARY(16) NOT NULL DEFAULT 0,
    PRIMARY KEY (`model_uuid`, `version_uuid`),
    CONSTRAINT `fk_model_data_version`
        FOREIGN KEY (`version_uuid` )
        REFERENCES `t_version` (`uuid` )
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_model_data_model`
        FOREIGN KEY (`model_uuid` )
        REFERENCES `t_model` (`uuid` )
        ON DELETE NO ACTION
        ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_model_data_model` ON `t_model_data` (`model_uuid` ASC);
CREATE INDEX `fk_model_data_version` ON `t_model_data` (`version_uuid` ASC);
CREATE UNIQUE INDEX `model_data_version_uuid_unique` ON `t_model_data` (`version_uuid` ASC);

delimiter ;;
CREATE TRIGGER tr_before_model_data_insert BEFORE INSERT ON t_model_data
FOR EACH ROW 
    BEGIN
        SET NEW.version_uuid = NEW_VERSION();
    END;;
delimiter ;

