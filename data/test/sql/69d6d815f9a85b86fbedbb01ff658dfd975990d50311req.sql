/*
3、“攻读学位”加“其它”，旧数据的
留学身份
对应的是新数据的攻读学位，
且对应关系是 
大学专科——大专文凭，
大学在读和大学本科——学士学位，
硕士研究生、硕士在读——硕士学位，
博士研究生——博士学位。
old studystatus
待定	wh01 -->其他 xw06
大学专科  	wh02-->大专 xw04
大学在读  	wh03-->学士 xw05
大学本科  	wh04-->学士 xw05
硕士研究生在读	wh05-->硕士xw02
硕士研究生	wh06-->硕士 xw02
博士研究生	wh07-->博士 xw03
访问学者  	wh08-->其他 xw06
其它      	wh09-->其他 xw06
博士后	wh10-->其他 xw06
高中      	wh11-->其他 xw06
本硕连读  	wh13-->其他 xw06
初中  	wh14-->其他 xw06
-----------------------
2	xw04	大专文凭	1
3	xw05	学士学位	2
4	xw02	硕士学位	3
5	xw03	博士学位	4
7	xw06	其他	0

攻读学位 Studystatus_new 对应res: res_Studystatus_new 新建
留学前文化程度  Wenhua_New 对应res: res_wenhua_new ok
*/


delete from archives_new.dbo.res_studystatus_new where code='xw06' and name='其它';
insert into archives_new.dbo.res_studystatus_new(code,name) values('xw06','其它');

------------------

/*
待定	wh01 -->其他 xw06
大学专科  	wh02 -->专科 xw04
大学在读  	wh03 -->学士 xw05
大学本科  	wh04 -->学士 xw05
硕士研究生在读	wh05 -->硕士 xw02
硕士研究生	wh06 -->硕士 xw02
博士研究生	wh07 -->博士 xw03
访问学者  	wh08 -->其他 xw06
其它      	wh09 -->其他 xw06
博士后		wh10 -->其他 xw06
高中      	wh11 -->其他 xw06
本硕连读  	wh13 -->其他 xw02
初中  		wh14 -->其他 xw06
*/

-->其他 xw06
update files set studystatus_new='xw06' where studystatus in('wh01','wh08','wh09','wh10','wh11','wh13','wh14')
-->专科 xw04
update files set studystatus_new='xw04' where studystatus in('wh02')
-->学士 xw05
update files set studystatus_new='xw05' where studystatus in('wh03','wh04')
-->硕士 xw02
update files set studystatus_new='xw02' where studystatus in('wh05','wh06')
-->博士 xw03
update files set studystatus_new='xw03' where studystatus in('wh07')
;


--select * from res_studystatus_new
-------------------
delete from res_studystatus_new where code='xw06'
insert into res_studystatus_new(code,name, ordervalue)values('xw06','其它',5)


------------------------------------
/*
select * from archives_new.dbo.res_studystatus_new
select * from archives_new.dbo.res_wenhua_new
select * from archives.dbo.codelist where code like 'wh%'
*/