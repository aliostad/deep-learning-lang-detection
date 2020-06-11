insert into SYS_Menu values('Url_PickGroup_View','拣货组','Url_WMS_Setup',300,'高级仓库-设置-拣货组','~/PickGroup/Index','~/Content/Images/Nav/Default.png',1)
insert into SYS_Menu values('Url_RepackGroup_View','翻包组','Url_WMS_Setup',400,'高级仓库-设置-翻包组','~/RepackGroup/Index','~/Content/Images/Nav/Default.png',1)
insert into SYS_Menu values('Url_ShipGroup_View','发货组','Url_WMS_Setup',500,'高级仓库-设置-发货组','~/ShipGroup/Index','~/Content/Images/Nav/Default.png',1)



insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_PickGroup_View','拣货组查看','WMS',20000)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_RepackGroup_View','翻包组查看','WMS',21000)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_ShipGroup_View','发货组查看','WMS',22000)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_PickGroup_Edit','拣货组编辑','WMS',20000)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_RepackGroup_Edit','翻包组编辑','WMS',21000)
insert into ACC_Permission (Code,Desc1,category,Sequence) values('Url_ShipGroup_Edit','发货组编辑','WMS',22000)