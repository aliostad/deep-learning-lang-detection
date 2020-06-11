USE [VehicleTrackerDb];
GO

IF OBJECT_ID('[dbo].[usp_Message_Select]') IS NOT NULL
BEGIN
    DROP PROC [dbo].[usp_Message_Select]
END
GO
CREATE PROC [dbo].[usp_Message_Select]
    @Id INT
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRAN

	SELECT [Id], [SenderId], [RecieverId], [MessageText], [IsRead]
	FROM   [dbo].[Messages]
	WHERE  ([Id] = @Id OR @Id IS NULL)

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Message_Insert]') IS NOT NULL
BEGIN
    DROP PROC [dbo].[usp_Message_Insert]
END
GO
CREATE PROC [dbo].[usp_Message_Insert]
    @SenderId int,
    @RecieverId int,
    @MessageText nvarchar(1000),
    @IsRead bit
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRAN

	INSERT INTO [dbo].[Messages] ([SenderId], [RecieverId], [MessageText], [IsRead])
	SELECT @SenderId, @RecieverId, @MessageText, @IsRead

	-- Begin Return Select <- do not remove
	SELECT [Id], [SenderId], [RecieverId], [MessageText], [IsRead]
	FROM   [dbo].[Messages]
	WHERE  [Id] = SCOPE_IDENTITY()
	-- End Return Select <- do not remove

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Message_Update]') IS NOT NULL
BEGIN
    DROP PROC [dbo].[usp_Message_Update]
END
GO
CREATE PROC [dbo].[usp_Message_Update]
    @Id int,
    @SenderId int,
    @RecieverId int,
    @MessageText nvarchar(1000),
    @IsRead bit
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRAN

	UPDATE [dbo].[Messages]
	SET    [SenderId] = @SenderId, [RecieverId] = @RecieverId, [MessageText] = @MessageText, [IsRead] = @IsRead
	WHERE  [Id] = @Id

	-- Begin Return Select <- do not remove
	SELECT [Id], [SenderId], [RecieverId], [MessageText], [IsRead]
	FROM   [dbo].[Messages]
	WHERE  [Id] = @Id
	-- End Return Select <- do not remove

	COMMIT
GO
IF OBJECT_ID('[dbo].[usp_Message_Delete]') IS NOT NULL
BEGIN
    DROP PROC [dbo].[usp_Message_Delete]
END
GO
CREATE PROC [dbo].[usp_Message_Delete]
    @Id int
AS
	SET NOCOUNT ON
	SET XACT_ABORT ON

	BEGIN TRAN

	DELETE
	FROM   [dbo].[Messages]
	WHERE  [Id] = @Id

	COMMIT
GO

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

