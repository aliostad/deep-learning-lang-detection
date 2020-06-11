### 说明: 下文中涉及章节的引用均来自MySQL 5.6 Reference Manual


/**************************************************************************
*** 系统变量
*** 变量解释: 		Chapter 5 MySQL Server Administration 	5.1.4 Server System Variables
*** SHOW语法: 	Chapter 13 SQL Statement Syntax 			13.7.5 SHOW Syntax
**************************************************************************/
# 查看变量
SHOW VARIABLES;
SHOW VARIABLES LIKE 'AUTOCOMMIT';

SHOW GLOBAL VARIABLES;
SHOW SESSION VARIABLES;

# 从information_schema中查看
SELECT * FROM information_schema.GLOBAL_VARIABLES;
SELECT * FROM information_schema.SESSION_VARIABLES;

/**************************************************************************
*** 系统状态
*** 变量解释: Chapter 5 MySQL Server Administration 5.1.6 Server Status Variables
**************************************************************************/
SHOW STATUS;
SHOW STATUS LIKE 'Open_files';
SHOW STATUS WHERE `VARIABLE_NAME` IN ('Connections');

SHOW GLOBAL STATUS;
SHOW SESSION STATUS;

# 从information_schema中查看
SELECT * FROM information_schema.GLOBAL_STATUS;
SELECT * FROM information_schema.SESSION_STATUS;

# 线程和链接
SHOW GLOBAL STATUS LIKE '%onnect%';			# 连接
SHOW FULL PROCESSLIST;								#  连接或线程
SHOW GLOBAL STATUS LIKE '%hread%';			# 线程
SHOW GLOBAL STATUS LIKE 'Bytes_%';			# 字节计数
SHOW GLOBAL STATUS LIKE 'Aborted_%';			# 终止计数


SHOW GLOBAL STATUS LIKE 'Binlog_%';			# 二进制日志状态
SHOW GLOBAL STATUS LIKE 'Com_%';				# 命令计数器
SHOW GLOBAL STATUS LIKE 'Created_tmp%';	# 临时文件和表	
SHOW GLOBAL STATUS LIKE 'Handler_%';			# 句柄(MySQL与存储引擎的接口)
SHOW GLOBAL STATUS LIKE 'Key_%';				# MyISAM键缓冲
SHOW GLOBAL STATUS LIKE 'Open_%'; 			# 文件描述符
SHOW GLOBAL STATUS LIKE 'Qcache_%';			# 查询缓存
SHOW GLOBAL STATUS LIKE 'Select_%'; 			# 查询类型
SHOW GLOBAL STATUS LIKE 'Sort_%';				# 排序
SHOW GLOBAL STATUS LIKE 'Table_locks_%';	# 表锁(服务器级别, 不是存储引擎级别)

# InnoDB相关
SHOW ENGINE INNODB STATUS; 
SHOW GLOBAL STATUS LIKE 'Innodb_%';
SHOW ENGINE INNODB MUTEX;						# 互斥体 



# 查看schema
SELECT * FROM information_schema.SCHEMATA;
/**************************************************************************
*** 信息Schema
*** Chapter 21 INFORMATION_SCHEMA Tables
**************************************************************************/
# 信息Schema中表
SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'information_schema';
SHOW TABLES FROM information_schema;

# 查看表空间
SELECT * FROM information_schema.TABLESPACES;
# 查看表
SELECT * FROM information_schema.TABLES;
# 查看表约束
SELECT * FROM information_schema.TABLE_CONSTRAINTS;
# 查看表中字段
SELECT COLUMN_NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT 
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA='sys'  AND TABLE_NAME='sys_config'
ORDER BY COLUMN_NAME -- ORDINAL_POSITION
;

/**************************************************************************
*** 性能Schema
*** Chapter 22 MySQL Performance Schema
**************************************************************************/
# 信息Schema中表
SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'performance_schema';

