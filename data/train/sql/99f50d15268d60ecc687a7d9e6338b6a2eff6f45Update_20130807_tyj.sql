
alter table md_item add ContainerDesc varchar(50) null
go
insert into ACC_Permission values('Url_Production_ForceResume','强制恢复','Production')
go

insert into SYS_Menu values('Url_OrderTrace_View','物料拉动日志','Menu.Procurement.Info',420,'物料拉动日志','~/OrderTrace/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_OrderTrace_View','物料拉动日志','Procurement')
go
insert into SYS_Menu values('Url_SequenceOrder_Receive','收货','Url_SequenceOrder',300,'收货','~/SequenceMaster/ReceiveIndex/10','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SequenceOrder_Receive','收货','Procurement')
go
insert into SYS_Menu values('Url_SequenceOrder_Receive','收货','Url_SequenceOrder',300,'收货','~/SequenceMaster/ReceiveIndex/10','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SequenceOrder_Receive','排序单收货','Procurement')
go
insert into SYS_Menu values('Url_SequenceOrder_Receive_Distribution','收货','Url_SequenceOrder_Distribution',200,'收货','~/SequenceMaster/ReceiveIndex/20','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SequenceOrder_Receive_Distribution','排序单收货','Distribution')
go

alter table FIS_WMSDatFile add ReceiveTotal decimal(18,8) default(0) null 
go

alter table FIS_WMSDatFile add CancelQty decimal(18,8) default(0)  null 
go
alter table FIS_WMSDatFile add Version int default(1) not null
go
update  FIS_WMSDatFile set ReceiveTotal=Qty,CancelQty=0,Version=1 
