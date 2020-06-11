SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE PROCEDURE [internal].[append_event_message]
        @operation_id       bigint,                             
        @message_type       int,                                
        @message_time         datetimeoffset,                     
        @message_source       smallint,                           
        @message              nvarchar(max),                      
        @extended_info_id     bigint = NULL,
        @package_name         nvarchar(260),
        @package_location_type nvarchar(128),
	@package_path_full    nvarchar(4000),
        @event_name           nvarchar(1024),
        @message_source_name  nvarchar(4000),
        @message_source_id    nvarchar(38),
        @subcomponent_name    nvarchar(4000),
        @package_path         nvarchar(MAX),
        @execution_path       nvarchar(MAX),
        @thread_id            int,
        @message_code         int,
        @event_message_id     bigint output
AS
SET NOCOUNT ON

    DECLARE @operation_message_id   bigint    

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
    
    INSERT INTO [internal].[operation_messages] 
           ([operation_id], 
            [message_type], 
            [message_time],
            [message_source_type], 
            [message], 
            [extended_info_id])
        VALUES(
            @operation_id,  
            @message_type,
            @message_time,
            @message_source,
            @message,
            @extended_info_id)
            
    SET @operation_message_id = SCOPE_IDENTITY()

    INSERT INTO [internal].[event_messages]
           ([operation_id],
           [event_message_id],
           [package_name],
	   [package_location_type],
	   [package_path_full],
           [event_name],
           [message_source_name],
           [message_source_id],
           [subcomponent_name],
           [package_path],
           [execution_path],
           [threadID],
           [message_code])
     VALUES
           (
           @operation_id,
           @operation_message_id,
           @package_name,
           @package_location_type,
           @package_path_full,
           @event_name,
           @message_source_name,
           @message_source_id,
           @subcomponent_name,
           @package_path,
           @execution_path,
           @thread_id,
           @message_code
           )
    SET @event_message_id =  @operation_message_id
    RETURN 0
GO
GRANT EXECUTE ON  [internal].[append_event_message] TO [public]
GO
