USE [NavIntegrationDB]
GO
/****** Object:  StoredProcedure [dbo].[CurrencyConvert]    Script Date: 02/13/2012 17:17:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[CurrencyConvert]
	-- Add the parameters for the stored procedure here
	 @param_strClientID nvarchar(50)
	,@param_fValueToConvert float
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT  @param_fValueToConvert / Currency.ExchangeRate AS ConvertedValue
	FROM NavGlobalDBwwwGUID.dbo.Client
	INNER JOIN NavGlobalDBwwwGUID.dbo.Currency ON Client.Currency=Currency.Currency 
	WHERE Client.ClientID = @param_strClientID
END
GO
