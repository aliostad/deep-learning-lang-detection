SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE PROCEDURE [internal].[append_message_context]
        @operation_id       bigint,                             
        @event_message_id   bigint,                             
        @context_depth      int,                                
        @package_path       nvarchar(MAX),
        @context_type       smallint,
        @context_source_name nvarchar(MAX),
        @context_source_id   nvarchar(38),
        @property_name       nvarchar(4000),
        @property_value      sql_variant
AS
SET NOCOUNT ON

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

    INSERT INTO [internal].[event_message_context]
           ([operation_id],
           [event_message_id],
           [context_depth],
           [package_path],
           [context_type],
           [context_source_name],
           [context_source_id],
           [property_name],
           [property_value])
     VALUES(
              @operation_id,
              @event_message_id,
              @context_depth,
              @package_path,
              @context_type,
              @context_source_name,
              @context_source_id,
              @property_name,
              @property_value 
           )
    RETURN 0
GO
GRANT EXECUTE ON  [internal].[append_message_context] TO [public]
GO
