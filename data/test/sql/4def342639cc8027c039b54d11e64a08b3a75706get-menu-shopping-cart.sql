SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO

create  PROCEDURE [dbo].[GetMenuShoppingCart](@brand varchar(10)) AS

--declare @brand as varchar(10)

--set @brand = 'tts'

if (@brand = 'tts')

begin

select cat1.name 'cat1', cat2.name 'cat2', prod.name 'cat3',model.name,
model.mfgcode, model.[description], jimage.image_id

from jnctbrandcat a

inner join tblcategory cat1 on cat1.[id] = a.category_id and cat1.active
= 1

inner join jnctcatsubcat jntcat1 on jntcat1.category_id = cat1.[id]

inner join tblcategory cat2 on cat2.[id]= jntcat1.subcategory_id

inner join jnctcatprod catprod on catprod.category_id = cat2.id

inner join tblproduct prod on prod.id = catprod.product_id

inner join jnctprodmodel prodmod on prodmod.product_id = prod.id

inner join tblmodel model on model.id = prodmod.model_id

inner join jnctimage jimage on jimage.objid =model.id and lower(objtype)
= 'model'

where lower(a.brand_code) = @brand

union 

select cat1.name 'cat1', prod.name 'cat2', '' as 'cat3' , model.name,
model.mfgcode, model.[description], jimage.image_id

from jnctbrandcat a

inner join tblcategory cat1 on cat1.[id] = a.category_id and cat1.active
= 1

--inner join jnctcatsubcat jntcat1 on jntcat1.category_id = cat1.[id]

--inner join tblcategory cat2 on cat2.[id]= jntcat1.subcategory_id

inner join jnctcatprod catprod on catprod.category_id = cat1.id

inner join tblproduct prod on prod.id = catprod.product_id

inner join jnctprodmodel prodmod on prodmod.product_id = prod.id

inner join tblmodel model on model.id = prodmod.model_id

inner join jnctimage jimage on jimage.objid =model.id  and
lower(objtype) = 'model'

where a.brand_code = @brand and cat1.name in ('Fan Coils', 'Air
Handlers')

 

 

 

end

else if (@brand = 'kru')

begin

select cat1.name 'cat1',  prod.name 'cat2','' as 'cat3', model.name,
model.mfgcode,dbo.getmodeldetaildesc(model.id), jimage.image_id

from jnctbrandcat a

inner join tblcategory cat1 on cat1.[id] = a.category_id and cat1.active
= 1

--inner join jnctcatsubcat jntcat1 on jntcat1.category_id = cat1.[id]

--inner join tblcategory cat2 on cat2.[id]= jntcat1.subcategory_id

inner join jnctcatprod catprod on catprod.category_id = cat1.id

inner join tblproduct prod on prod.id = catprod.product_id

inner join jnctprodmodel prodmod on prodmod.product_id = prod.id

inner join tblmodel model on model.id = prodmod.model_id

inner join jnctimage jimage on jimage.objid =model.id and lower(objtype)
= 'model'

where lower(a.brand_code) = @brand

end

else if (@brand = 'tnb')

begin

select  cat1.name 'cat1',prod.name 'cat2', '' as 'cat3', model.name,
model.mfgcode, model.[description], jimage.image_id

from jnctbrandcat a

inner join tblcategory cat1 on cat1.[id] = a.category_id and cat1.active
= 1

--inner join jnctcatsubcat jntcat1 on jntcat1.category_id = cat1.[id]

--inner join tblcategory cat2 on cat2.[id]= jntcat1.subcategory_id

inner join jnctcatprod catprod on catprod.category_id = cat1.id

inner join tblproduct prod on prod.id = catprod.product_id

inner join jnctprodmodel prodmod on prodmod.product_id = prod.id

inner join tblmodel model on model.id = prodmod.model_id

inner join jnctimage jimage on jimage.objid =model.id and lower(objtype)
= 'model'

where lower(a.brand_code) = @brand

end

else if (@brand = 'pby')

begin

select  cat1.name 'cat1', cat2.name 'cat2', cat3.name 'cat3', prod.name
'cat4',  model.name, model.mfgcode, model.[description], jimage.image_id

from jnctbrandcat a

inner join tblcategory cat1 on cat1.[id] = a.category_id and cat1.active
= 1

inner join jnctcatsubcat jntcat1 on jntcat1.category_id = cat1.[id]

inner join tblcategory cat2 on cat2.[id]= jntcat1.subcategory_id

inner join jnctcatsubcat jntcat2 on jntcat2.category_id = cat2.[id]

inner join tblcategory cat3 on cat3.[id] = jntcat2.subcategory_id

inner join jnctcatprod catprod on catprod.category_id = cat3.id

inner join tblproduct prod on prod.id = catprod.product_id

inner join jnctprodmodel prodmod on prodmod.product_id = prod.id

inner join tblmodel model on model.id = prodmod.model_id

inner join jnctimage jimage on jimage.objid =prod.id and lower(objtype)
= 'product'

where lower(a.brand_code) = @brand

end


GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

