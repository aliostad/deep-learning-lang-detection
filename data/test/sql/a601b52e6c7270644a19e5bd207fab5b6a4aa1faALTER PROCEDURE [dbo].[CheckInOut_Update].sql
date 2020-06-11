USE [WiseEyeV5Express]
GO
/****** Object:  StoredProcedure [dbo].[CheckInOut_Update]    Script Date: 4/17/2015 4:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[CheckInOut_Update]
	@UserEnrollNumber int, @TimeStrOld datetime, @MachineNoOld int, @SourceOld nvarchar, 
	@OriginTypeNew nvarchar, @TimeDateNew datetime, @TimeStrNew datetime, @MachineNoNew int, @SourceNew nvarchar
AS
BEGIN
	declare @ID int
	insert into GioGoc (TimeStr, MachineNo, Source) 
	values				(@TimeStrOld, @MachineNoOld, @SourceOld)
	select @ID = @@Identity
	update  CheckInOut 
	set     TimeDate = @TimeDateNew, TimeStr = @TimeStrNew,
			OriginType = @OriginTypeNew, Source = @SourceNew, MachineNo = @MachineNoNew, IDGioGoc = @ID
	where   UserEnrollNumber = @UserEnrollNumber 
			and TimeStr = @TimeStrOld
			and (MachineNo % 2 = @MachineNoOld % 2)								
END
