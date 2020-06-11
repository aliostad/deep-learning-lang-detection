delete from sys_menu where code ='Url_CabProductionView_View'
delete from acc_permission where code ='Url_CabProductionView_View'
go
delete from sys_menu where code ='Url_CabGuideOutSoureView_View'
delete from acc_permission where code ='Url_CabGuideOutSoureView_View'
go

insert into sys_menu values
('Url_CabGuideHomeMadeView_View','驾驶室导轨自制视图','Menu.Production.Info',202,'驾驶室导轨自制视图','~/CabGuide/HomeMadeViewIndex','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_CabGuideHomeMadeView_View','驾驶室导轨自制视图','Production')
go

insert into sys_menu values
('Url_CabGuideOutSoureView_View','驾驶室导轨外购视图','Menu.Production.Info',203,'驾驶室导轨外购视图','~/CabGuide/OutSoureViewIndex','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_CabGuideOutSoureView_View','驾驶室导轨外购视图','Production')
go

insert into sys_menu values
('Url_VehicleProductionSubLineView_View','整车生产分线视图','Menu.Production.Info',204,'整车生产分线视图','~/VehicleProductionSubLine/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_VehicleProductionSubLineView_View','整车生产分线视图','Production')
go
