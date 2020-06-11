--	Modifier	:	Vinayak Mishra
--	Purpose		:	To get all Models on which dealer is working based on its DealerId or BranchId
--	============================================================

CREATE PROCEDURE [dbo].[GetModelOnBranchId_Api]

@BranchId	INT,
@ApplicationId TINYINT = 1
AS

BEGIN
	SELECT DISTINCT V.ModelId AS Value, V.Model AS Text 
     FROM TC_DealerMakes D WITH(NOLOCK) 
     INNER JOIN  Dealers AS DNC WITH(NOLOCK)  ON DNC.ID=D.DealerId
	 INNER JOIN vwMMV V   WITH(NOLOCK)  ON V.MakeId = D.MakeId 
    WHERE D.DealerId = @BranchId
	 AND V.IsModelNew=1
	 AND V.ModelId NOT IN (Select ModelId from TC_NoDealerModels WITH(NOLOCK) WHERE DealerId = @BranchId )
	 ORDER BY V.Model
END