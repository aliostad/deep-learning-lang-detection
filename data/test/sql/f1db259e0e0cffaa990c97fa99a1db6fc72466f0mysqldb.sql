-- MYSQL TestDB

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=1;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=1;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

-- create users table

DROP TABLE IF EXISTS TestDB.Users;

CREATE TABLE IF NOT EXISTS TestDB.Users (
    uid VARCHAR(50) NOT NULL,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    age INT(3) NOT NULL,
    pass VARCHAR(50) NOT NULL,
    perms VARCHAR(50) NOT NULL,
    PRIMARY KEY (uid)
) ENGINE=InnoDB;

-- populate users data (in real world, consider storing encrypted passwords)

LOCK TABLES TestDB.Users WRITE;

INSERT INTO TestDB.Users VALUES
    ('admin', 'Admin', 'User', 40, 'admin', 'CREATE|READ|UPDATE|DELETE|PERMS'),
    ('super', 'Super', 'User', 30, 'super', 'CREATE|READ|PERMS'),
    ('john', 'John', 'Doe', 20, 'john', 'READ|UPDATE'),
    ('jane', 'Jane', 'Doe', 10, 'jane', 'READ|UPDATE');

UNLOCK TABLES;
