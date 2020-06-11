--1、SQL语句优化
	--如果mysql对服务器影响特别大，先看慢查询日志，获得sql语句，通过该sql语句执行，获得执行时间，看是否需要加索引等其它优化
	show satus;--查看服务器状态
	show status like 'Com_%';
	show status like 'Com_select%';--查看用户登录以来到现在执行select次数
	show status like 'Com_insert%';----------------insert....
	show status like 'Com_update%';--.......
	show status like 'Com_delete%';--...............

	show session status;
	show global status;--显示服务器启动以来，执行sql语句的次数
	show global status like 'Com_select%';--显示服务器启动以来，执行select语句的次数
	show global status like 'Com_insert%';----------------insert....
	show global status like 'Com_update%';--.......
	show global status like 'Com_delete%';--...............
	
	--查看innodb执行的sql所影响的行数(用户登录以来)
	show status like 'innodb_rows%';
	show status like 'connection';--连接mysq的次数(包括成功与失败次数)
	show status like 'uptime';--服务器从启动以来到现在的工作时间
	show status like 'slow_queries';--查看慢查询次数(慢查询的默认时间：10秒,超过10会记录到慢查询日志中去)
	show variables like '%slow%';--查看慢查询是否开启,一般建议开启
	
	--sql语句解析(分析查询)
	 desc select * from tname; --等同于
	 explain select * from tname;
	 --通过上面的解析，可以看出影响的行数，是否用到索引
	 
	
	
	
	
	
	
	
	
	
	
	
	
	
	
