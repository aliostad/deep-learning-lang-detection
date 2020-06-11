insert into SYS_Menu values('Url_MMOQuickReceipt_View','MMO收货','Menu.CKD.Trans.CKDProcurement',9100,'MMO收货','~/MMOQuickReceipt/Index','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_MMOQuickReceipt_View','MMO收货','CKD')
go
insert into SYS_Menu values('Url_SequenceGroup_IsActiveView','序列代码组启用/停用','Menu.Sequence.Setup',1100,'序列代码组启用/停用','~/SequenceGroup/IsActiveIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_SequenceGroup_IsActiveView','厂外序列代码组启用停用','Sequence')
go
insert into SYS_Menu values('Url_InSequenceGroup_IsActiveView','厂内序列组启用/停用','Menu.TransferSequence.Setup',1100,'厂内序列组启用/停用','~/InSequenceGroup/IsActiveIndex','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_InSequenceGroup_IsActiveView','厂内序列组启用停用','TransferSequence')

go
update SYS_Menu set Name='基础数据',Desc1='基础数据' where Code='Menu.MasterData'
go
update SYS_Menu set Name='自制生产',Desc1='自制生产' where Code='Menu.Production'
go
update SYS_Menu set Name='放行管理',Desc1='放行管理' where Code='Menu.CargoReleaseMaster'
go
update SYS_Menu set Name='成台份件',Desc1='成台份件' where Code='Menu.KIT'



