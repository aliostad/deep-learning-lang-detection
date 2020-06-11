SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[CMS_GetTableToolsFilters_XML]
	@tableName VARCHAR(100),
	@leagueName VARCHAR(100),
	@tableKey VARCHAR(100)
AS
--=============================================
-- Author:	  ikenticus
-- Create date: 10/09/2015
-- Description: get table tools filters for SportsEditCMS
-- Update:		10/14/2015 - ikenticus: adding SMG_Data_Front_Attrs, setting delete field,
--										fixing PGA Tour select, adding key_nav_display and nav_mode
-- 				10/29/2015 - ikenticus: adding SMG_Mappings and league_nav_display
-- 				11/11/2015 - ikenticus: adding Suspender_List
-- =============================================
BEGIN
    SET NOCOUNT ON
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	-- set nav_mode, delete field
	DECLARE @nav_mode VARCHAR(100)
	DECLARE @delete_field VARCHAR(100)
	DECLARE @delete_value VARCHAR(100) = 'delete'


    -- tables
    DECLARE @tables TABLE
	(
	    id VARCHAR(100),
	    display VARCHAR(100),
		priority INT
	)

	INSERT INTO @tables (priority, id, display)
	VALUES (1, 'default_dates', 'Default Dates'),
		   (2, 'data_front_attrs', 'Data Front Attrs'),
		   (3, 'arrests', 'Arrests'),
		   (4, 'mappings', 'Mappings'),
		   (5, 'suspender_list', 'Suspender List')

    IF NOT EXISTS (SELECT 1 FROM @tables WHERE id = @tableName)
	BEGIN
		SELECT TOP 1 @tableName = id
		  FROM @tables
		 ORDER BY priority ASC
	END

	DECLARE @table_display VARCHAR(100)

	SELECT @table_display = display
	  FROM @tables
	 WHERE id = @tableName


    -- leagues
    DECLARE @leagues TABLE
	(
	    id VARCHAR(100),
	    display VARCHAR(100),
		priority INT IDENTITY(1, 1)
	)

	DECLARE @league_nav_display VARCHAR(100) = 'league'

	IF (@tableName = 'arrests')
	BEGIN
		SET @nav_mode = 'dropdown'
		SET @delete_field = '_case_'

		INSERT INTO @leagues (id, display)
		SELECT LOWER(sport), UPPER(sport)
		  FROM dbo.Feeds_Arrests
		 GROUP BY sport
		 ORDER BY sport ASC
	END
	ELSE IF (@tableName = 'data_front_attrs')
	BEGIN
		SET @nav_mode = 'all'
		SET @delete_field = 'value'

		INSERT INTO @leagues (id, display)
		VALUES ('all', 'All Leagues')

		INSERT INTO @leagues (id, display)
		SELECT LOWER(league_name), UPPER(league_name)
		  FROM dbo.SMG_Data_Front_Attrs
		 GROUP BY league_name
		 ORDER BY league_name ASC
	END
	ELSE IF (@tableName = 'default_dates')
	BEGIN
		SET @nav_mode = 'all'
		SET @delete_field = 'filter'

		INSERT INTO @leagues (id, display)
		VALUES ('all', 'All Leagues')

		INSERT INTO @leagues (id, display)
		SELECT LOWER(league_key), CASE WHEN LEN(league_key) <= 5 THEN UPPER(league_key)
								  ELSE UPPER(LEFT(league_key, 1)) + LOWER(RIGHT(league_key, LEN(league_key) - 1))
								  END
		  FROM SportsDB.dbo.SMG_Default_Dates
		 WHERE league_key <> ''				-- exclude empty
		   AND league_key NOT LIKE 'l.%'	-- exclude legacy
		   AND page <> 'source'				-- exclude source
		 GROUP BY league_key
		 ORDER BY league_key ASC

		IF (@tableKey = 'source')
		BEGIN
			SET @leagueName = 'all'
		END
	END
	ELSE IF (@tableName = 'mappings')
	BEGIN
		SET @nav_mode = 'dropdown'
		SET @delete_field = 'value_to'
		SET @league_nav_display = 'Sources'

		INSERT INTO @leagues (id, display)
		VALUES ('all', 'All Sources')

		INSERT INTO @leagues (id, display)
		SELECT LOWER(source), UPPER(source)
		  FROM SportsDB.dbo.SMG_Mappings
		 GROUP BY source
		 ORDER BY source ASC
	END
	ELSE IF (@tableName = 'suspender_list')
	BEGIN
		SET @nav_mode = 'all'
		SET @delete_field = '_order_'
		SET @delete_value = '-1'

		INSERT INTO @leagues (id, display)
		VALUES ('all', 'All Leagues')

		INSERT INTO @leagues (id, display)
		SELECT LOWER(sport), sport
		  FROM SportsDB.dbo.SMG_Suspender_List
		 GROUP BY sport
		 ORDER BY sport ASC

		IF (@tableKey = 'source')
		BEGIN
			SET @leagueName = 'all'
		END
	END
    IF NOT EXISTS (SELECT 1 FROM @leagues WHERE id = @leagueName)
	BEGIN
		SELECT TOP 1 @leagueName = id
		  FROM @leagues
		 ORDER BY priority ASC
	END


    -- key
    DECLARE @keys TABLE
	(
	    id VARCHAR(100),
	    display VARCHAR(100),
		priority INT IDENTITY(1, 1)
	)

	DECLARE @key_nav_display VARCHAR(100)

	IF (@tableName = 'arrests')
	BEGIN
		SET @key_nav_display = 'SEASON'

		INSERT INTO @keys (id, display)
		SELECT YEAR([date]), YEAR([date])
		  FROM dbo.Feeds_Arrests
		 GROUP BY YEAR([date])
		 ORDER BY YEAR([date]) DESC
	END
	ELSE IF (@tableName = 'data_front_attrs')
	BEGIN
		SET @key_nav_display = 'PAGE'

		INSERT INTO @keys (id, display)
		VALUES ('all', 'All Pages')

		INSERT INTO @keys (id, display)
		SELECT LOWER(page_id), page_id
		  FROM dbo.SMG_Data_Front_Attrs
		 GROUP BY page_id
		 ORDER BY page_id ASC
	END
	ELSE IF (@tableName = 'default_dates')
	BEGIN
		SET @key_nav_display = 'PAGE'

		INSERT INTO @keys (id, display)
		VALUES ('all', 'All Pages')

		INSERT INTO @keys (id, display)
		SELECT LOWER(page), UPPER(LEFT(page, 1)) + LOWER(RIGHT(page, LEN(page) - 1))
		  FROM SportsDB.dbo.SMG_Default_Dates
		 WHERE league_key = ISNULL(NULLIF(@leagueName, 'all'), league_key)
		   AND league_key <> ''				-- exclude empty
		   AND league_key NOT LIKE 'l.%'	-- exclude legacy
		 GROUP BY page
		 ORDER BY page ASC

		IF (@leagueName = 'all' AND @tableKey = 'all')
		BEGIN
			SELECT TOP 1 @tableKey = id
			  FROM @keys
			 WHERE id <> 'all'
			 ORDER BY priority ASC
		END
	END
	ELSE IF (@tableName = 'mappings')
	BEGIN
		SET @key_nav_display = 'Types'

		INSERT INTO @keys (id, display)
		VALUES ('all', 'All Types')

		INSERT INTO @keys (id, display)
		SELECT LOWER(value_type), UPPER(REPLACE(value_type, '-', ' '))
		  FROM SportsDB.dbo.SMG_Mappings
		 GROUP BY value_type
		 ORDER BY value_type ASC
	END
	ELSE IF (@tableName = 'suspender_list')
	BEGIN
		SET @key_nav_display = 'PLATFORM'

		INSERT INTO @keys (id, display)
		VALUES ('all', 'All Platforms')

		INSERT INTO @keys (id, display)
		SELECT LOWER(platform), platform
		  FROM SportsDB.dbo.SMG_Suspender_List
		 GROUP BY platform
		 ORDER BY platform ASC

		IF (@leagueName = 'all' AND @tableKey = 'all')
		BEGIN
			SELECT TOP 1 @tableKey = id
			  FROM @keys
			 WHERE id <> 'all'
			 ORDER BY priority ASC
		END
	END

    IF NOT EXISTS (SELECT 1 FROM @keys WHERE id = @tableKey)
	BEGIN
		SELECT TOP 1 @tableKey = id
		  FROM @keys
		 ORDER BY priority ASC
	END

	DECLARE @key_display VARCHAR(100)

	SELECT @key_display = display
	  FROM @keys
	 WHERE id = @tableKey


    -- selects
	DECLARE @selects TABLE
	(
	    id VARCHAR(100),
	    display VARCHAR(100),
		priority INT IDENTITY(1, 1)
	)

	DECLARE @league_source VARCHAR(100)
	DECLARE @override VARCHAR(100)
	DECLARE @selections XML

	IF (@tableKey = 'source')
	BEGIN
		SELECT TOP 1 @league_source = filter, @override = week
		  FROM SportsDB.dbo.SMG_Default_Dates
		 WHERE league_key = 'pga-tour' AND page = 'source'
		
		INSERT INTO @selects (id, display)
		VALUES ('', 'PGA Tour Default Feed')

		INSERT INTO @selects (id, display)
		SELECT event_key, event_name
		  FROM SportsDB.dbo.SMG_Solo_Leagues AS l
		 INNER JOIN SportsDB.dbo.SMG_Solo_Events AS e ON e.league_key = l.league_key AND e.season_key = l.season_key
		 INNER JOIN SportsDB.dbo.SMG_Mappings AS m ON value_from = l.league_key AND source = @league_source
		 WHERE GETDATE() BETWEEN start_date_time AND end_date_time AND league_id = 'pga-tour' AND m.value_type = 'league'
		 ORDER BY start_date_time ASC

		;WITH XMLNAMESPACES ('http://james.newtonking.com/projects/json' AS json)
		SELECT @selections = (
			SELECT
				(
				SELECT
					(
						SELECT id, display, 'true' AS 'json:Array'
						  FROM @selects
						 ORDER BY priority ASC
						   FOR XML RAW('pga_tour_source_week'), TYPE
					)
				   FOR XML RAW('selects'), TYPE
				)
			   FOR XML RAW('root'), TYPE
		)
	END


	;WITH XMLNAMESPACES ('http://james.newtonking.com/projects/json' AS json)
    SELECT
    (
        SELECT @tableName AS [table], @table_display AS table_display,
			   @leagueName AS league, @league_nav_display AS league_nav_display,
			   @tableKey AS [key], @key_display AS key_display,
			   @key_nav_display AS key_nav_display, @nav_mode AS nav_mode,
			   @delete_field AS delete_field, @delete_value AS delete_value
           FOR XML RAW('default'), TYPE
    ),
    (
        SELECT id, display, 'true' AS 'json:Array'
          FROM @tables
         ORDER BY priority ASC
           FOR XML RAW('table'), TYPE
    ),
    (
        SELECT id, display, 'true' AS 'json:Array'
          FROM @leagues
         ORDER BY priority ASC
           FOR XML RAW('league'), TYPE
    ),
    (
        SELECT id, display, 'true' AS 'json:Array'
          FROM @keys
		 ORDER BY priority ASC
           FOR XML RAW('key'), TYPE

    ),
	(
		SELECT node.query('selects') FROM @selections.nodes('//root') AS SMG(node)
	)
    FOR XML RAW('root'), TYPE
    
END

GO
GRANT VIEW DEFINITION ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [edpsqlprodsedbrwuser ]
GO
GRANT EXECUTE ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [edpsqlprodsedbrwuser ]
GO
GRANT EXECUTE ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [edpsqlprodsvdbrwuser]
GO
GRANT EXECUTE ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [edpsqlproduser]
GO
GRANT VIEW DEFINITION ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [GMTI\Rights-AIME-SQLRW-RO]
GO
GRANT EXECUTE ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [GMTI\Rights-AIME-SQLRW-RO]
GO
GRANT VIEW DEFINITION ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [GMTI\Rights-AIME-SQLRW-RW]
GO
GRANT EXECUTE ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [GMTI\Rights-AIME-SQLRW-RW]
GO
GRANT VIEW DEFINITION ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [USATCoreDBUser]
GO
GRANT EXECUTE ON  [dbo].[CMS_GetTableToolsFilters_XML] TO [USATCoreDBUser]
GO
