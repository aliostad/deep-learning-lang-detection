select top 1 adid, make, model, categorypath from adsell where make = 'chevrolet' and model = 'cavalier'

select top 1 adid, make, model, categorypath from adsell where make = 'ford' and model = 'fiesta'


select top 4000 imagepath from adphoto (nolock) where adid in 
(select adid  from ad where Ad.AdAttributes.value('(//attributes/attribute[@id="128"]/item/@value)[1]','nvarchar(100)')  = '2/7/2000696/2043380') 




select imagepath from privatead..adphoto (nolock) where adid in 
(select adid from dba.machinelearning where make = 'Toyota' and model = 'Corolla') 


