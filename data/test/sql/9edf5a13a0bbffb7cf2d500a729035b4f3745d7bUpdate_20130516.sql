alter table  PRD_EOSwitch add UpdateUserId int null
alter table  PRD_EOSwitch add UpdateUserName  varchar(50) null
alter table  PRD_EOSwitch add UpdateDate	varchar(50) null

alter table  PRD_ItemConsume add UpdateUserId int null
alter table  PRD_ItemConsume add UpdateUserName  varchar(50) null
alter table  PRD_ItemConsume add UpdateDate	varchar(50) null

alter table  PRD_POChange add UpdateUserId int null
alter table  PRD_POChange add UpdateUserName  varchar(50) null
alter table  PRD_POChange add UpdateDate	varchar(50) null

alter table  PRD_VanDiff add UpdateUserId int null
alter table  PRD_VanDiff add UpdateUserName  varchar(50) null
alter table  PRD_VanDiff add UpdateDate	varchar(50) null


insert into SYS_CodeMstr values('OperationType','操作类型',0)
go
insert into SYS_CodeDet values('OperationType',0,'CodeDetail_OperationType_New',1,1)
go
insert into SYS_CodeDet values('OperationType',1,'CodeDetail_OperationType_Edit',0,2)
go
insert into SYS_CodeDet values('OperationType',2,'CodeDetail_OperationType_Close',0,3)
go
insert into SYS_CodeDet values('OperationType',3,'CodeDetail_OperationType_Delete',0,4)

insert into SYS_Menu values('Url_UpdateEOSwitchLOG_View','EO新旧件日志','Menu.VehicleOrder.Setup',7100,'EO新旧件日志','~/UpdateEOSwitchLOG/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_UpdateEOSwitchLOG_View','EO新旧件日志-查询','VehicleOrder')
go
insert into SYS_Menu values('Url_UpdateItemConsumeLOG_View','厂内/外消化档日志','Menu.VehicleOrder.Setup',9100,'厂内/外消化档日志','~/UpdateItemConsumeLOG/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_UpdateItemConsumeLOG_View','厂内/外消化档日志-查询','VehicleOrder')
go
insert into SYS_Menu values('Url_UpdateVanDifferenceLOG_View','订单车差异档日志','Menu.VehicleOrder.Setup',5100,'订单车差异档日志','~/UpdateVanDifferenceLOG/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_UpdateVanDifferenceLOG_View','订单车差异档日志-查询','VehicleOrder')
go
insert into SYS_Menu values('Url_UpdatePOChangeLOG_View','PO变更日志','Menu.VehicleOrder.Setup',8100,'PO变更日志','~/UpdatePOChangeLOG/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_UpdatePOChangeLOG_View','PO变更日志-查询','VehicleOrder')
go
insert into SYS_Menu values('Url_SequenceOrderMaster_Edit','厂外序列单修改','Menu.Sequence.Info',1100,'厂外序列单修改','~/SequenceOrderMaster/EditIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SequenceOrderMaster_Edit','厂外序列单修改','Sequence')
go
insert into ACC_Permission values('Url_SEQTransferFlow_DetailEdit','厂内序列路线明细-编辑','TransferSequence')
go
insert into ACC_Permission values('Url_JITTransferFlow_DetailEdit','厂内电子看板明细-编辑','JIT')
go
insert into ACC_Permission values('Url_KanbanFlow_DetailEdit','看板采购路线明细-编辑','Kanban')
go
insert into ACC_Permission values('Url_KanbanTransferFlow_DetailEdit','看板移库路线明细-编辑','Kanban')
