insert into SYS_Menu values('Menu.MiscOrder','单据管理',null,100,'单据管理',null,'~/Content/Images/Nav/Procurement.png',1)

insert into SYS_Menu values('Url_MiscOrder_MiscFactoryMaterial','厂外加工领（退）料单','Menu.MiscOrder',100,'厂外加工领（退）料单',null,'~/Content/Images/Nav/Default.png',1)

insert into SYS_Menu values('Url_MiscFactoryMaterial_View','查询','Url_MiscOrder_MiscFactoryMaterial',100,'查询','~/MiscFactoryMaterial/Index','~/Content/Images/Nav/Default.png',1)


insert into SYS_Menu values('Url_MiscFactoryMaterial_New','新建','Url_MiscOrder_MiscFactoryMaterial',200,'新建','~/MiscFactoryMaterial/New','~/Content/Images/Nav/Default.png',1)

insert into ACC_PermissionCategory values('MiscOrder','单据管理',1)

insert into ACC_Permission values('Url_MiscFactoryMaterial_View','厂外加工领（退）料单-查询','MiscOrder')

insert into ACC_Permission values('Url_MiscFactoryMaterial_New','厂外加工领（退）料单-新建','MiscOrder')

alter table CUST_MiscOrderMoveType add MiscType varchar(50) null
go

update CUST_MiscOrderMoveType set MiscType='MiscFactoryMaterial' where id=41

select * from CUST_MiscOrderMoveType

insert into SYS_Menu values('Url_MiscOrder_MiscTransferOrder','移转申请单','Menu.MiscOrder',200,'移转申请单',null,'~/Content/Images/Nav/Default.png',1)

insert into SYS_Menu values('Url_MiscTransferOrder_View','查询','Url_MiscOrder_MiscTransferOrder',100,'查询','~/MiscTransferOrder/Index','~/Content/Images/Nav/Default.png',1)

insert into SYS_Menu values('Url_MiscTransferOrder_New','新建','Url_MiscOrder_MiscTransferOrder',200,'新建','~/MiscTransferOrder/New','~/Content/Images/Nav/Default.png',1)

insert into ACC_Permission values('Url_MiscTransferOrder_View','移转申请单-查询','MiscOrder')

insert into ACC_Permission values('Url_MiscTransferOrder_New','移转申请单-新建','MiscOrder')
--------------------------------------------------------------
--------------------------------------
------------------------------------------------------------------
insert into ACC_Permission values('Url_MiscTransferOrder_Close','移转申请单-关闭','MiscOrder')
insert into ACC_Permission values('Url_MiscTransferOrder_Cancel','移转申请单-取消','MiscOrder')

alter table ord_ordermstr_7 drop constraint  FK_ORD_OrderMstr7_ProdLineFact_REFERENCE_SCM_ProdLineFact_Code
alter table ord_ordermstr_2 drop constraint  FK_ORD_OrderMstr2_ProdLineFact_REFERENCE_SCM_ProdLineFact_Code
alter table dbo.ORD_MiscOrderMstr alter column region varchar(50) null
alter table dbo.ORD_MiscOrderMstr alter column location varchar(50) null

alter table ORD_MiscOrderMstr add UnitsCode varchar(50) null
alter table ORD_MiscOrderMstr add UnitsName varchar(50) null
alter table ORD_MiscOrderMstr add CaseNo varchar(50) null
alter table ORD_MiscOrderMstr add BudgetNo varchar(50) null
alter table ORD_MiscOrderMstr add FactoryCode varchar(50) null
 alter table ORD_MiscOrderMstr add Remarks1 varchar(50) null
 alter table ORD_MiscOrderMstr add Remarks2 varchar(50) null
 alter table ORD_MiscOrderMstr add Remarks3 varchar(50) null
 alter table ORD_MiscOrderMstr add Remarks4 varchar(50) null
 alter table ORD_MiscOrderMstr add MiscType varchar(50) null
 alter table ORD_MiscOrderDet add CostCenter varchar(50) null
 
insert into SYS_Menu values('Url_MiscOrder_MiscMaterialOrder','领/退料申请单','Menu.MiscOrder',300,'领/退料申请单',null,'~/Content/Images/Nav/Default.png',1)

insert into SYS_Menu values('Url_MiscMaterialOrder_View','查询','Url_MiscOrder_MiscMaterialOrder',100,'查询','~/MiscMaterialOrder/Index','~/Content/Images/Nav/Default.png',1)

insert into SYS_Menu values('Url_MiscMaterialOrder_New','新建','Url_MiscOrder_MiscMaterialOrder',200,'新建','~/MiscMaterialOrder/New','~/Content/Images/Nav/Default.png',1)

insert into ACC_Permission values('Url_MiscMaterialOrder_View','领/退料申请单-查询','MiscOrder')

insert into ACC_Permission values('Url_MiscMaterialOrder_New','领/退料申请单-新建','MiscOrder')

insert into ACC_Permission values('Url_MiscMaterialOrder_Edit','领/退料申请单-编辑','MiscOrder')
-------------------------------------
insert into SYS_Menu values('Url_MiscOrder_MiscStockTake','汽车材料盘盈（亏）单','Menu.MiscOrder',400,'汽车材料盘盈（亏）单',null,'~/Content/Images/Nav/Default.png',1)

insert into SYS_Menu values('Url_MiscStockTake_View','查询','Url_MiscOrder_MiscStockTake',100,'查询','~/MiscStockTake/Index','~/Content/Images/Nav/Default.png',1)

insert into SYS_Menu values('Url_MiscStockTake_New','新建','Url_MiscOrder_MiscStockTake',200,'新建','~/MiscStockTake/New','~/Content/Images/Nav/Default.png',1)

insert into ACC_Permission values('Url_MiscStockTake_View','汽车材料盘盈（亏）单-查询','MiscOrder')

insert into ACC_Permission values('Url_MiscStockTake_New','汽车材料盘盈（亏）单-新建','MiscOrder')

insert into ACC_Permission values('Url_MiscStockTake_Edit','汽车材料盘盈（亏）单-编辑','MiscOrder')




-----------------------------
insert into CUST_MiscOrderMoveType values(1,'Z02','Z01','SEm各单位领用-反向',1,0,0,1,0,0,0,0,'MiscMaterialOrder')
insert into CUST_MiscOrderMoveType values(1,'252','251','阻留车整修领料扣款-反向',1,0,0,1,0,0,0,0,'MiscMaterialOrder')
insert into CUST_MiscOrderMoveType values(1,'202','201','生产领用/退料(成本)-反向',1,0,0,1,0,0,0,0,'MiscMaterialOrder')
insert into CUST_MiscOrderMoveType values(1,'262','261','部门领用、项目领用及冲销-反向',1,0,0,1,0,0,0,0,'MiscMaterialOrder')

update CUST_MiscOrderMoveType set miscType='MiscMaterialOrder' where MoveType in('Z01','261','201','251')

insert into CUST_MiscOrderMoveType values(0,'301','302','生管移转售服-正向',1,0,0,1,0,0,0,0,'MiscTransferOrder')
insert into CUST_MiscOrderMoveType values(1,'302','301','生管移转售服-反向',1,0,0,1,0,0,0,0,'MiscTransferOrder')
insert into CUST_MiscOrderMoveType values(0,'311','312','库存地点间移转-正向',1,0,0,1,0,0,0,0,'MiscTransferOrder')
insert into CUST_MiscOrderMoveType values(1,'312','311','库存地点间移转-反向',1,0,0,1,0,0,0,0,'MiscTransferOrder')

insert into CUST_MiscOrderMoveType values(1,'542','541','厂外加工领料/退料-反向',1,0,0,1,0,0,0,0,'MiscFactoryMaterial')

insert into CUST_MiscOrderMoveType values(0,'Z04','Z03','汽车材料盘盈(亏)-正向',1,0,0,1,0,0,0,0,'MiscStockTake')

insert into CUST_MiscOrderMoveType values(1,'Z03','Z04','汽车材料盘盈(亏)-反向',1,0,0,1,0,0,0,0,'MiscStockTake')

