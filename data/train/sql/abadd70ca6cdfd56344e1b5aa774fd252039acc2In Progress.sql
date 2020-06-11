
SELECT *
FROM TransformEquipmentFacilitiesEquipmentModelIDLookup modid 
WHERE modid.SourceModelID LIKE '%CERABAR%'
	--modid.TargetModelID LIKE 'L/2%'
	modid.Manufacturer_ID = 'FLYGT PUMPS'
ORDER BY Manufacturer_ID, SourceModelID, TargetModelID

UPDATE TransformEquipmentFacilitiesEquipmentModelIDLookup
SET SourceModelID = 'CP 3152', TargetModelID = 'CP 3152'
WHERE Manufacturer_ID = 'FLYGT PUMPS'
	AND SourceModelID = 'CP-3152' AND TargetModelID = 'NP3102'

SELECT OE.OBJECT_ID, oe.FAC_MODEL
FROM SourceWicm210ObjectEquipment OE
WHERE OE.[OBJECT_ID] = 'PIT1671'
	--OE.FAC_MODEL LIKE 'IGF%'
	--VENDOR LIKE 'BJM%'

SELECT *
FROM TransformEquipmentManufacturerModel
WHERE CleansedManufacturerID = 'PUMPS%'

UPDATE TransformEquipmentManufacturerModel
SET CleansedModelID = '24RXL',
	ModelName = '24RXL'
WHERE CleansedManufacturerID = 'BYRON JACKSON'
	AND CleansedModelID = '24RX-L'
	AND ModelName = '24RX-L'


		-- ModelID Cleansing
		--INNER JOIN TransformEquipmentFacilitiesEquipmentModelIDLookup modid 
		--	ON LEFT(LTRIM(RTRIM(midc.[TargetValue])), 15) = modid.Manufacturer_ID
		--		AND LEFT(LTRIM(RTRIM(OE.FAC_MODEL)), 15) = modid.SourceModelID

SELECT * FROM TransformEquipmentManufacturer
WHERE ManufacturerName LIKE 'FLYGT%'

DELETE TransformEquipmentFacilitiesEquipmentModelIDLookup
WHERE Manufacturer_ID = 'FLYGT PUMPS'
