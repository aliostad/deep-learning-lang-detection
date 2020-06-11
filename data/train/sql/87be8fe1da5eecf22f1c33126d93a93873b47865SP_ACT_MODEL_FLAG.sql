USE [ORMS]
GO

/****** Object:  StoredProcedure [dbo].[SP_ACT_MODEL_FLAG]    Script Date: 01/17/2011 10:09:37 ******/
SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER ON
GO

If Exists (Select * From sysobjects
      Where id = object_id(N'[dbo].[SP_ACT_MODEL_FLAG]')
        And OBJECTPROPERTY(id, N'IsProcedure') = 1)
  Drop Procedure [dbo].[SP_ACT_MODEL_FLAG]
GO


/*
--------------------------------------------------------------------
TITLE 		: 모델중에서 현재사용을 FLAG처리한다. 
DATE		: 2010.06.01 
CREATOR	: FIT
DESCRIPTION	: (가동율 PB 프로그램에서 호출) 
--------------------------------------------------------------------
*/
CREATE       PROCEDURE [dbo].[SP_ACT_MODEL_FLAG] 
(
  @parm_MODEL		varchar(10),			-- 모델정보	 
  @parm_TYPE		varchar(1) 			-- 유형  	
) 
AS
BEGIN

  SET NOCOUNT ON 

  UPDATE TM_MODEL_CYCLE
         SET FLAG	= ''
   WHERE MODEL	= @parm_MODEL


  UPDATE TM_MODEL_CYCLE
         SET FLAG	= 'Y'
   WHERE MODEL	= @parm_MODEL
        AND TYPE	= @parm_TYPE

  SET NOCOUNT OFF 

END





GO

