-- Find the Models and recognise which ones to move from and where to
select * from ModelManifest
select * from Model where id = 9
select * from Layer where id = 8

-- Get the element types you may be after. Projects should be 37 (Shared), and 38 (Private)
select * from ElementTypes where ElementTypeName like '%project%'

-- Analyze what elements are in the model
select ME.Name , MED.* from ModelElementData MED 
	join ModelElement ME
		on Me.ElementHandle = MED.ElementHandle
where MED.ModelId = 9

-- Update the model id after fine tuning the above SQL in the following. NOTE the ModelId where clause (PK: ModelId, ElementHandle)
update ModelElementData
	set ModelId = 19 
	where ElementHandle in (
		select MED.ElementHandle from ModelElementData MED 
		where MED.ModelId = 9
)
and ModelId = 9 -- this is critical as you can have modelElement data in different models (seperate layers)

