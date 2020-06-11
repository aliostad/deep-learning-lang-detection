USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewLabID int

EXEC	@return_value = [dbo].[usp_InsertLab]
		@LabName = N'Labcore',
		@LabDescription = N'new state of the art testing laboratory',
		@Notes = N'Up and coming lab with state of the art equiopment and knowledgable staff',
		@NewLabID = @NewLabID OUTPUT

SELECT	@NewLabID as N'@NewLabID'

SELECT	'Return Value' = @return_value

GO


Select * from Lab