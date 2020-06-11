insert into SYS_Menu values('Url_JITTransferFlow_View','厂内电子看板','Menu.Procurement.Setup',160,'厂内电子看板','~/JITTransferFlow/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_JITTransferFlow_View','厂内电子看板-查询','Procurement')
go
insert into ACC_Permission values('Url_JITTransferFlow_New','厂内电子看板-新建','Procurement')
go
insert into ACC_Permission values('Url_JITTransferFlow_Edit','厂内电子看板-编辑','Procurement')
go
update SYS_Menu set Code='Url_JITProcurementFlow_View',PageUrl='~/JITProcurementFlow/Index' where Code='Url_KBProcurementFlow_View'
update ACC_Permission set Code='Url_JITProcurementFlow_View'  where Code='Url_KBProcurementFlow_View'
update ACC_Permission set Code='Url_JITProcurementFlow_New'  where Code='Url_KBProcurementFlow_New'
update ACC_Permission set Code='Url_JITProcurementFlow_Edit'  where Code='Url_KBProcurementFlow_Edit'


insert into SYS_Menu values('Url_PreviewJIT_View','电子看板计算预览','Menu.Procurement.Info',10,'电子看板计算预览','~/PreviewJIT/Index','~/Content/Images/Nav/Default.png',1)
insert into ACC_Permission values('Url_PreviewJIT_View','电子看板计算预览','Procurement')

alter table md_region add IsAutoExportKanBanCard bit null default(0)
go
alter table md_region add IsCreateCargoRelease bit null default(0)
go
update MD_Region set IsAutoExportKanBanCard=0,IsCreateCargoRelease=0