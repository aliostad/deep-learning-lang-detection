-- Создание базы данных
CREATE DATABASE IF NOT EXISTS module7;
USE module7;


START TRANSACTION;
SELECT id, name FROM teachers;
INSERT INTO teachers (id, name) VALUES (17, 'Новый препад 17');
DELETE FROM teachers WHERE id = 11;
ROLLBACK;
COMMIT;


SET AUTOCOMMIT = 0;
INSERT INTO teachers (id, name) VALUES (18, 'Новый препад 18');

COMMIT;
SET AUTOCOMMIT = 1;


SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

SHOW GLOBAL VARIABLES LIKE "%iso%";
SHOW SESSION VARIABLES LIKE "%iso%";
--или
SELECT  @@tx_isolation; -- смотрим сессионный уровень транзакции


SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;



START TRANSACTION;
SELECT * FROM teachers;
INSERT INTO teachers (id, name) VALUES (100, 'Новый препад 100');