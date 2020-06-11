/****** Object:  StoredProcedure [dbo].[AddFTICRUmcMember] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.AddFTICRUmcMember
/****************************************************	
**	Adds row to the T_FTICR_UMC_Members table
**	returns 0 if success; error number on failure
**
**		Auth: mem
**		Date: 10/01/2004
**
****************************************************/
(
	@UMCResultsID int,			-- reference to T_FTICR_UMC_Results table
	@MemberTypeID tinyint,		-- reference to T_FPR_UMC_Member_Type_Name table
	@IndexInUMC smallint,		-- index of member in the given UMC
	@ScanNumber int,			-- scan number
	@MZ float,					-- m/z
	@ChargeState smallint,
	@MonoisotopicMass float,
	@Abundance float,
	@IsotopicFit real,
	@ElutionTime real,
	@IsChargeStateRep tinyint		-- 1 if the given member is the charge state rep in the UMC (i.e. most abundant member with the given charge state)
)
As
	Set NoCount On

	declare @returnvalue int
	set @returnvalue=0
		
	--append new row to the T_FTICR_UMC_Members table
	INSERT INTO T_FTICR_UMC_Members (
			UMC_Results_ID, Member_Type_ID, Index_in_UMC,
			Scan_Number, MZ, Charge_State,
			Monoisotopic_Mass, Abundance, Isotopic_Fit, 
			Elution_Time, Is_Charge_State_Rep)
	VALUES (@UMCResultsID, @MemberTypeID, @IndexInUMC,
			@ScanNumber, @MZ, @ChargeState,
			@MonoisotopicMass, @Abundance, @IsotopicFit, 
			@ElutionTime, @IsChargeStateRep)

	set @returnvalue=@@ERROR
	return @returnvalue


GO
GRANT EXECUTE ON [dbo].[AddFTICRUmcMember] TO [DMS_SP_User] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[AddFTICRUmcMember] TO [MTS_DB_Dev] AS [dbo]
GO
GRANT VIEW DEFINITION ON [dbo].[AddFTICRUmcMember] TO [MTS_DB_Lite] AS [dbo]
GO
