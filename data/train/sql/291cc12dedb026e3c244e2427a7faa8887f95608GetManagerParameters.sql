/****** Object:  StoredProcedure [dbo].[GetManagerParameters] ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.GetManagerParameters
/****************************************************
** 
**	Desc:	Gets the parameters for the given analysis manager
**			Uses MgrSettingGroupName to lookup parameters from the parent group, if any
**
**	Return values: 0: success, otherwise, error code
**
**	Auth:	mem
**	Date:	05/07/2015 mem - Initial version
**			08/10/2015 mem - Added @SortMode=3
**			09/02/2016 MEM - Increase the default for parameter @MaxRecursion from 5 to 50
**    
*****************************************************/
(
	@ManagerNameList varchar(4000) = '',
	@SortMode tinyint = 0,					-- 0 means sort by ParamTypeID then MgrName, 1 means ParamName, then MgrName, 2 means MgrName, then ParamName, 3 means Value then ParamName
	@MaxRecursion tinyint = 50,
	@message varchar(512)='' output
)
As
	Set NoCount On
	
	declare @myRowCount int
	declare @myError int
	set @myRowCount = 0
	set @myError = 0
	
	-----------------------------------------------
	-- Validate the inputs
	-----------------------------------------------
	--
	Set @ManagerNameList = IsNull(@ManagerNameList, '')
	
	Set @SortMode = IsNull(@SortMode, 0)
	
	If @MaxRecursion > 10
		Set @MaxRecursion = 10
		
	-----------------------------------------------
	-- Create the Temp Tables
	-----------------------------------------------
	--
	/*
	If Exists (Select * From sys.tables where Name = '#Tmp_Mgr_Params')
	Begin
		Drop Table #Tmp_Mgr_Params
	End
	
	If Exists (Select * From sys.tables where Name = '#Tmp_Manager_Group_Info')
	Begin
		Drop Table #Tmp_Manager_Group_Info
	End
	*/
	
	CREATE TABLE #Tmp_Mgr_Params (
		M_Name varchar(50) NOT NULL,
		ParamName varchar(50) NOT NULL,
		Entry_ID int NOT NULL,
		TypeID int NOT NULL,
		Value varchar(128) NOT NULL,
		MgrID int NOT NULL,
		Comment varchar(255) NULL,
		Last_Affected datetime NULL,
		Entered_By varchar(128) NULL,
		M_TypeID int NOT NULL,
		ParentParamPointerState tinyint,
		Source varchar(50) NOT NULL
	) 

	CREATE TABLE #Tmp_Manager_Group_Info (
		M_Name varchar(50) NOT NULL,
		Group_Name varchar(128) NOT NULL
	) 

	-----------------------------------------------
	-- Lookup the initial manager parameters
	-----------------------------------------------
	--

	INSERT INTO #Tmp_Mgr_Params( M_Name,
	                             ParamName,
	                             Entry_ID,
	                             TypeID,
	                             Value,
	                             MgrID,
	                             Comment,
	                             Last_Affected,
	                             Entered_By,
	                             M_TypeID,
	                             ParentParamPointerState,
	                             Source )
	SELECT M_Name,
	       ParamName,
	       Entry_ID,
	       TypeID,
	       Value,
	       MgrID,
	       Comment,
	       Last_Affected,
	       Entered_By,
	       M_TypeID,
	       CASE
	           WHEN TypeID = 162 THEN 1		-- ParamName 'Default_AnalysisMgr_Params'
	           ELSE 0
	       END,
	       M_Name
	FROM V_ParamValue
	WHERE (M_Name IN (Select Value From dbo.udfParseDelimitedList(@ManagerNameList, ',')))
	--
	SELECT @myError = @@error, @myRowCount = @@rowcount


	-----------------------------------------------
	-- Append parameters for parent groups, which are
	-- defined by parameter Default_AnalysisMgr_Params (TypeID 162)
	-----------------------------------------------
	--
	Declare @iterations tinyint = 0
	
	While Exists (Select * from #Tmp_Mgr_Params Where ParentParamPointerState = 1) And @iterations < @MaxRecursion
	Begin
		Truncate table #Tmp_Manager_Group_Info
		
		INSERT INTO #Tmp_Manager_Group_Info (M_Name, Group_Name)
		SELECT M_Name, Value
		FROM #Tmp_Mgr_Params
		WHERE (ParentParamPointerState = 1)

	     
	    UPDATE #Tmp_Mgr_Params
	    Set ParentParamPointerState = 2
		WHERE (ParentParamPointerState = 1)


		INSERT INTO #Tmp_Mgr_Params( M_Name,
		                              ParamName,
		                        Entry_ID,
		                              TypeID,
		                              Value,
		                              MgrID,
		                              Comment,
		                              Last_Affected,
		                              Entered_By,
		                              M_TypeID,
		                              ParentParamPointerState,
		                              Source )
		SELECT ValuesToAppend.M_Name,
		       ValuesToAppend.ParamName,
		       ValuesToAppend.Entry_ID,
		       ValuesToAppend.TypeID,
		       ValuesToAppend.Value,
		       ValuesToAppend.MgrID,
		       ValuesToAppend.Comment,
		       ValuesToAppend.Last_Affected,
		       ValuesToAppend.Entered_By,
		       ValuesToAppend.M_TypeID,
		       CASE
		 WHEN ValuesToAppend.TypeID = 162 THEN 1
		           ELSE 0
		       END,
		       ValuesToAppend.Source
		FROM #Tmp_Mgr_Params Target
		     RIGHT OUTER JOIN ( SELECT FilterQ.M_Name,
		                               PV.ParamName,
		                               PV.Entry_ID,
		                               PV.TypeID,
		                               PV.Value,
		                               PV.MgrID,
		                               PV.Comment,
		                               PV.Last_Affected,
		                               PV.Entered_By,
		                               PV.M_TypeID,
		                               PV.M_Name AS Source
		                        FROM V_ParamValue PV
		                             INNER JOIN ( SELECT M_Name,
		                                                 Group_Name
		                                          FROM #Tmp_Manager_Group_Info ) FilterQ
		                               ON PV.M_Name = FilterQ.Group_Name ) ValuesToAppend
		       ON Target.M_Name = ValuesToAppend.M_Name AND
		          Target.TypeID = ValuesToAppend.TypeID
		WHERE (Target.TypeID IS NULL Or ValuesToAppend.typeID = 162)

		-- This is a safety check in case a manager has a Default_AnalysisMgr_Params value pointing to itself
		Set @iterations = @iterations + 1
		
	End


	If @SortMode = 0
		SELECT *
		FROM #Tmp_Mgr_Params
		ORDER BY TypeID, M_Name
	
	If @SortMode = 1
		SELECT *
		FROM #Tmp_Mgr_Params
		ORDER BY ParamName, M_Name

	If @SortMode = 2
		SELECT *
		FROM #Tmp_Mgr_Params
		ORDER BY M_Name, ParamName

	If @SortMode Not In (0,1,2)
		SELECT *
		FROM #Tmp_Mgr_Params
		ORDER BY Value, ParamName

		
Done:
	Return @myError


GO
