
--田博士 我总结了些 错误的旧档案编号类型：
--非 Z,L,2，G,F,HK,XB,XY的    ；  ---上次已经查了,那40几个
select old,* from files where 
	id not in (select id from files where old like 'z%')
and id not in (select id from files where old like 'l%')	
and id not in (select id from files where old like '2%')	
and id not in (select id from files where old like 'g%')	
and id not in (select id from files where old like 'hk%')	
and id not in (select id from files where old like 'xy%')	
and id not in (select id from files where old like 'xb%')	
and old<>''
--Z里面无-的，
select old,* from files where 
	old like 'z%' and old not like '%-%' 
--Z-后面无数字或者多其他字母或符号的，-- 做不到;
--Z后面两个以上（含两个）-的   ；  
select old,* from files where 
	old like 'z%' and old like '%-%-%' 
	
--2开头的旧档案编号一定都是8位数的数字不能多于也不能少于  ； 
select old,* from files where 
	old like '2%' and LEN(old)<>8
--HK 里面只能有一个-，HK后面两个以上（含两个）-的或还含其他符号或字母的就不行    ； 
select old,* from files where 
	old like 'hk%' and old like '%-%-%' 
--XB和XY里面只能有一个-，XB或XY后面两个以上（含两个）-的或还含其他符号或字母的就不行   ；  
select old,* from files where 
	old like 'x%' and ( old like '%-%-%' )
--另外，Z和L和2开头的就档案编号里均不能含中文 --- 做不了


