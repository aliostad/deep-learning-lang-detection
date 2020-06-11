alter table MD_Supplier add MailAddress varchar(4000)


CREATE TABLE MD_LocItemOp(Id int identity(1,1) primary key,RowNo int,Location varchar(50),OpRef varchar(50),Item varchar(50)) 
go
create index IX_MD_LocItemOp_OpRefItem on MD_LocItemOp(OpRef,Item)
go

insert into SYS_Menu(Code,Name,Parent,Seq,Desc1,PageUrl,ImageUrl,IsActive)
select 'Url_Seq_SupplierMailAddress','供应商邮箱','Menu.Sequence.Setup',8600,'供应商邮箱','~/Supplier/Index','~/Content/Images/Nav/Default.png',1 union all
select 'Url_Ord_SupplierMailAddress','供应商邮箱','Menu.Order.Setup',1100,'供应商邮箱','~/Supplier/Index','~/Content/Images/Nav/Default.png',1 

go

insert into ACC_Permission(Code,Desc1,Category)
select 'Url_Seq_SupplierMailAddress','供应商邮箱','Sequence' union all
select 'Url_Ord_SupplierMailAddress','供应商邮箱','Order' 

 update SYS_Menu set Name='请购档查看',Desc1='请购档查看' where Code='Url_PurchaseOrder_View'
 
 insert into SYS_Menu values('Url_DeleteOrder_View','一车一单删除','Menu.VehicleOrder.Info',2550,'一车一单删除','~/ProductionOrder/DeleteOrderIndex','~/Content/Images/Nav/Default.png',1)

insert into ACC_Permission values('Url_DeleteOrder_View','一车一单删除','VehicleOrder')

