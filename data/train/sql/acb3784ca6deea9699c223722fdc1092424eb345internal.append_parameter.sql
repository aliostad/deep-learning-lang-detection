SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [internal].[append_parameter]
        @project_id             bigint,
        @object_version_lsn     bigint,
        @object_type smallint,
        @object_name nvarchar(260),
        @parameter_name nvarchar(128),
        @parameter_data_type nvarchar(128),
        @required bit,
        @sensitive bit,
        @description nvarchar (1024) = NULL,
        @design_default_value sql_variant = NULL,
        @value_set bit  
AS
    SET NOCOUNT ON
    
    DECLARE @result bit

    IF (@project_id IS NULL  OR @object_version_lsn IS NULL OR 
        @object_type IS NULL OR @object_name IS NULL OR
        @parameter_name IS NULL OR @parameter_data_type IS NULL OR
        @required  IS NULL OR @sensitive IS NULL )
    BEGIN
        RAISERROR(27138, 16 , 6) WITH NOWAIT 
        RETURN 1     
    END
    
    IF (@project_id <= 0)
    BEGIN
        RAISERROR(27101, 16 , 10, N'project_id') WITH NOWAIT
        RETURN 1 
    END

    IF (@object_version_lsn <= 0)
    BEGIN
        RAISERROR(27101, 16 , 10, N'object_version_lsn') WITH NOWAIT
        RETURN 1  
    END
    
    IF (@parameter_data_type NOT IN 
            (SELECT [ssis_data_type] FROM [internal].[data_type_mapping]))   
    BEGIN
        RAISERROR(27101, 16 , 10, N'parameters_data_type') WITH NOWAIT
        RETURN 1
    END                                   
        
    IF NOT EXISTS (SELECT [object_version_lsn] FROM [internal].[object_versions] 
                WHERE [object_version_lsn] = @object_version_lsn AND [object_type] = 20
                AND [object_id] = @project_id AND [object_status] = 'D')
    BEGIN
        RAISERROR(27194 , 16 , 1) WITH NOWAIT
        RETURN 1         
    END
    
    SET @result = [internal].[check_permission] 
    (
        2,
        @project_id,
        2
    ) 
    
    IF @result = 0        
    BEGIN
        RAISERROR(27194 , 16 , 1) WITH NOWAIT
        RETURN 1        
    END
   
    
    INSERT INTO [internal].[object_parameters]
       ([project_id]
       ,[project_version_lsn]
       ,[object_type]
       ,[object_name]
       ,[parameter_name]
       ,[parameter_data_type]
       ,[required]
       ,[sensitive]
       ,[description]
       ,[design_default_value]
       ,[value_type]
       ,[value_set]
       ,[validation_status])
    VALUES (@project_id,
           @object_version_lsn,
           @object_type ,
           @object_name,
           @parameter_name,
           @parameter_data_type,
           @required,
           @sensitive,
           @description,
           @design_default_value,
           'V',                 
           @value_set,
           'N')                  
    RETURN 0   
        
GO
GRANT EXECUTE ON  [internal].[append_parameter] TO [public]
GO
