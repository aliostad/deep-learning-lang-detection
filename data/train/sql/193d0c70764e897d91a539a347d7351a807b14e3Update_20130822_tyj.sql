insert into SYS_Menu values('Url_OpReferenceBalance','工位余量','Menu.Quality.Trans',800,'工位余量',null,'~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_OpReferenceBalance_View','查询','Url_OpReferenceBalance',10,'查询','~/OpReferenceBalance/Index','~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_OpReferenceBalance_Adjust','调整','Url_OpReferenceBalance',20,'调整','~/OpReferenceBalance/Adjust','~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_OpReferenceBalance_Stock','盘点','Url_OpReferenceBalance',30,'盘点','~/OpReferenceBalance/Stock','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_OpReferenceBalance_View','工位余量-查询','Quality')
go
insert into ACC_Permission values('Url_OpReferenceBalance_Adjust','工位余量-调整','Quality')
go
insert into ACC_Permission values('Url_OpReferenceBalance_Stock','工位余量-盘点','Quality')
go
insert into SYS_Menu values('Url_SnapshotFlowDet4LeanEngine_View','路线缺失报表','Menu.Procurement.Info',600,'路线缺失报表','~/SnapshotFlowDet4LeanEngine/Index','~/Content/Images/Nav/Default.png',1)
go	
insert into ACC_Permission values('Url_SnapshotFlowDet4LeanEngine_View','路线缺失报表','Procurement')