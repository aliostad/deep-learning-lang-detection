-----------------------------------------------------------------------------------
--Do not modify this file, instead use an alter proc to over-write the procedure.--
--Make sure you follow the same expected interface of parameters, and resultsets.--
-----------------------------------------------------------------------------------

IF EXISTS(SELECT * FROM [dbo].[sysobjects] WHERE ID=object_id(N'[Auth].[Permission_Update]') AND OBJECTPROPERTY(id, N'IsProcedure')=1) DROP PROC [Auth].[Permission_Update]
GO--
CREATE PROCEDURE [Auth].[Permission_Update] 
			@PermissionId int,
			@PermissionName varchar(100),
			@Title varchar(150),
			@IsRead bit
AS --Generated--
BEGIN

	UPDATE	[Auth].[Permission] SET 
			[PermissionName] = @PermissionName,
			[Title] = @Title,
			[IsRead] = @IsRead
	WHERE	[PermissionId] = @PermissionId

END