CREATE TABLE ORD_ShellCycloid
(
	Id int identity(1,1) primary key,
	OrderNo varchar(50) ,
	Qty int,
	CreateUser int not null,
	CreateUserNm varchar(100) not null,
	CreateDate datetime not null,
	LastModifyUser int not null,
	LastModifyUserNm varchar(100) not null,
	LastModifyDate datetime not null
)
go


 insert into sys_menu values
('Url_ShellCycloid_View','空车摆线','Menu.COGI',21000,'空车摆线','~/ShellCycloid/Index','~/Content/Images/Nav/Default.png',1)
insert into acc_permission values('Url_ShellCycloid_View','空车摆线','COGI')

go

insert into SYS_EntityPreference values
(11030,60,'172.16.1.53\\Excel|172.16.1.54\\Excel','上传模板需同步至其他的服务器路径',1,'用户 超级',getdate(),1,'用户 超级',getdate())

go
insert into SYS_Menu values('Url_DeleteOrder_View','一车一单删除','Menu.VehicleOrder.Info',2550,'一车一单删除','~/ProductionOrder/DeleteOrderIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_DeleteOrder_View','一车一单删除','VehicleOrder')