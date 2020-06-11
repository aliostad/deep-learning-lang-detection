/****** Object:  StoredProcedure [dbo].[sp_getNivelEffectiveReadPermissions]    Script Date: 05/21/2014 11:39:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_getNivelEffectiveReadPermissions] (@IDTrustee BIGINT, @IDNivel BIGINT) AS
BEGIN
	SET NOCOUNT ON

	CREATE TABLE #effective (IDNivel BIGINT PRIMARY KEY, IDUpper BIGINT, Ler TINYINT)
	INSERT INTO #effective VALUES (@IDNivel, @IDNivel, NULL)
	
	EXEC sp_getEffectiveReadPermissions @IDTrustee
	
	SELECT COALESCE(Ler,0) Ler FROM #effective
END
GO