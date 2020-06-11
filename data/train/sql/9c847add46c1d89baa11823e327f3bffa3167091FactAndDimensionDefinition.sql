
/* Updating the Enable column for older version to 0  */

Update [InsurerAnalyticsSupport].[FactAndDimensionDefinition]
set Enable = 0
where  Name = 'Client Dimension'
AND JobType = 'Claims'

/* Inserting the new metadata for the Extension Procedure */

insert into [InsurerAnalyticsSupport].[FactAndDimensionDefinition] ([Order],name,SQLStatement,[Enable],JobType,DefinitionType,[Description])
values (40,
	   'Client Dimension',
	   'DECLARE	
		@NewRecords int,
		@ChangedRecords int,
		@ExpiredSCD2Records int,
		@RecordsRead int

EXEC	[InsurerAnalyticsSupport].[ProcessClaimsClientDimension__Extension]
		@ExtractRunID = ?,
		@NewRecords = @NewRecords OUTPUT,
		@ChangedRecords = @ChangedRecords OUTPUT,
		@ExpiredSCD2Records = @ExpiredSCD2Records OUTPUT,
		@RecordsRead = @RecordsRead OUTPUT

SELECT	@NewRecords AS N''NewRecords'',
		@ChangedRecords AS N''ChangedRecords'',
		@ExpiredSCD2Records AS N''ExpiredSCD2Records'',
		@RecordsRead AS N''RecordsRead''',

		'Claims',
		'Dimension',
		'Definition to process Claimants into the Client Dimension')