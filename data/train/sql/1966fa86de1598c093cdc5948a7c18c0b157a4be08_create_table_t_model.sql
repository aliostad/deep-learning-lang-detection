-- ---------------------------------------------------------------------------
-- Table t_model
--
-- Each repository model represents a manipulatable user-defined data model
-- most commonly reflected in programmed code as a standard Class or Object.
-- ---------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `t_model` (
    `uuid` BINARY(16) NOT NULL DEFAULT 0,
    `version_uuid` BINARY(16) NOT NULL DEFAULT 0,
    PRIMARY KEY (`uuid`, `version_uuid`),
    CONSTRAINT `fk_model_version`
        FOREIGN KEY (`version_uuid` )
        REFERENCES `t_version` (`uuid`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX `fk_model_version` ON `t_model` (`version_uuid` ASC);
CREATE UNIQUE INDEX `model_version_uuid_unique` ON `t_model` (`version_uuid` ASC);

delimiter ;;
CREATE TRIGGER tr_before_model_insert BEFORE INSERT ON t_model
FOR EACH ROW 
    BEGIN
        DECLARE new_uuid BINARY(16);
        IF (NEW.uuid = 0) THEN
            SET new_uuid = UNHEX(REPLACE(UUID(), '-', ''));
            SET NEW.uuid = new_uuid;
            SET @LAST_INSERT_UUID = new_uuid;
        END IF;
        SET NEW.version_uuid = NEW_VERSION();
    END;;
delimiter ;

