
create table MD_Picker
(
	Id int identity(1,1) primary key,
	Code varchar(50) not null,
	Decs1 varchar(100) not null,
	Location varchar(50) not null,
	UserCode varchar(50) not null,
	UserNm varchar(100) not null,
	IsActive bit not null,
	CreateUser int not null,
	CreateUserNm varchar(100) not null,
	CreateDate datetime not null,
	LastModifyUser int not null,
	LastModifyUserNm varchar(100) not null,
	LastModifyDate datetime not null
)
go

create table MD_PickRule
(
	Id int identity(1,1) primary key,
	Item varchar(50) not null,
	ItemDesc varchar(100) null,
	Location varchar(50) not null,
	Picker varchar(50) not null,
	CreateUser int not null,
	CreateUserNm varchar(100) not null,
	CreateDate datetime not null,
	LastModifyUser int not null,
	LastModifyUserNm varchar(100) not null,
	LastModifyDate datetime not null
)
go

create table MD_Shipper
(
	Code varchar(50) not null primary key,
	Desc1 varchar(100) not null,
	Location varchar(50) null,
	Address varchar(50) null,
	Contact varchar(50) null,
	Tel varchar(50) null,
	Email varchar(50) null,
	IsActive bit not null,
	CreateUser int not null,
	CreateUserNm varchar(100) not null,
	CreateDate datetime not null,
	LastModifyUser int not null,
	LastModifyUserNm varchar(100) not null,
	LastModifyDate datetime not null
)
go

insert into sys_menu values
('Url_Picker_View','备料工','Menu.MasterData',200,'备料工','~/Picker/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_Picker_View','备料工','MasterData')
go

insert into sys_menu values
('Url_PickRule_View','备料规则','Menu.MasterData',201,'备料规则','~/PickRule/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_PickRule_View','备料规则','MasterData')
go

insert into sys_menu values
('Url_Shipper_View','承运商','Menu.MasterData',202,'承运商','~/Shipper/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_Shipper_View','承运商','MasterData')
go
