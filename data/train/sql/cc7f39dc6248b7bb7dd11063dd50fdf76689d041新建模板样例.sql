/*=================================================== 拷贝模板 ===============================================================
--拷贝模板数据
select *
INTO DI_MODEL_0717
FROM DI_MODEL
where MODEL_ID in ('3','4','5','6','8','9');

--更新拷贝的模板数据
update DI_MODEL_0717 set MODEL_ID = 'dihonr_'+MODEL_ID, MODEL_NAME=MODEL_NAME + '_滇红',DYNAMIC_DATA_TABLE = 'dihonr_' + DYNAMIC_DATA_TABLE;

select * from DI_MODEL_0717;

--拷贝回模板数据
insert into DI_MODEL 
select * from DI_MODEL_0717;

select * from DI_MODEL;

--删除临时表
drop Table DI_MODEL_0717;

*/

/*=================================================== 拷贝模板字段 ===============================================================
--拷贝模板字段数据
select *
INTO DI_MODEL_FIELD_0717
FROM DI_MODEL_FIELD
where MODEL_ID in ('3','4','5','6','8','9');

--设置必填和强制校验
update DI_MODEL_FIELD_0717 set REQUIRE = '1', FORCED_CHECK='1' where FIELD_NAME in ('产品规格','产品批号')
--更新id
update DI_MODEL_FIELD_0717 set FIELD_ID = 'dihonr_' + FIELD_ID;



select * from DI_MODEL_FIELD_0717;

--拷贝回模板字段表
insert into DI_MODEL_FIELD 
select * from DI_MODEL_FIELD_0717;

select * from DI_MODEL_FIELD;


UPDATE DI_MODEL_FIELD
SET MODEL_ID ='dihonr_' +  MODEL_ID
WHERE FIELD_ID LIKE 'dihonr_%'

SELECT *
FROM DI_MODEL_FIELD
WHERE FIELD_ID LIKE 'dihonr_%'

--删除临时表
drop Table DI_MODEL_FIELD_0717;
*/


/*=================================================== 建立新模板关系 ===============================================================

select * from DI_SCHEME_MODEL_REF where SCHEME_ID='dihonr';

--停止DI服务后，再更新关联关系。
update DI_SCHEME_MODEL_REF set MODEL_ID = 'dihonr_' + MODEL_ID where SCHEME_ID='dihonr' and  MODEL_ID in ('3','4','5','6','8','9');

*/

/*=================================================== 建立动态表关系 ===============================================================

select top 0 * into dihonr_DI_DYNAMIC_T_3
from DI_DYNAMIC_T_3

select top 0 * into dihonr_DI_DYNAMIC_T_4
from DI_DYNAMIC_T_4

select top 0 * into dihonr_DI_DYNAMIC_T_5
from DI_DYNAMIC_T_5

select top 0 * into dihonr_DI_DYNAMIC_T_6
from DI_DYNAMIC_T_6

select top 0 * into dihonr_DI_DYNAMIC_T_8
from DI_DYNAMIC_T_8

select top 0 * into dihonr_DI_DYNAMIC_T_9
from DI_DYNAMIC_T_9

*/




