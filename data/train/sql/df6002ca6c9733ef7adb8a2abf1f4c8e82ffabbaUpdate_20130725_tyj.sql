insert into SYS_Menu values('Url_MessageSubscirber_View','邮件维护','Menu.MasterData',500,'邮件维护','~/MessageSubscirber/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MessageSubscirber_View','邮件维护','MasterData')
go
update SYS_Menu set Parent=null,PageUrl=null where Code='Menu.Kanban'
go
alter table  CUST_ItemTrace add ItemDesc varchar(100) null
go
update c set c.ItemDesc=i.Desc1 from  CUST_ItemTrace c,MD_Item i where c.Item=i.Code 
go
go
update SYS_Menu set Seq=150 where Code='Url_OrderMstr_Production_Receive'
go
insert into SYS_Menu values('Url_Production_ForceReceive','整车生产单强制下线','Url_OrderMstr_Production',160,'整车生产单强制下线','~/ProductionOrder/ForceReceiveIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_Production_ForceReceive','整车生产单强制下线','Production')