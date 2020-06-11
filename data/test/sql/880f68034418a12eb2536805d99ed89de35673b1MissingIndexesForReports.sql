-- from http://www.ssistalk.com/2013/01/31/ssis-2012-catalog-indexing-recommendations/
-- via http://ssisreportingpack.codeplex.com/
USE [SSISDB]
GO

/****** Object:  Index [ncidxOperation_Id]    Script Date: 4/25/2012 3:45:32 PM ******/
CREATE NONCLUSTERED INDEX [ncidxOperation_Id] ON [internal].[event_messages]
(
	[operation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [ncidxExecution_id]    Script Date: 4/25/2012 3:47:53 PM ******/
CREATE NONCLUSTERED INDEX [ncidxExecution_id] ON [internal].[executable_statistics]
(
	[execution_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [NonClusteredIndex-20120425-124229]    Script Date: 4/25/2012 1:04:44 PM ******/
CREATE NONCLUSTERED INDEX [ncidxExecution_idSequence_id] ON [internal].[execution_component_phases]
(
	[execution_id] ASC,
	[sequence_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [ncidxOperation_id]    Script Date: 4/25/2012 3:46:42 PM ******/
CREATE NONCLUSTERED INDEX [ncidxOperation_id] ON [internal].[operation_messages]
(
	[operation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

/****** Object:  Index [ncidxEvent_message_id]    Script Date: 4/25/2012 3:49:06 PM ******/
CREATE NONCLUSTERED INDEX [ncidxEvent_message_id] ON [internal].[event_message_context]
(
	[event_message_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


/****** Object:  StoredProcedure [internal].[append_execution_component_phases]    Script Date: 4/25/2012 12:36:06 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



ALTER PROCEDURE [internal].[append_execution_component_phases]
        @execution_id                 bigint,                             
        @package_name                 nvarchar(260),
        @package_location_type        nvarchar(128),
        @package_path_full            nvarchar(4000),                            
        @task_name                    nvarchar(4000),                                
        @subcomponent_name            nvarchar(4000),
        @phase                        sysname,
        @is_start                     bit,
        @start_phase_time             datetimeoffset,
        @end_phase_time               datetimeoffset,
        @execution_path               nvarchar(MAX),
        @sequence_id                  int
AS
SET NOCOUNT ON

-- Phil Brammer - Added serializable isolation level to single-thread this proc call.
---- from http://www.ssistalk.com/2013/01/31/ssis-2012-catalog-indexing-recommendations/
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    IF [internal].[check_permission] 
    (
        4,
        @execution_id,
        2
    ) = 0
    BEGIN
        RAISERROR(27143, 16, 5, @execution_id) WITH NOWAIT;
        RETURN 1;      
    END
	
    DECLARE @phase_time datetimeoffset
    SET @phase_time = NULL;

    IF(@is_start = 'False')
    BEGIN
        UPDATE [internal].[execution_component_phases] 
        SET [phase_time] = @start_phase_time
        WHERE [sequence_id] = @sequence_id 
        AND [execution_id] = @execution_id;

        SET @phase_time = @end_phase_time;
    END

    INSERT INTO [internal].[execution_component_phases]
           ([execution_id],
            [package_name],
            [package_location_type],
            [package_path_full],
            [task_name],
            [subcomponent_name],
            [phase],
            [is_start],
            [phase_time], 
            [execution_path],
            [sequence_id])
     VALUES(
            @execution_id,                             
            @package_name, 
            @package_location_type,
            @package_path_full,                              
            @task_name,                                
            @subcomponent_name,
            @phase,
            @is_start,
            @phase_time,
            @execution_path,
	    @sequence_id
           )
    RETURN 0

GO