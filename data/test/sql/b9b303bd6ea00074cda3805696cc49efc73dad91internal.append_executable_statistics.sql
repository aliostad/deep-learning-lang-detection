SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [internal].[append_executable_statistics]
        @operation_id       bigint,                             
        @project_id         bigint,
        @version_id         bigint,
        @package_name       nvarchar(260),
        @package_location_type nvarchar(128),
	@package_path_full    nvarchar(4000),
        @executable_name    nvarchar(4000),
        @executable_guid    nvarchar(38),
        @package_path       nvarchar(MAX),
        @execution_path     nvarchar(MAX),
        @start_time         datetimeoffset(7),
        @end_time           datetimeoffset(7),
        @execution_hierarchy hierarchyid = null,
        @execution_duration  int,
        @execution_result    smallint,
        @execution_value     sql_variant
AS
SET NOCOUNT ON
               
    DECLARE @executable_id bigint

    
    IF [internal].[check_permission] 
    (
        4,
        @operation_id,
        2
    ) = 0
    BEGIN
        RAISERROR(27143, 16, 5, @operation_id) WITH NOWAIT;
        RETURN 1;      
    END


    SELECT @executable_id = [executable_id] FROM internal.executables
        WHERE project_id = @project_id AND project_version_lsn = @version_id
        AND package_name = @package_name AND executable_name = @executable_name
        AND executable_guid = @executable_guid AND package_path = @package_path
        
    IF @executable_id IS NULL
    BEGIN
    
        INSERT INTO [internal].[executables]
           ([project_id],
           [project_version_lsn],
           [package_name],
	   [package_location_type],
	   [package_path_full],
           [executable_name],
           [executable_guid],
           [package_path])
        VALUES
           (
             @project_id,
             @version_id,
             @package_name,
             @package_location_type,
	     @package_path_full,
             @executable_name,
             @executable_guid,
             @package_path
           )
        SET @executable_id = SCOPE_IDENTITY()      
    END 

    INSERT INTO [internal].[executable_statistics]
           ([execution_id],
           [executable_id],
           [execution_path],
           [start_time],
           [end_time],
           [execution_hierarchy],
           [execution_duration],
           [execution_result],
           [execution_value])
     VALUES
           (
               @operation_id,
               @executable_id,
               @execution_path,
               @start_time,
               @end_time,
               null,
               @execution_duration,
               @execution_result,
               @execution_value
           )

    RETURN 0
GO
GRANT EXECUTE ON  [internal].[append_executable_statistics] TO [public]
GO
