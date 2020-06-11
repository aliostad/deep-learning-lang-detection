USE [ORMS]
GO

/****** Object:  UserDefinedFunction [dbo].[FN_GET_MODEL_NAME]    Script Date: 01/17/2011 10:14:11 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

If Exists (Select * From sysobjects
      Where id = object_id(N'[dbo].[FN_GET_MODEL_NAME]')
        And OBJECTPROPERTY(id, N'IsScalarFunction') = 1)
  Drop FUNCTION [dbo].[FN_GET_MODEL_NAME]
GO


/*
--------------------------------------------------------------------
TITLE 		: 모델코드로 모델명 조회
DATE		: 2010.06.01
CREATOR	: FIT
DESCRIPTION	: 
	SELECT dbo.FN_GET_MODEL_NAME('01') 
--------------------------------------------------------------------
*/
CREATE	   FUNCTION  [dbo].[FN_GET_MODEL_NAME]
(
  @parm_MODEL 	AS VARCHAR(10)		-- 모델코드  
)

RETURNS VARCHAR(40) AS  

BEGIN 

  DECLARE @ls_NAME 	AS VARCHAR(40)

  SELECT @ls_NAME	= MODEL_NAME 
     FROM TM_MODEL
   WHERE MODEL		= @parm_MODEL

  IF (@ls_NAME is null)
  	SET @ls_NAME 	= ''

  RETURN @ls_NAME

END



GO

