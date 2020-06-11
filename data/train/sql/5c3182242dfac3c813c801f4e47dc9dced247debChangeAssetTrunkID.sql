DECLARE 
@SN nvarchar(50),@NewTrunkID nvarchar(50),@OldTrunkID nvarchar(50),@OldTrunkIDComments nvarchar(255),@NewTrunkIDComments nvarchar(255)

SET @SN = '444444'
SET @NewTrunkID = '654321'

SET @OldTrunkID = (SELECT trunk_id FROM dbo.assets WHERE aims_sn = @SN)
SET @OldTrunkIDComments = ('Trunk ID was switched to ' + @OldTrunkID + ' from ' + @NewTrunkID)
SET @NewTrunkIDComments = ('Trunk ID was switched to ' + @NewTrunkID + ' from ' + @OldTrunkID)

UPDATE dbo.assets SET trunk_id=@OldTrunkID,assetComments=@OldTrunkIDComments,modified_by=SUSER_NAME(),modified_date=GETDATE() WHERE trunk_id = @NewTrunkID;

UPDATE dbo.assets SET trunk_id=@NewTrunkID,assetComments=@NewTrunkIDComments,modified_by=SUSER_NAME(),modified_date=GETDATE() WHERE aims_sn = @SN;

SELECT * FROM dbo.assets WHERE aims_sn = @SN OR trunk_id = @NewTrunkID OR trunk_id = @OldTrunkID;
