return
Insert into SYS_Menu
Select 'Url_Item_View','物料','Menu_MasterData','10','物料','~/Item/Index',
'~/Content/Images/Nav/Default.png',1

update SYS_Menu
Set imageurl='~/Content/Images/Nav/Default.png' from SYS_Menu where Code='Url_Item_View'
--update SYS_Menu Set name='物料' where Code ='Url_Item_View'
select top 100 * from ACC_permission where ID=28

Insert into ACC_permission 
Select 'Menu_MasterData_ItemType',Desc1 ,Category from Sconit5_dx.dbo. ACC_permission where Category ='Masterdata' and
Desc1 like '%物料%' and Code in ('Menu.MasterData.ItemType')



Select *from MD_uom
--Insert into MD_uom
--Select Code, Desc1, CreateUser, CreateUserNm, CreateDate, LastModifyUser, LastModifyUserNm, LastModifyDate
-- from Sconit5_dx.dbo.MD_uom  



select top 100 * from MD_uom

select top 100 * from sys.objects where name ='MD_item'
--供应商工厂 SCMSupplierPlant
Select top 1000 * from SCM_SupplierPlant
Select top 1000 * from SCM_SupplierItem 

 
select top 100 * from Sconit5_dx.dbo.SYS_MENU 
select top 100 * from  SYS_MENU 

Insert into SYS_Menu
Select 'Url_SCMSupplierPlant_View','供应商工厂','Menu_MasterData','60','供应商工厂','~/SCMSupplierPlant/Index',
'~/Content/Images/Nav/Default.png',1

Insert into ACC_permission 
Select 'Url_SCMSupplierPlant_View','供应商工厂','MasterData' union
Select 'Url_SCMSupplierPlant_Edit','供应商工厂编辑','MasterData' union
Select 'Url_SCMSupplierPlant_New','供应商工厂新增','MasterData' union
Select 'Url_SCMSupplierPlant_Delete','供应商工厂删除','MasterData'  






