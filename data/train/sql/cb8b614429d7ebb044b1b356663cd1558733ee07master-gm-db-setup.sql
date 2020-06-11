-- This document is the master SQL file for creating and 
-- initializing tables. 

DROP DATABASE IF EXISTS testGM;
CREATE DATABASE testGM;
USE testGM;

-- -----------------------------------------------------
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `user` ;

CREATE TABLE IF NOT EXISTS `user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(512) NOT NULL,
  `password` VARCHAR(32) NOT NULL,
  `fname` VARCHAR(128) NULL,
  `lname` VARCHAR(128) NULL,
  `create_date` DATETIME NOT NULL,
  `is_admin` TINYINT(1) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `pending_user`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pending_user` ;

CREATE TABLE IF NOT EXISTS `pending_user` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(512) NOT NULL,
  `password` VARCHAR(32) NOT NULL,
  `fname` VARCHAR(128) NULL,
  `lname` VARCHAR(128) NULL,
  `create_date` DATETIME NOT NULL,
  `position` TEXT NOT NULL,
  `reason` TEXT NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `explicit_content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `explicit_content` ;

CREATE TABLE IF NOT EXISTS `explicit_content` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `explicit_words` VARCHAR(128) NOT NULL UNIQUE,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `common_content`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `common_content` ;

CREATE TABLE IF NOT EXISTS `common_content` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `common_words` VARCHAR(128) NOT NULL UNIQUE,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `makes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS makes;

CREATE TABLE makes(
  make_id INT NOT NULL AUTO_INCREMENT,
  make_name varchar(128) NOT NULL UNIQUE,
  PRIMARY KEY(make_id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `models`
-- -----------------------------------------------------
DROP TABLE IF EXISTS models;
CREATE TABLE models(
  model_id INT NOT NULL AUTO_INCREMENT,
  make_id INT NOT NULL,
  model_name varchar(128) NOT NULL UNIQUE,
  PRIMARY KEY(model_id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `model_years`
-- -----------------------------------------------------
DROP TABLE IF EXISTS model_years;

CREATE TABLE model_years(
  year_id INT NOT NULL AUTO_INCREMENT,
  model_id INT NOT NULL,
  year_name varchar(128) NOT NULL,
  PRIMARY KEY(year_id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `make_alternates`
-- -----------------------------------------------------
DROP TABLE IF EXISTS make_alternates;

CREATE TABLE make_alternates(
  make_alternate_id INT NOT NULL AUTO_INCREMENT,
  make_id INT NOT NULL,
  make_alternate_name varchar(128) NOT NULL,
  PRIMARY KEY(make_alternate_id))
ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `model_alternates`
-- -----------------------------------------------------
DROP TABLE IF EXISTS model_alternates;

CREATE TABLE model_alternates(
  model_alternate_id INT NOT NULL AUTO_INCREMENT,
  model_id INT NOT NULL,
  model_alternate_name varchar(128) NOT NULL,
  PRIMARY KEY(model_alternate_id))
ENGINE = InnoDB;

-- -----------------------------------------------------
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Initial data
-- -----------------------------------------------------
START TRANSACTION;


INSERT INTO user (email, password, fname, lname, create_date, is_admin) VALUES ('admin@gm.com', '5f4dcc3b5aa765d61d8327deb882cf99', 'GM', 'Admin', '9999-12-31 23:59:59', '1');

INSERT INTO explicit_content (explicit_words) VALUES ('shit'),('fuck'),('damn'),('bitch'),('piss'),('dick'),('cock'),('pussy'),('asshole'),('fag'),('bastard'),('douche'),('ass'),('cunt'),('motherfucker'),('nigger'),('whore'),('dickhead');

INSERT INTO common_content (common_words) VALUE ('the'),('be'),('to'),('of'),('and'),('a'),('in'),('that'),('have'),('I'),('it'),('for'),('not'),('on'),('with'),('he'),('as'),('you'),('do'),('at'),('this'),('but'),('his'),('by'),('from'),('they'),('we'),('say'),('her'),('she');

INSERT INTO makes (make_name) VALUES ('Chevrolet'),('Buick'),('Cadillac'),('GMC');

INSERT INTO models (make_id, model_name) VALUES (1, 'Cruze'),(1, 'Sonic'),(1, 'Spark'),(1, 'Captiva'),(1, 'Colorado'),
                                                (1, 'Impala'),(1, 'Malibu'),(1, 'Camaro'),(1, 'Corvette'),(1, 'SS'),
                                                (1, 'Traverse'),(1, 'Tahoe'),(1, 'Suburban'),(1, 'Express'),(1, 'Trax'),
                                                (1, 'Savana'),(1, 'Avalanche'),(1, 'Silverado'),(1, 'Equinox');
INSERT INTO models (make_id, model_name) VALUES (2, 'Verano'),(2, 'Lacrosse'),(2, 'Regal'),(2, 'Encore'),(2, 'Enclave');
INSERT INTO models (make_id, model_name) VALUES (3, 'CTS'),(3, 'XTS'),(3, 'ATS'),(3,'CTS_V'),(3, 'SRX'),(3, 'Escalade');
INSERT INTO models (make_id, model_name) VALUES (4, 'Terrain'),(4, 'Acadia'),(4, 'Yukon'),(4, 'Sierra');

INSERT INTO model_years (model_id, year_name) VALUES (1, '2014'), (1, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (2, '2014'), (2, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (3, '2014'), (3, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (4, '2014'), (4, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (5, '2014'), (5, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (6, '2014'), (6, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (7, '2014'), (7, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (8, '2014'), (8, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (9, '2014'), (9, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (10, '2014'), (10, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (11, '2014'), (11, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (12, '2014'), (12, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (13, '2014'), (13, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (14, '2014'), (14, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (15, '2014'), (15, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (16, '2014'), (16, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (17, '2014'), (17, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (18, '2014'), (18, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (19, '2014'), (19, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (20, '2014'), (20, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (21, '2014'), (21, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (22, '2014'), (22, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (23, '2014'), (23, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (24, '2014'), (24, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (25, '2014'), (25, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (26, '2014'), (26, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (27, '2014'), (27, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (28, '2014'), (28, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (29, '2014'), (29, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (30, '2014'), (30, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (31, '2014'), (31, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (32, '2014'), (32, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (33, '2014'), (33, '2015');
INSERT INTO model_years (model_id, year_name) VALUES (34, '2014'), (34, '2015');

INSERT INTO make_alternates (make_id, make_alternate_name) VALUES (1, 'Chevy'),(3, 'Caddy');

INSERT INTO model_alternates (model_id, model_alternate_name) VALUES (9, 'Vette');


COMMIT;