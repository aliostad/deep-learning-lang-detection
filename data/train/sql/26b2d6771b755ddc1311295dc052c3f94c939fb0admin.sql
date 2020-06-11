-- connect to server
-- 		mysql -u root -p test
--		mysql -h host -u user -p < batch_file.sql

-- disconnect
--		quit
--		exit

-- ignore current statement
--		\c

-- create a user account
USE mysql;
INSERT INTO user (host, user, password, select_priv, insert_priv, update_priv) 
           VALUES ('localhost', 'guest', PASSWORD('guest123'), 'Y', 'Y', 'Y');
FLUSH PRIVILEGES;
SELECT host, user, password FROM user WHERE user = 'guest';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP ON TUTORIALS.* TO 'guest'@'localhost' IDENTIFIED BY 'guest123';

-- investigate
USE my_database_name;
SHOW DATABASES;
SHOW TABLES;
SHOW COLUMNS FROM my_table_name;
SHOW INDEX FROM my_table_name;
SHOW CREATE TABLE my_table_name;
SHOW TABLE STATUS LIKE 'my_table_name';
DESCRIBE my_table_name;

-- current database
SELECT DATABASE();

-- data export
SELECT * FROM tutorials_tbl INTO OUTFILE './tutorials.txt';
SELECT * FROM animals INTO OUTFILE './animals.txt' FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\r\n';
-- mysqldump -u root -p database_name table_name > dump.txt
-- mysqldump -u root -p database_name > database_dump.txt
-- mysqldump -u root -p --all-databases > database_dump.txt

-- data import
LOAD DATA LOCAL INFILE '/path/dump.txt' INTO TABLE pet;
LOAD DATA LOCAL INFILE '/path/dump.txt' INTO TABLE pet FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n';	-- windows specific
LOAD DATA LOCAL INFILE 'dump.txt' INTO TABLE mytbl (b, c, a);
-- mysql -u root -p database_name < dump.txt
-- mysqlimport -u root -p --local database_name dump.txt
-- mysqlimport -u root -p --local --fields-terminated-by=":" --lines-terminated-by="\r\n"  database_name dump.txt
-- mysqlimport -u root -p --local --columns=b,c,a database_name dump.txt