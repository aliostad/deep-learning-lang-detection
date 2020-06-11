set @id = %s;

(select
     'item' as type,
     if(i.locationId=l.id, 1, 0) as count,
    
     i.id itemId,
     m.id modelId,
    
     i.name itemName,
     m.name modelName,
    
     i.serial itemNumber,
     m.number modelNumber,

	 mk.name as makerName,
    
     img('item', i.imageId) as itemImage,
     img('model', m.imageId) as modelImage
    
     from user u inner join location l on u.id=l.userId 
	 inner join item i on i.locationId=l.id 
	 left join model m on i.modelId=m.id 
	 left join image ii on i.imageId=ii.id 
	 left join maker mk on m.makerId=mk.id 
	 where u.id=@id)

     union all

(select
     'model' as type,
     ifnull((select sum(if(t.from=l.id, -td.quantity, td.quantity)) from transactionDetail td inner join transaction t on t.id=td.transactionId inner join location l on l.id in (t.from, t.to) where l.userId=@id and td.modelId=m.id and t.confirmed=1), 0) as count,
    
     null as itemId,
     m.id modelId,
    
     null as itemName,
     m.name modelName,
    
     null as itemNumber,
     m.number modelNumber,
    
	 mk.name as makerName,

     null as itemImage,
     img('model', m.imageId) as modelImage
    
     from model m left join image mi on m.imageId=mi.id
		left join maker mk on m.makerId=mk.id 
     where m.noSerial=1
     having count > 0);