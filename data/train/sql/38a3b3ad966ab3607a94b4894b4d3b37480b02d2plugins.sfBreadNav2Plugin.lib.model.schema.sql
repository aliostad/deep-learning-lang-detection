
# This is a fix for InnoDB in MySQL >= 4.1.x
# It "suspends judgement" for fkey relationships until are tables are set.
SET FOREIGN_KEY_CHECKS = 0;

#-----------------------------------------------------------------------------
#-- sf_BreadNav
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `sf_BreadNav`;


CREATE TABLE `sf_BreadNav`
(
	`id` INTEGER  NOT NULL AUTO_INCREMENT,
	`page` VARCHAR(255)  NOT NULL,
	`title` VARCHAR(255)  NOT NULL,
	`module` VARCHAR(128)  NOT NULL,
	`action` VARCHAR(128)  NOT NULL,
	`credential` VARCHAR(128),
	`catchall` TINYINT,
	`tree_left` INTEGER  NOT NULL,
	`tree_right` INTEGER  NOT NULL,
	`tree_parent` INTEGER  NOT NULL,
	`scope` INTEGER  NOT NULL,
	PRIMARY KEY (`id`),
	INDEX `sf_BreadNav_FI_1` (`scope`),
	CONSTRAINT `sf_BreadNav_FK_1`
		FOREIGN KEY (`scope`)
		REFERENCES `sf_BreadNav_Application` (`id`)
		ON DELETE CASCADE
)Type=InnoDB;

#-----------------------------------------------------------------------------
#-- sf_BreadNav_Application
#-----------------------------------------------------------------------------

DROP TABLE IF EXISTS `sf_BreadNav_Application`;


CREATE TABLE `sf_BreadNav_Application`
(
	`id` INTEGER  NOT NULL AUTO_INCREMENT,
	`user_id` INTEGER,
	`name` VARCHAR(255)  NOT NULL,
	`application` VARCHAR(255)  NOT NULL,
	`css` VARCHAR(2000)  NOT NULL,
	PRIMARY KEY (`id`)
)Type=InnoDB;

# This restores the fkey checks, after having unset them earlier
SET FOREIGN_KEY_CHECKS = 1;
