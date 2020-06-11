insert into acc_permissioncategory values('Application','应用管理',1)
go
insert into acc_permissioncategory values('MasterData','基础数据',1)
go
insert into ACC_PermissionCategory values('Supplier','供应商',4)
go
insert into acc_user values('su','E10ADC3949BA59ABBE56E057F20F883E','超级','用户',0,null,null,null,'zh-CN',1,0,0,0,1,'用户 超级',GETDATE(),1,'用户 超级',getdate())
go
insert into sys_menu values('Menu_MasterData','基础数据',null,10,'基础数据',null,'~/Content/Images/Nav/MasterData.png',1)
go
insert into sys_menu values('Url_Supplier_View','供应商','Menu_MasterData',20,'供应商','~/Supplier/Index','~/Content/Images/Nav/Default.png',1)
go
insert into sys_menu values('Menu_Application','应用管理',null,1,'应用管理',null,'~/Content/Images/Nav/MasterData.png',1)
go
insert into sys_menu values('Url_UserFav_View','用户偏好','Menu_Application',10,'用户偏好','~/UserFavorite/Index','~/Content/Images/Nav/Default.png',1)
go
insert into SYS_CodeMstr values('Language','语言',0)
go
insert into SYS_CodeDet values('Language','zh-CN','CodeDetail_Language_zh_CN',1,1)
go
insert into SYS_CodeDet values('Language','en-US','CodeDetail_Language_en_US',0,2)
go
insert into SYS_EntityPreference values('10001',1,'20','DefaultPageSize',1,'用户 超级',getdate(),1,'用户 超级',getdate())
go
insert into SYS_EntityPreference values('10002',2,'5','SessionCachedSearchStatementCount',1,'用户 超级',getdate(),1,'用户 超级',getdate())
go
insert into SYS_EntityPreference values('10003',3,'0','测试系统标识',1,'用户 超级',getdate(),1,'用户 超级',getdate())
go
insert into SYS_EntityPreference values('10004',4,'1000','MaxRowSizeOnPage',1,'用户 超级',getdate(),1,'用户 超级',getdate())
go
insert into sys_menu values('Menu_Application_Permission','访问控制','Menu_Application',20,'访问控制',NULL,'~/Content/Images/Nav/Default.png',1)
go
insert into sys_menu values('Url_PermissionGroup_View','权限组','Menu_Application_Permission',10,'权限组','~/PermissionGroup/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_PermissionGroup_View','权限组','Application')
go
insert into sys_menu values('Url_Role_View','角色','Menu_Application_Permission',20,'角色','~/Role/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_Role_View','角色','Application')
go
insert into sys_menu values('Url_User_View','用户','Menu_Application_Permission',30,'用户','~/User/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_User_Delete','用户删除','Application')
go
insert into acc_permission values('Url_User_Edit','用户编辑','Application')
go 
insert into acc_permission values('Url_User_View','用户查看','Application')
go
insert into acc_permission values('Url_UserFav_Delete','用户偏好删除','Application')
go
insert into acc_permission values('Url_UserFav_Edit','用户偏好编辑','Application')
go
insert into acc_permission values('Url_UserFav_View','用户偏好查看','Application')
go
insert into acc_permission values('Url_Supplier_New','供应商新建','MasterData')
go
insert into acc_permission values('Url_Supplier_Delete','供应商删除','MasterData')
go
insert into acc_permission values('Url_Supplier_Edit','供应商编辑','MasterData')
go
insert into acc_permission values('Url_Supplier_View','供应商查看','MasterData')
go
insert into acc_permission values('Url_Location_Delete','库位删除','MasterData')
go
insert into acc_permission values('Url_Location_Edit','库位编辑','MasterData')
go
insert into acc_permission values('Url_Location_View','库位查看','MasterData')
go
insert into acc_permission values('Url_Uom_Delete','单位删除','MasterData')
go
insert into acc_permission values('Url_Uom_Edit','单位编辑','MasterData')
go
insert into acc_permission values('Url_Uom_View','单位查看','MasterData')
go
insert into sys_menu values('Url_Location_View','库位','Menu_MasterData',40,'库位','~/Location/Index','~/Content/Images/Nav/Default.png',1)
go
insert into sys_menu values('Url_Uom_View','计量单位','Menu_MasterData',30,'计量单位','~/Uom/Index','~/Content/Images/Nav/Default.png',1)
go
insert into acc_permission values('Url_Plant_New','工厂新建','MasterData')
go
insert into acc_permission values('Url_Plant_Delete','工厂删除','MasterData')
go
insert into acc_permission values('Url_Plant_Edit','工厂编辑','MasterData')
go
insert into acc_permission values('Url_Plant_View','工厂查看','MasterData')
go
insert into sys_menu values('Url_Plant_View','工厂','Menu_MasterData',25,'工厂','~/Plant/Index','~/Content/Images/Nav/Default.png',1)
go



