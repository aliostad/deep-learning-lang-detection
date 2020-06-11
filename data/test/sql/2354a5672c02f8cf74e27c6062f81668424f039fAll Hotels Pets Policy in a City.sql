# Attributes for Pets in Hotels for Los Angeles, CA, US
USE eanprod;
SELECT activepropertylist.EANHotelID,activepropertylist.Name,propertyattributelink.AttributeID,
       attributelist.Type,attributelist.SubType,attributelist.AttributeDesc,propertyattributelink.AppendTxt as Value
FROM activepropertylist
	JOIN propertyattributelink
		ON activepropertylist.EANHotelID = propertyattributelink.EANHotelID 
	JOIN attributelist
		ON propertyattributelink.AttributeID = attributelist.AttributeID
WHERE  activepropertylist.City="Los Angeles" and activepropertylist.StateProvince="CA" 
		and activepropertylist.Country="US" and attributelist.SubType="Pets" ORDER BY EANHotelID;
