insert into SYS_Menu values('Url_CheckFlowList_View','物流路线检查','Menu.Inventory.Setup',400,'物流路线检查','~/ItemFlow/CheckFlowList','~/Content/Images/Nav/Default.png',1)
go
insert into ACC_Permission values('Url_CheckFlowList_View','物流路线检查','Inventory')
go
insert into ACC_Permission values('Url_PickList_New_button','拣货单新建-按钮','Distribution')
go
update ACC_Permission set Desc1='拣货单新建-查看' where code='Url_PickList_New'
go
update ACC_Permission set Desc1='拣货单新建-新建' where code='Url_PickList_New_button'