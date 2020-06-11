--创建表
CREATE TABLE employee
(
	id   VARCHAR2(4) NOT NULL,
	name VARCHAR2(15) NOT NULL,
	age  NUMBER(2) NOT NULL,
	sex  CHAR NOT NULL
);
DESC employee;
--插入数据
INSERT INTO employee VALUES('e101','zhao',23,'M');
INSERT INTO employee VALUES('e102','jian',21,'F');

--创建记录表
CREATE TABLE old_employee AS
SELECT * FROM employee;
DESC old_employee;

--创建触发器
CREATE OR REPLACE TRIGGER tig_old_emp
AFTER DELETE ON employee
FOR EACH ROW  --语句级触发，即每一行触发一次
BEGIN
	INSERT INTO old_employee
	VALUES(:old.id,:old.name,:old.age,:old.sex);  --:old代表旧值
END;

--下面进行测试
DELETE employee;
SELECT * FROM old_employee;
