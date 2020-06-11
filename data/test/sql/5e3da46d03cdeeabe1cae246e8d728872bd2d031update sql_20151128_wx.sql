insert into SYS_Menu values('Url_PickTask','拣货任务','Url_WMS_Trans',100,'高级仓库-事务-拣货任务',null,'~/Content/Images/Nav/Default.png',1)
insert into SYS_Menu values('Url_RepackTask','翻箱任务','Url_WMS_Trans',200,'高级仓库-事务-翻箱任务',null,'~/Content/Images/Nav/Default.png',1)
insert into SYS_Menu values('Url_ShipPlan','发货任务','Url_WMS_Trans',300,'高级仓库-事务-发货任务',null,'~/Content/Images/Nav/Default.png',1)


update SYS_Menu set Name='查询' ,seq=100,parent='Url_RepackTask',desc1='高级仓库-事务-翻包任务-查询' where code='Url_RepackTask_View'
update SYS_Menu set Name='查询' ,seq=100,parent='Url_PickTask',desc1='高级仓库-事务-拣货任务-查询' where code='Url_PickTask_View'
update SYS_Menu set name='查询' ,seq=100,parent='Url_ShipPlan',desc1='高级仓库-事务-发货任务-查询'  where code='Url_ShipPlan_View'

update SYS_Menu set name='翻包结果',desc1='高级仓库-事务-翻包结果' where code='Url_RepackResult_View'
update SYS_Menu set name='翻包任务',desc1='高级仓库-事务-翻包任务' where code='Url_RepackTask'
