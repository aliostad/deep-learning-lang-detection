insert into SYS_Menu values('Menu.CKD.Trans.InvInit','箱柜库存初始化','Menu.CKD.Trans',91000,'箱柜库存初始化',null,'~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_CaseInvInit_New','新建','Menu.CKD.Trans.InvInit',200,'箱柜库存初始化-新建','~/CaseInvInit/New','~/Content/Images/Nav/Default.png',1)
go
insert into SYS_Menu values('Url_CaseInvInit_View','查询','Menu.CKD.Trans.InvInit',100,'箱柜库存初始化-查询','~/CaseInvInit/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_CaseInvInit_View','箱柜库存初始化-查询','CKD')
go
insert into ACC_Permission values('Url_CaseInvInit_New','箱柜库存初始化-新建','CKD')
go
insert into ACC_Permission values('Url_CaseInvInit_Edit','箱柜库存初始化-编辑','CKD')
go
update SYS_Menu set Parent='Menu.CKD.Trans.MMO.Trans' where Parent='Menu.CKD.Trans.MMO'
go
update SYS_Menu set Parent='Menu.CKD.Trans.MMO.Setup' where Code='Url_CkdStandBoxType_View'
go
insert into SYS_Menu values('Menu.CKD.Trans.MMO.Trans','事务','Menu.CKD.Trans.MMO',1000,'事务',null,'~/Content/Images/Nav/Trans.png',1)
go
insert into SYS_Menu values('Menu.CKD.Trans.MMO.Info','信息','Menu.CKD.Trans.MMO',2000,'信息',null,'~/Content/Images/Nav/Info.png',1)
go
insert into SYS_Menu values('Menu.CKD.Trans.MMO.Setup','设置','Menu.CKD.Trans.MMO',3000,'设置',null,'~/Content/Images/Nav/Setup.png',1)
go
insert into SYS_Menu values('CKD_CkdOrderMaster_View','已装箱未装柜清册','Menu.CKD.Trans.MMO.Info',100,'已装箱未装柜清册','~/CkdOrderMaster/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('CKD_CkdOrderMaster_View','已装箱未装柜清册','CKD')
go