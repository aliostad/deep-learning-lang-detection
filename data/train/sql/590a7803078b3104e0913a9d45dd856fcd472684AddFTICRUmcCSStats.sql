/****** Object:  StoredProcedure [dbo].[AddFTICRUmcCSStats] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.AddFTICRUmcCSStats
/****************************************************	
**	Adds row to the T_FTICR_UMC_CS_Stats table table
**  Modelled after AddFTICRUmcMember
**
**	Returns 0 if success; error number on failure
**
**	Auth:	mem
**	Date:	01/13/2010
**
****************************************************/
(
	@UMCResultsID int,				-- Reference to T_FTICR_UMC_Results table
	@ChargeState smallint,
	@MemberCount smallint,
	@MonoisotopicMass float,		-- Average or median monoisotopic mass of the members in this charge state
	@Abundance float,
	@ElutionTime real,
	@DriftTime real
)
As
	Set NoCount On

	declare @returnvalue int
	set @returnvalue=0
		
	--append new row to the T_FTICR_UMC_CS_Stats table
	INSERT INTO T_FTICR_UMC_CS_Stats( UMC_Results_ID,
	                                  Charge_State,
	                                  Member_Count,
	                                  Monoisotopic_Mass,
	                                  Abundance,
	                                  Elution_Time,
	                                  Drift_Time )
	VALUES(@UMCResultsID, @ChargeState, @MemberCount, @MonoisotopicMass, 
	       @Abundance, @ElutionTime, @DriftTime)

	set @returnvalue=@@ERROR

	return @returnvalue


GO
GRANT EXECUTE ON [dbo].[AddFTICRUmcCSStats] TO [DMS_SP_User] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[AddFTICRUmcCSStats] TO [MTS_DB_Dev] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[AddFTICRUmcCSStats] TO [MTS_DB_Lite] AS [dbo]
GO
