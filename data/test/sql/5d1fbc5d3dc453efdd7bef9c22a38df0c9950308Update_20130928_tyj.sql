insert into SYS_Menu values('Url_Production_DeleteVanOrder','整车生产单删除','Url_OrderMstr_Production',300,'整车生产单删除','~/ProductionOrder/DeleteVanOrderIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_Production_DeleteVanOrder','整车生产单删除','Production')
go
insert into SYS_Menu values('Url_Production_GetCurrentVanOrder','整车生产单导入','Url_OrderMstr_Production',400,'整车生产单导入','~/ProductionOrder/GetCurrentVanOrderIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_Production_GetCurrentVanOrder','整车生产单导入','Production')
go

update SYS_Menu set PageUrl='~/SupplierOrder/ShipIndex' where Code='Url_Supplier_Lading_Deliver'
go
update SYS_Menu set IsActive =1 where Code='Url_Sort_List'
go
insert into SYS_Menu values('Url_Sort_List_Prev','排序单预览','Url_Sort_List',500,'排序单预览','~/SupplierOrder/Preview','~/Content/Images/Nav/Default.png',1)
go
update ACC_Permission set Code='Url_Sort_List_Prev' where Code='Url_Supplier_SequenceOrder_Preview'
go
update SYS_Menu set IsActive=0 where Code='Url_Supplier_SequenceOrder'
go
insert into SYS_CodeMstr values('SupplierOrderStatus','供应商订单状态',0)
go
insert into SYS_CodeDet values('SupplierOrderStatus',1,'CodeDetail_SupplierOrderStatus_Submit',1,2)
go
insert into SYS_CodeDet values('SupplierOrderStatus',2,'CodeDetail_SupplierOrderStatus_InProcess',0,3)
go
insert into SYS_CodeDet values('SupplierOrderStatus',4,'CodeDetail_SupplierOrderStatus_Close',0,5)
go
insert into SYS_CodeDet values('SupplierOrderStatus',5,'CodeDetail_SupplierOrderStatus_Cancel',0,6)
go
update FIS_OutboundCtrl set OutFolder='C:\DAT\LESSQCORD',ArchiveFolder='C:\DAT\LESSQCORDFolder' where id=2
go
insert into FIS_FtpCtrl values('10.86.128.128',21,'infuser','infuser','INTERFACE/TNT/FILEOUT/LESSQCORD/OutTemp','INTERFACE/TNT/FILEOUT/LESSQCORD','*.DAT','C:\\DAT\\LESSQCORD\\OutTemp','C:\DAT\LESSQCORD','OUT',null,null,null)
go
insert into SYS_Menu values('Url_MiscInvInit','库存初始化','Menu.Inventory.Trans',100,'库存初始化',NULL,'~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_MiscInvInit_View','查询','Url_MiscInvInit',10,'查询库存初始化','~/MiscInvInit/Index','~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_MiscInvInit_New','新增','Url_MiscInvInit',20,'新增库存初始化','~/MiscInvInit/New','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MiscInvInit_View','库存初始化-查询','Inventory')
go
insert into ACC_Permission values('Url_MiscInvInit_New','库存初始化-新增','Inventory')
