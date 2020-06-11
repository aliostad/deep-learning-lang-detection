USE [d4d]
GO
/****** Object:  StoredProcedure [dbo].[Show_Get]    Script Date: 10/26/2009 18:26:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Create date: 2009-10-11
-- =============================================
ALTER PROCEDURE [dbo].[Show_Get]
   @ShowId AS INT 
AS
BEGIN	
	
    SELECT 
               ShowId, 
              Title,
			   Body,
			   SImage,
			   LImage,
			   BandId,
			   ShowDate,			  
			   ShowPlace,
			   AddUserId,
			   AddDate,
			  [Status],
			  EndDate
    FROM shows With(nolock)
    WHERE ShowId =  @ShowId
 
END
