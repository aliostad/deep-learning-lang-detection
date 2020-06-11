DROP DATABASE IF EXISTS cipher_member_db;
CREATE DATABASE cipher_member_db;
USE cipher_member_db;


DROP TABLE IF EXISTS card_record;


CREATE TABLE card_record
(
    card_id        BIGINT        NOT NULL, 
    date_created   TIMESTAMP     NOT NULL,
    PRIMARY KEY (card_id, date_created)
);



-- SHOW DATABASES;
SHOW TABLES;
-- SHOW COLUMNS FROM model;
-- SHOW COLUMNS FROM node;
-- SHOW COLUMNS FROM link;
-- SHOW COLUMNS FROM parameter;
-- SHOW COLUMNS FROM study;
-- SHOW COLUMNS FROM study_question;
-- SHOW COLUMNS FROM user;
-- SHOW COLUMNS FROM user_study;
-- SHOW COLUMNS FROM user_scenario;
-- SHOW COLUMNS FROM user_study_parm;
-- SHOW COLUMNS FROM user_config;  