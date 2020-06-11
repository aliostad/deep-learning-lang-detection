alter table INV_CycloidAmount alter column ItemDesc varchar(100) null
alter table PRD_ProdLineLayOut add VanSeries varchar(50) null
go
insert into sys_menu values
('Menu.CKD.Trans.CKDProcurement','CKD采购','Menu.CKD.Trans',490,'CKD采购',null,'~/Content/Images/Nav/Default.png',1)

update sys_menu set Parent='Menu.CKD.Trans.CKDProcurement' 
where code in('URL_CkdBase_View','Url_CkdCaseBill_View','Url_CkdContainerBill_View','Url_CkdLadingBill_View','Url_CkdMMOCaseBill_View')


insert into sys_menu values
('Url_CKDProcurement_View','CKD采购查询','Menu.CKD.Trans.CKDProcurement',50,'CKD采购查询','~/CKDProcurement/Index','~/Content/Images/Nav/Default.png',1)

if not exists(select * from sys_menu where code='Url_CKDProcurement_View')
	insert into acc_permission values('Url_CKDProcurement_View','CKD采购查询','CKD')
go

alter table PRD_MultiSupplySupplier add [Version] int
go
update PRD_MultiSupplySupplier set [Version] = 1
go
alter table PRD_MultiSupplySupplier alter column [Version] int not null
go


alter table SAP_Item add IsSubContract varchar(5)
go


update SYS_Menu set Parent='Menu.CKD.Setup' where Code='URL_CkdBase_View'
go
insert into sys_menu values('Url_KanbanCard_Calc2','看板核算(生产)','Menu.Kanban.Trans',15,'看板核算(生产)','~/KanbanCard/Calc2','~/Content/Images/Nav/Default.png',1)
insert into acc_permission values('Url_KanbanCard_Calc2','看板核算(生产)','Kanban')
go