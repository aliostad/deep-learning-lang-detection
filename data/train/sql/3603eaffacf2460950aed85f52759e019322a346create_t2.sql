/********************************************************************************/
/*                                                                              */
/* Copyright by Author Sajal Dam, ISBN 1590594215                               */
/*                                                                              */
/********************************************************************************/

--Create table t2
IF(SELECT OBJECT_ID('t2')) IS NOT NULL
  DROP TABLE t2
GO
CREATE TABLE t2(c1 INT, c2 INT, Data CHAR(1), Modifier CHAR(10))
CREATE INDEX i_c1 ON t2(c1)
INSERT INTO t2 VALUES(11, 12, '', '')
GO

--Use of NOLOCK hint
INSERT INTO t2			--Dirty read NOT allowed
  SELECT * FROM t1 WITH(NOLOCK)	--Dirty read applicable for data
				-- selection only

UPDATE t2		--Dirty read NOT allowed
  SET t2.data = ''
  FROM t2 INNER JOIN
       t1 WITH(NOLOCK)	--Dirty read applicable for data selection only
    ON t2.c1 = t1.c1

DELETE t2		--Dirty read NOT allowed
  FROM t2 INNER JOIN
       t1 WITH(NOLOCK)	--Dirty read applicable for data selection only
    ON t2.c1 = t1.c1
