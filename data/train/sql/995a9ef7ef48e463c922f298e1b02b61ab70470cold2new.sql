----------------------!!!!!!!!
--- add old2 for files
alter table files add old2 nvarchar(50)
update files set old = replace(old,'ll','l') where old like 'll%'
update files set old = REPLACE(old,'l-','l') where old like 'l-%'

----------------------

select old,* from dbo.files where old<>'' ---- 83323
---------------------------------------------------
select old,* from files where 
	id not in (select id from files where old like 'z%')
and id not in (select id from files where old like 'l%')	
and id not in (select id from files where old like '2%')	
and id not in (select id from files where old like 'g%')	
and id not in (select id from files where old like 'hk%')	
and id not in (select id from files where old like 'xy%')	
and id not in (select id from files where old like 'xb%')	
and old<>''
-------------------------------------------------  15 (05,08,10,31,ce,b,.z,无,马巍)
select old,* from files where old like 'z%' ---- 55934
select old,* from files where old like 'l%' ---- 16135 --- 2010及以前 L10:3388+ L0:12268
select old,* from files where old like '2%' ---- 2016 ---- 2011及以后
select old,* from files where old like 'g%' ---- 881
select old,* from files where old like 'hk%' ---- 556
select old,* from files where old like 'xy%' ---- 2546
select old,* from files where old like 'xb%' ---- 5240
---------------------------------------------------- 83308
--====================================================================================
/*
按分类加前缀
注意需要处理数字补位以及L,2为同一分类及顺序关系
*/
--- pre proc
update files set old=REPLACE(old,' ','') --- remove blanks
update files set old=REPLACE(old,'、','') --- remove '、'

---------------------- Z:55934
select old,* from files where old like 'z%' ---- 55934
select old, left(old,2),
	left(SUBSTRING(old,3,len(old)-2),5),
	replace(space(5-len( left(SUBSTRING(old,3,len(old)-2),5) )),' ','0')+left(SUBSTRING(old,3,len(old)-2),5) 
from files where old like 'z%'
---------------------------------------- L:16135 L:2010及以前 L10(L1):3388+ L0:12268+ other:29  = 15685 少450个?
select old,* from files where old like 'l%' and old not like 'l0%' and old not like 'l1%'
select old,* from files where old like 'l%' and LEN(old)=8 ---- 16135 (8位LL,L-;7:15040; 6:1074;5...)
---update files set old = replace(old,'ll','l') where old like 'll%'
---update files set old = REPLACE(old,'l-','l') where old like 'l-%'
select max(LEN(old)),MIN(len(old)) from files where old like 'l%'  and LEN(old)>4 --8,3
select old, left(old,1),
	left(SUBSTRING(old,2,len(old)-1),8),
	replace(space(8-len( left(SUBSTRING(old,2,len(old)-1),8) )),' ','0')+ left(SUBSTRING(old,2,len(old)-1),8) 
from files where old like 'l%'

------------------------------------------ 2:2016
select old,* from files where old like '2%' and LEN(old)=5 ---- 2016 ---- 9:1;8:2013;7:1;5:1(垃圾) (2011及以后:2015; '22222':1;)
select MAX(len(old)),MIN(len(old)) from files where old like '2%' ---9,5 !!!!!

select old, left(old,1),
	left(SUBSTRING(old,2,len(old)-1),8),
	replace(space(8-len( left(SUBSTRING(old,2,len(old)-1),8) )),' ','0')+ left(SUBSTRING(old,2,len(old)-1),8) 
from files where old like '2%' and LEN(old)=5
------------------------------------------- g:881 不需要补位(同前缀下已经补好了)
select old,* from files where old like 'g%' order by old ---- 881(8:59;7:820;4:2)
select MAX(len(old)),MIN(len(old)) from files where old like 'g%' ---8,4

------------------------------------------- hk
select old,* from files where old like 'hk%' order by old ---- 556

select MAX(len(old)),MIN(len(old)) from files where old like 'hk%' ---12,8

----=========================================
select 
	old, 
	CHARINDEX('-',old),
	SUBSTRING(old,0,CHARINDEX('-',old)),
	SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old)),
	replace( (SPACE(4-len(SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old))))+SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old))),' ','0'),
	SUBSTRING(old,0,CHARINDEX('-',old))+replace( (SPACE(4-len(SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old))))+SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old))),' ','0')
from files where old like 'x%'

select 
	max(len( SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old)) ))
from files where old like 'xy%'


select 
	CHARINDEX('-',old),
	SUBSTRING(old,0,CHARINDEX('-',old)),
	SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old))
from files where old like 'xy%' and len( SUBSTRING(old,CHARINDEX('-',old)+1,LEN(old)-CHARINDEX('-',old)) )=10


---================================================= xy/xb (盘库只看存在否)
------------------------------------------- xy
select old,* from files where old like 'xy%' order by old ---- 2546
select MAX(len(old)),MIN(len(old)) from files where old like 'xy%' --- 20,10

------------------------------------------- xb
select old,* from files where old like 'xb%' order by old ---- 5240 
select MAX(len(old)),MIN(len(old)) from files where old like 'xb%' --- 15,9


------------------------------------------- f:有没有 和 g 为两堆但挨着
select old,* from files where old like 'f%' order by old ---- 881(8:59;7:820;4:2)
select MAX(len(old)),MIN(len(old)) from files where old like 'f%' ---8,4



