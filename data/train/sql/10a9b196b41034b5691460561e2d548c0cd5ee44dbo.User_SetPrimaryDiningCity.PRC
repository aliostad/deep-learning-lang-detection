if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[User_SetPrimaryDiningCity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[User_SetPrimaryDiningCity]
GO

CREATE PROCEDURE [dbo].User_SetPrimaryDiningCity
(
	@UserID int,  
	@IsCallerOrAdmin BIT,
	@OldPrimaryMetroID INT,
	@NewPrimaryMetroID INT
)
AS

SET NOCOUNT ON

DECLARE @ProcName nvarchar(1000)
DECLARE @Action nvarchar(3000)
DECLARE @DBError INT
DECLARE @OldSL BIT, @OldIn BIT, @OldDC BIT, @OldNH BIT, @OldRW BIT, @OldPM BIT, @OldPD BIT
SET @ProcName = 'User_SetPrimaryDiningCity'
SET @OldSL=0
SET @OldIn=0
set @OldDC=0
SET @OldNH=0
SET @OldRW =0 
SET @OldPM = 0
SET @OldPD = 0

BEGIN TRAN

	IF (@IsCallerOrAdmin = 1)  -- Must set CallerID
	BEGIN		
		SELECT @OldSL=Spotlight, @OldIn=Insider, @OldDC=DinersChoice, @OldNH=NewHot, 
		@OldRW=RestaurantWeek,@OldPM=Promotional, @OldPD=Product
		FROM dbo.UserOptIn
		WHERE CallerID = @UserID AND MetroAreaID = @OldPrimaryMetroID
		
		-- Check if new primary metro already exists for admin/caller
		IF EXISTS (SELECT * FROM UserOptIn WHERE CallerID = @UserID AND MetroAreaID = @NewPrimaryMetroID)
		BEGIN 
			SET @Action = 'Unsubscribe all email preferences of old primary metro for admin/caller'
			UPDATE UserOptIn SET Spotlight=0, Insider=0, DinersChoice=0, 
			NewHot=0, RestaurantWeek=0, Promotional=0, Product=0,
			UpdatedDtUTC = GETUTCDATE()
			WHERE CallerID = @UserID AND MetroAreaID = @OldPrimaryMetroID 			
			
			SET @Action = 'Relocate email preference from old to new primary metro for admin/caller'
			UPDATE UserOptIn SET 			
			SpotLight = CASE WHEN @OldSL = 1 THEN @OldSL ELSE Spotlight END,
			Insider = CASE WHEN @OldIn = 1 THEN @OldIn ELSE Insider END,
			DinersChoice = CASE WHEN @OldDC = 1 THEN @OldDC ELSE DinersChoice END,
			NewHot = CASE WHEN @OldNH = 1 THEN @OldNH ELSE NewHot END,
			RestaurantWeek = CASE WHEN @OldRW = 1 THEN @OldRW ELSE RestaurantWeek END,
			Promotional = CASE WHEN @OldPM = 1 THEN @OldPM ELSE Promotional END,
			Product = CASE WHEN @OldPD = 1 THEN @OldPD ELSE Product END,
			UpdatedDtUTC = GETUTCDATE()
			WHERE CallerID = @UserID AND MetroAreaID = @NewPrimaryMetroID 
		END 	
		ELSE
		BEGIN				
			SET @Action = 'Update old to new primary metro for admin/caller'
			UPDATE UserOptIn SET 		
			MetroAreaID = @NewPrimaryMetroID,
			UpdatedDtUTC = GETUTCDATE()				
			WHERE CallerID = @UserID AND MetroAreaID = @OldPrimaryMetroID 
		END						
	END
	ELSE	-- Must set CustID
	BEGIN		
		SELECT @OldSL=Spotlight, @OldIn=Insider, @OldDC=DinersChoice, @OldNH=NewHot, 
		@OldRW=RestaurantWeek,@OldPM=Promotional, @OldPD=Product
		FROM dbo.UserOptIn
		WHERE CustID = @UserID AND MetroAreaID = @OldPrimaryMetroID		
		
		-- Check if new primary metro already exists for customer
		IF EXISTS (SELECT * FROM UserOptIn WHERE CustID = @UserID AND MetroAreaID = @NewPrimaryMetroID)
		BEGIN 
			SET @Action = 'Unsubscribe all email preferences of old primary metro for customer'
			UPDATE UserOptIn SET Spotlight=0, Insider=0, DinersChoice=0, 
			NewHot=0, RestaurantWeek=0, Promotional=0, Product=0,
			UpdatedDtUTC = GETUTCDATE()
			WHERE CustID = @UserID AND MetroAreaID = @OldPrimaryMetroID 			
			
			SET @Action = 'Relocate email preference from old to new primary metro for customer'
			UPDATE UserOptIn SET 			
			SpotLight = CASE WHEN @OldSL = 1 THEN @OldSL ELSE Spotlight END,
			Insider = CASE WHEN @OldIn = 1 THEN @OldIn ELSE Insider END,
			DinersChoice = CASE WHEN @OldDC = 1 THEN @OldDC ELSE DinersChoice END,
			NewHot = CASE WHEN @OldNH = 1 THEN @OldNH ELSE NewHot END,
			RestaurantWeek = CASE WHEN @OldRW = 1 THEN @OldRW ELSE RestaurantWeek END,
			Promotional = CASE WHEN @OldPM = 1 THEN @OldPM ELSE Promotional END,
			Product = CASE WHEN @OldPD = 1 THEN @OldPD ELSE Product END,
			UpdatedDtUTC = GETUTCDATE()
			WHERE CustID = @UserID AND MetroAreaID = @NewPrimaryMetroID 
		END 	
		ELSE
		BEGIN				
			SET @Action = 'Update old to new primary metro for customer'
			UPDATE UserOptIn SET 		
			MetroAreaID = @NewPrimaryMetroID,
			UpdatedDtUTC = GETUTCDATE()		
			WHERE CustID = @UserID AND MetroAreaID = @OldPrimaryMetroID 
		END	
		
	END	

SET @DBError = @@ERROR
IF @DBError <> 0
	GOTO general_error

COMMIT TRAN
RETURN(0)

general_error:
	ROLLBACK TRANSACTION
	EXEC procLogProcedureError 1, @ProcName, @Action, @DBError
	RETURN(0)
GO

GRANT EXECUTE ON [User_SetPrimaryDiningCity] TO ExecuteOnlyRole
GO
