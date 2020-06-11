go
insert into SYS_Menu values('Url_JITOrderTrace_View','电子看板日志查询','Menu.JIT.Info',1100,'电子看板日志查询','~/JITOrderTrace/Index','~/Content/Images/Nav/Default.png',1)
go
 insert into ACC_Permission values('Url_JITOrderTrace_View','电子看板日志查询','Procurement')
 go
 insert into SYS_Menu values('Url_Inventory_InvInit','库存初始化','Menu.Order.Trans',12900,'库存初始化',null,'~/Content/Images/Nav/Default.png',1)
 go
insert into SYS_Menu values('Url_MiscInvInit_View','查询','Url_Inventory_InvInit',100,'库存初始化-查询','~/MiscInvInit/Index','~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_MiscInvInit_New','新建','Url_Inventory_InvInit',200,'库存初始化-新建','~/MiscInvInit/New','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MiscInvInit_View','库存初始化-查询','MiscOrder')
go
insert into ACC_Permission values('Url_MiscInvInit_New','库存初始化-新建','MiscOrder')
go
update CUST_MiscOrderMoveType set MiscType=5 where MoveType='561'
go
alter table CKD_MMO add ShipDate datetime null
go