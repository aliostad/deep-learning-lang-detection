if exists (select 1 from  sysobjects where  id = object_id('PRD_HemSeq') and   type = 'U')
	drop table PRD_HemSeq
go
create table PRD_HemSeq
(
   Id                   bigint               identity,
   No					varchar(100)		 null,
   OrderNo              varchar(50)          null,
   Flow					varchar(50)			 null,
   GroupNo				varchar(50)          null,
   VanSeries            varchar(50)        	 null,
   ProdCode				varchar(50)			 null,
   ProdSeq				varchar(50)			 null,
   Seq					bigint				 null,
   Item			        varchar(50)        	 null,
   ItemDesc			    varchar(100)         null,
   OrderQty				decimal(18,8)		 not null,
   HemOrderNo			varchar(50)			 null,
   CreateDate			datetime			 null,
   LastModifyDate		datetime			 null
)
go


insert into sys_menu values
('Url_OpReferenceBalance_View','工位溢出量','Menu.Procurement.Info',5,'工位溢出量','~/OpReferenceBalance/Index','~/Content/Images/Nav/Default.png',1)

insert into acc_permission values
('Url_OpReferenceBalance_View','工位溢出量','Procurement')
go


insert into sys_menu 
values('Url_HemSeq_View','HEM序列','Url_OrderMstr_Production',454,'HEM序列','~/HemSeq/Index','~/Content/Images/Nav/Default.png',1)

insert into acc_permission values('Url_HemSeq_View','HEM序列','Production')
go