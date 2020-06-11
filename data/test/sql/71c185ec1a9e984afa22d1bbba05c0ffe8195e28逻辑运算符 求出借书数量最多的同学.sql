USE XSBOOK
IF EXISTS(SELECT name
	FROM sysobjects
	WHERE name='view_select' and type='V')
DROP VIEW view_select
GO
/* 以上语句的作用为:判断view_select是否已经还在,若已存在则把它删除 */
/*
CREATE VIEW view_select
	AS
	SELECT JY.借书证号,姓名,BOOK.书名,COUNT(索书号) AS 借书数量
	FROM JY, BOOK,XS
	WHERE BOOK.ISBN=JY.ISBN AND JY.借书证号=XS.借书证号
	GROUP BY  JY.借书证号,书名,姓名
GO */


CREATE VIEW view_select /* 创建视图 */
	AS 
	SELECT 借书证号,COUNT(索书号) AS 借书数量
	FROM JY
	GROUP BY 借书证号
GO 

SELECT XS.借书证号,姓名,借书数量
	FROM XS,view_select
	WHERE XS.借书证号=view_select.借书证号 and 借书数量>=ALL  /* 求借书数量最大的 */
		(SELECT 借书数量
			FROM view_select 
		)


 