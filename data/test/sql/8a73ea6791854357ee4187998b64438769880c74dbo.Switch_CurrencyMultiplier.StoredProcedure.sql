USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[Switch_CurrencyMultiplier]    Script Date: 02/13/2012 17:17:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Switch_CurrencyMultiplier]
	-- Add the parameters for the stored procedure here
	 @param_strClientID nvarchar(50)
	,@param_strFundCurrency nchar(3)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    SELECT  (SELECT ExchangeRate/(SELECT ExchangeRate FROM NavGlobalDBwwwGUID.dbo.Currency WHERE Currency = (SELECT Currency FROM NavGlobalDBwwwGUID.dbo.Client where ClientID = @param_strClientID)) AS RelativeExch FROM NavGlobalDBwwwGUID.dbo.Currency WHERE Currency = @param_strFundCurrency)  AS CurrencyMultiplier
	FROM NavGlobalDBwwwGUID.dbo.Client
	INNER JOIN NavGlobalDBwwwGUID.dbo.Currency ON Client.Currency=Currency.Currency 
	WHERE Client.ClientID = @param_strClientID
END
GO
