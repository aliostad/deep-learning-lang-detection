insert into sys_menu values ('Menu.Kanban.Trans','事务','Menu.Kanban',4000,'事务','','~/Content/Images/Nav/Trans.png',1)
insert into sys_menu values ('Url_KanbanCard_Kanban_View','看板卡查询','Menu.Kanban.Info',1000,'Url_KanbanCard_Kanban_View','~/KanbanCard/Index','~/Content/Images/Nav/Default.png',1)
insert into sys_menu values ('Url_KanbanCard_New','创建看板卡','Menu.Kanban.Trans',6000,'创建看板卡','~/KanbanCard/New','~/Content/Images/Nav/Default.png',1)
insert into sys_menu values ('Url_KanbanCard_Scan','扫描看板卡','Menu.Kanban.Trans',4000,'扫描看板卡','~/KanbanCard/Scan','~/Content/Images/Nav/Default.png',1)
insert into sys_menu values ('Url_KanbanScan_View','扫描记录','Menu.Kanban.Info',2000,'扫描记录','~/KanbanScan/Index','~/Content/Images/Nav/Default.png',1)
insert into sys_menu values ('Menu.Kanban.Info','信息','Menu.Kanban',5000,'信息','','~/Content/Images/Nav/Info.png',1)
insert into sys_menu values ('Menu.Kanban','实体看板',NULL,6000,'实体看板',null,'~/Content/Images/Nav/Procurement.png',1)
go
insert into acc_permissioncategory  values('Kanban','实体看板',1)
go

insert into acc_permission values('Url_KanbanCard_Kanban_View','看板卡查询','Kanban')
insert into acc_permission values('Url_KanbanCard_New','创建看板卡','Kanban')
insert into acc_permission values('Url_KanbanCard_Scan','扫描看板卡','Kanban')
insert into acc_permission values('Url_KanbanScan_View','扫描记录','Kanban')
go

alter table scm_flowdet add CycloidAmount int null
go
update scm_flowdet set cycloidamount=0 where cycloidamount is null
go



