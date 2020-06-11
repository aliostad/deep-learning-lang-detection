alter table LE_OrderPlanSnapshot add RefLocation varchar(50)
go
update SYS_Menu set Desc1='向直送供应商要货',Name='向直送供应商要货' where Code='Url_OrderMstr_Procurement_New'
go
update ACC_Permission set Desc1='向直送供应商要货' where Code='Url_OrderMstr_Procurement_New'
go
insert into SYS_Menu values('Url_Procurement_MergeReceive','收货总菜单','Menu.Procurement.Trans',5,'收货总菜单','~/ProcurementOrder/MergeIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_Procurement_MergeReceive','收货总菜单','procurement')
go
insert into SYS_Menu values('Url_ProcurementOrder_CloseDetail','要货需求关闭','Url_OrderMstr_Procurement',400,'要货需求关闭','~/ProcurementOrder/CloseDetailIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_ProcurementOrder_CloseDetail','要货需求关闭','Procurement')