alter table ORD_OrderBomDet add IsCreateSeq bit
go

CREATE TYPE CreatePickListType AS TABLE
(
	[OrderDetId] int NULL,
	[PickQty] decimal(18, 8)
)
GO

alter table ORD_PickListDet add CSSupplier varchar(50)
go
alter table ORD_PickListDet add UCDesc varchar(50)
go
alter table ORD_PickListDet add Container varchar(50)
go
alter table ORD_PickListDet add ContainerDesc varchar(50)
go
insert into SYS_Menu values('Url_MiscOrder_261And262Import','261262Åúµ¼','Menu.Inventory.Trans',350,'261262Åúµ¼','~/OutMiscOrder/Import','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MiscOrder_261And262Import','261262Åúµ¼','Inventory')

