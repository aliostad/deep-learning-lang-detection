insert into SYS_Menu values('Url_OrderOperationReport_View','整车生产报工统计','Menu.Production.Info',120,'整车生产报工统计','~/OrderOperationReport/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_OrderOperationReport_View','整车生产报工统计','Production')
go
  update SCM_OpRefBalance set Version=1 where Version is null
  go
  alter table SCM_OpRefBalance alter column Version int not null 
  go
  alter table SCM_OpRefBalance add constraint Version_Default DEFAULT 1 for Version