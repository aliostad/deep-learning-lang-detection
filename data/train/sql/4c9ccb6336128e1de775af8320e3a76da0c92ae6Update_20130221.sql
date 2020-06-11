update SYS_Menu set Seq=Seq*10 
go
insert into SYS_Menu values('Url_SpecialTime_WorkView','加班时间','Menu.Sequence.Setup',5075,'加班时间','~/SpecialTime/WorkIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SpecialTime_WorkView','加班时间','Production')

go
update sys_menu set name ='箱柜结构查询',desc1 ='箱柜结构查询' where code ='Url_CkdContainer_View'
update acc_permission set desc1 ='箱柜结构查询' where code ='Url_CkdContainer_View'
go
insert into sys_menu values
('Url_CkdCaseContainer_View','箱柜查询','Menu.CKD.Info',11,'箱柜查询','~/CkdCaseContainer/Index','~/Content/Images/Nav/Default.png',1)
 
insert into acc_permission values('Url_CkdCaseContainer_View','箱柜查询','CKD')

go
delete from sys_codedet where code ='ContainerType' and value not in(0,1)
go
insert into acc_permission values('Url_COGI_Close','关闭COGI','Inventory')
go
alter table LOG_JITOrderTrace add ItemDesc varchar(100)
alter table LOG_JITOrderBomTrace add ItemDesc varchar(100)
go