
alter table PRD_ShiftDet add IsOvernight bit
go
update PRD_ShiftDet set IsOvernight = 0
go
alter table PRD_ShiftDet alter column IsOvernight bit not null
go
alter table PRD_WorkingCalendar add DayOfWeek tinyint
go
update PRD_WorkingCalendar set DayOfWeek = 0
go
alter table PRD_WorkingCalendar alter column DayOfWeek tinyint not null
go

--↓2012-11-21 库位工位物料对照  增加 库位 字段

alter table MD_LocationLayOut add Rack varchar(50)
--↑2012-11-21 库位工位物料对照  增加 库位 字段



insert into acc_permission values('Url_ProductionReceipt_View','生产收货单','Production')
insert into sys_menu values('Url_ProductionReceipt_View','生产收货单','Url_OrderMstr_Production','200','生产收货单','~/ProductionReceipt/Index','~/Content/Images/Nav/Default.png','1')

alter table kb_kanbanscan add OrderNo varchar(50)

update sys_menu set imageurl='~/Content/Images/Nav/Quality.png' where code='Menu.Quality'   

update sys_menu set imageurl='~/Content/Images/Nav/Info.png' where code='Menu.Quality.Info'   
update sys_menu set imageurl='~/Content/Images/Nav/Trans.png' where code='Menu.Quality.Trans'   
update sys_menu set imageurl='~/Content/Images/Nav/Setup.png' where code='Menu.Quality.Setup'   

insert into acc_permission values('Url_OrderMasterTaiFen_View','成台份序列指示票','Production')
insert into sys_menu values('Url_OrderMasterTaiFen_View','成台份序列指示票','Menu.Production.Info','30','成台份序列指示票','~/OrderMasterTaiFen/Index','~/Content/Images/Nav/Default.png','1')

