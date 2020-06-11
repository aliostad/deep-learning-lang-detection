return
insert into ACC_PermissionCategory values('Menu_SI','SI',0,200)
go
insert into ACC_Permission values('Url_SI_SAPInterface','SI-手工调用SAP接口','Menu_SI',100)
go
insert into SYS_Menu values('Url_SI_SAPInterface','手工调用SAP接口','Url_SI_View',1010000100,'SI-手工调用SAP接口','~/SAPInterface/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPTransferLog_View','SI-SAP接口日志报表','Menu_SI',200)
go
insert into SYS_Menu values('Url_SAPTransferLog_View','SAP接口日志报表','Url_SI_View',1010000200,'SI-SAP接口日志报表','~/SAPInterface/SAPTransferLogIndex','~/Content/Images/Nav/Default.png',1)
go
--
insert into SYS_Menu values('Url_SAPReport','SAP接口报表','Url_SI_View',1010000300,'SI-SAP接口报表',null,'~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_SAPItem_View','物料','Url_SAPReport',1010000400,'SI-SAP接口报表-物料','~/SAPInterface/SAPItemIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPItem_View','SAP接口报表-物料','Menu_SI',400)
go
insert into SYS_Menu values('Url_SAPBom_View','Bom','Url_SAPReport',1010000500,'SI-SAP接口报表-Bom','~/SAPInterface/SAPBomIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPBom_View','SAP接口报表-Bom','Menu_SI',500)
go
insert into SYS_Menu values('Url_SAPUomConvertion_View','单位转换','Url_SAPReport',1010000600,'SI-SAP接口报表-单位转换','~/SAPInterface/SAPUomConvertionIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPUomConvertion_View','SAP接口报表-单位转换','Menu_SI',600)
go
insert into SYS_Menu values('Url_SAPPriceList_View','采购价格单','Url_SAPReport',1010000700,'SI-SAP接口报表-采购价格单','~/SAPInterface/SAPPriceListIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPPriceList_View','SAP接口报表-采购价格单','Menu_SI',700)
go
insert into SYS_Menu values('Url_SAPSupplier_View','供应商','Url_SAPReport',1010000800,'SI-SAP接口报表-供应商','~/SAPInterface/SAPSupplierIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPSupplier_View','SAP接口报表-供应商','Menu_SI',800)
go
insert into SYS_Menu values('Url_SAPCustomer_View','客户','Url_SAPReport',1010000900,'SI-SAP接口报表-客户','~/SAPInterface/SAPCustomerIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPCustomer_View','SAP接口报表-客户','Menu_SI',900)
go
insert into SYS_Menu values('Url_SAPSDNormal_View','销售','Url_SAPReport',1010001000,'SI-SAP接口报表-销售','~/SAPInterface/SAPSDNormalIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPSDNormal_View','SAP接口报表-销售','Menu_SI',1000)
go
insert into SYS_Menu values('Url_SAPSDCancel_View','销售冲销','Url_SAPReport',1010001100,'SI-SAP接口报表-销售冲销','~/SAPInterface/SAPSDCancelIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPSDCancel_View','SAP接口报表-销售冲销','Menu_SI',1100)

--Delete SYS_Menu where code in ('Url_SAPSDNormal_View','Url_SAPSDCancel_View')
--Delete ACC_Permission where code in ('Url_SAPSDNormal_View','Url_SAPSDCancel_View')
----SAP-PPMES Menu

Select * from sys_menu where Desc1 like '%SAP接口报表%'
Order by Seq 
 
--insert into SYS_Menu values('Url_SAPPPMES0001_View','生产收货','Url_SAPReport',1010001200,'SI-SAP接口报表-生产收货','~/SAPInterface/SAPPPMES0001Index','~/Content/Images/Nav/Default.png',1)
--go
--insert into ACC_Permission values('Url_SAPPPMES0001_View','SAP接口报表-生产收货','Menu_SI',1010001200)

-- insert into SYS_Menu values('Url_SAPPPMES0002_View','生产收货冲销','Url_SAPReport',1010001300,'SI-SAP接口报表-生产收货冲销','~/SAPInterface/SAPPPMES0002Index','~/Content/Images/Nav/Default.png',1)
--go
--insert into ACC_Permission values('Url_SAPPPMES0002_View','SAP接口报表-生产收货冲销','Menu_SI',1010001300)

--insert into SYS_Menu values('Url_SAPPPMES0003_View','生产废品报工','Url_SAPReport',1010001400,'SI-SAP接口报表-生产废品报工','~/SAPInterface/SAPPPMES0003Index','~/Content/Images/Nav/Default.png',1)
--go
--insert into ACC_Permission values('Url_SAPPPMES0003_View','SAP接口报表-生产废品报工','Menu_SI',1010001400)


--insert into SYS_Menu values('Url_SAPPPMES0004_View','生产过滤','Url_SAPReport',1010001500,'SI-SAP接口报表-生产过滤','~/SAPInterface/SAPPPMES0004Index','~/Content/Images/Nav/Default.png',1)
--go
--insert into ACC_Permission values('Url_SAPPPMES0004_View','SAP接口报表-生产过滤','Menu_SI',1010001500)

--insert into SYS_Menu values('Url_SAPPPMES0005_View','生产调整','Url_SAPReport',1010001600,'SI-SAP接口报表-生产调整','~/SAPInterface/SAPPPMES0005Index','~/Content/Images/Nav/Default.png',1)
--go
--insert into ACC_Permission values('Url_SAPPPMES0005_View','SAP接口报表-生产调整','Menu_SI',1010001600)

--insert into SYS_Menu values('Url_SAPPPMES0006_View','生产试制','Url_SAPReport',1010001700,'SI-SAP接口报表-生产试制','~/SAPInterface/SAPPPMES0006Index','~/Content/Images/Nav/Default.png',1)
--go
--insert into ACC_Permission values('Url_SAPPPMES0006_View','SAP接口报表-生产试制','Menu_SI',1010001700)

 
 insert into SYS_Menu values('Url_SAPMMMES0001_View','MM采购业务','Url_SAPReport',1010001800,'SI-SAP接口报表-MM采购业务','~/SAPInterface/SAPMMMES0001Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPMMMES0001_View','SAP接口报表-MM采购业务','Menu_SI',1010001800)
  insert into SYS_Menu values('Url_SAPMMMES0002_View','MM采购业务冲销','Url_SAPReport',1010001900,'SI-SAP接口报表-MM采购业务冲销','~/SAPInterface/SAPMMMES0002Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPMMMES0002_View','SAP接口报表-MM采购业务冲销','Menu_SI',1010001900)

   insert into SYS_Menu values('Url_SAPSTMES0001_View','MM库存移动','Url_SAPReport',1010002000,'SI-SAP接口报表-MM库存移动','~/SAPInterface/SAPSTMES0001Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SAPSTMES0001_View','SAP接口报表-MM库存移动','Menu_SI',1010002000)



 
--insert into ACC_Permission values('Url_SI_SAPBuInterface','SI-SAP业务接口调用(测试用)','Menu_SI',150)
--go
--insert into SYS_Menu values('Url_SI_SAPFunInterface','SAP业务接口调用(测试用)','Url_SI_View',1010000150,'SI-SAP业务接口调用(测试用)','~/SAPInterface/Index1','~/Content/Images/Nav/Default.png',1)
--go
 
 