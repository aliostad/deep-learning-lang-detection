insert into SYS_Menu values('Url_VerifyCKD_View','CKD日志','Menu.CKD.Info',100,'CKD日志','~/VerifyCKD/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_VerifyCKD_View','CKD日志','CKD')
go


insert into SYS_Codemstr(Code,Desc1,Type) values('VerifyCKDErrorId','CKD错误日志',0)
insert into SYS_CodeDet(Code, Value, Desc1, IsDefault, Seq) values('VerifyCKDErrorId', '101', 'CodeDetail_VerifyCKDErrorId_101', 0, 1)
insert into SYS_CodeDet(Code, Value, Desc1, IsDefault, Seq) values('VerifyCKDErrorId', '102', 'CodeDetail_VerifyCKDErrorId_102', 0, 2)

go

/****** Object:  Table [dbo].[ERR_VerifyCKD]    Script Date: 03/18/2013 11:17:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ERR_VerifyCKD](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [int] NULL,
	[ErrorId] [int] NULL,
	[ErrorMsg] [varchar](500) NULL,
	[CreateUserNm] [nvarchar](50) NULL,
 CONSTRAINT [PK_ERR_VerifyCKD] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
 go
  insert into SYS_Menu values('Url_ContainerReceipt_View','通关确认','Url_DistributionIpMaster',300,'通关确认','~/ContainerReceip/Index','~/Content/Images/Nav/Default.png',1)
   go
   insert into ACC_Permission values('Url_ContainerReceipt_View','通关确认','Distribution')
   go
  go
 alter table CKD_ProdCodeSimpleCode add StartDate datetime not null
 go
 alter table CKD_ProdCodeSimpleCode add EndDate datetime  null
 go
  update SYS_Menu set Parent='Menu.CKD.Trans.MMO.Trans' ,Seq=104500 where Code='Url_ContainerReceipt_View'
 go
 update SYS_Menu set IsActive=0 where Parent='Url_DistributionIpMaster'
go
insert into SYS_Menu values('Url_MiscOrder_MiscTransferFixOrder','整修件移转单','Menu.Order.Trans',12100,'整修件移转单',null,'~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_MiscTransferFixOrder_View','查询','Url_MiscOrder_MiscTransferFixOrder',1000,'整修件移转单-查询','~/MiscTransferFixOrder/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MiscTransferFixOrder_View','整修件移转单-查询','MiscOrder')
go
insert into SYS_Menu values('Url_MiscTransferFixOrder_New','新建','Url_MiscOrder_MiscTransferFixOrder',2000,'整修件移转单-新建','~/MiscTransferFixOrder/New','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MiscTransferFixOrder_New','整修件移转单-新建','MiscOrder')
go
delete SYS_Menu where Code ='Url_MiscTransferOrder_FixNew'
go
delete ACC_Permission where Code='Url_MiscTransferOrder_FixNew'
go
   
   
CREATE TABLE [dbo].[ERR_TransferItemDailyConsume](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Opref] [varchar](50) NULL,
	[Item] [varchar](50) NULL,
	[Location] [varchar](50) NULL,
	[ErrMsg] [varchar](100) NULL,
	[UniqueCode] [varchar](50) NULL
) ON [PRIMARY]
