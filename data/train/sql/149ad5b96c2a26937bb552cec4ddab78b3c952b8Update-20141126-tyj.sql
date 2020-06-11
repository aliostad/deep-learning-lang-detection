insert into SYS_Menu values('Url_Supplier_IpMater_ShipConfirm','发货确认','Url_Supplier_Deliveryorder',500,'发货确认','~/SupplierIpMaster/ShipConfirmIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_Supplier_IpMater_ShipConfirm','送货单-发货确认','SupplierMenu')
go
insert into SYS_Menu values('Url_Supplier_IpMater_CancelShipConfirm','发货冲销','Url_Supplier_Deliveryorder',510,'发货冲销','~/SupplierIpMaster/CancelShipConfirmIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_Supplier_IpMater_CancelShipConfirm','送货单-发货冲销','SupplierMenu')
go
update sys_menu set isactive=0 where exists(select 1 from acc_permission a where a.code=sys_menu.code and a.category='SQSupplierMenu')
go
insert into SYS_Menu values('Url_SAP_CreateDN_View','创建DN交货单报表','Url_SI_SAP',530,'创建DN交货单报表','~/CreateDN/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAP_CreateDN_View','创建DN交货单报表','SI_SAP')
go
update SYS_SNRule set prefixed='E1' where prefixed='A1'
go
update SYS_SNRule set prefixed='E2' where prefixed='A2'
go
update SYS_SNRule set prefixed='E3' where prefixed='A3'
go
update SYS_SNRule set prefixed='E4' where prefixed='A4'
go
update SYS_SNRule set prefixed='E5' where prefixed='A5'
go
update SYS_SNRule set prefixed='E6' where prefixed='A6'
go
update SYS_SNRule set prefixed='E7' where prefixed='A7'
go
update SYS_SNRule set prefixed='E8' where prefixed='A8'
go
Update r set r.IsCreateInvTrans=0 from MD_Region r where exists(select 1 from MD_Location as l where l.Region=r.Code and l.SAPLocation in('R000','R001','R600','R601','R800','R801'))