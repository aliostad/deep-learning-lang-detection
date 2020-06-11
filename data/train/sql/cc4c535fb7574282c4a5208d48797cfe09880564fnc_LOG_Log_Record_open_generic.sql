-- DROP FUNCTION [dbo].[fnc_LOG_Log_Record_open_generic]
ALTER FUNCTION [dbo].[fnc_LOG_Log_Record_open_generic](
	@IDType_search_ int, 
	@IDUser_search_ bigint, 
	@IDError_search_ int, 
	@Stamp_begin_search_ datetime, 
	@Stamp_end_search_ datetime, 
	@Read_search_ bit, 
	@IFApplication_search_ int
)
RETURNS TABLE
AS
RETURN
	SELECT
		"IDLog"
	FROM "LOG_Log"
			WHERE
				(
					(@IFApplication_search_ is null)
					or
					(@IFApplication_search_ <= 0)
					or
					(@IFApplication_search_ = "IFApplication")
				)
				and
				(
					(@IDType_search_ is null)
					or
					(@IDType_search_ <= 0)
					or
					(@IDType_search_ = "IFType") 
				)
				and
				(
					(@IDUser_search_ is null)
					or
					(@IDUser_search_ <= 0)
					or
					(@IDUser_search_ = "IFUser")
				)
				and
				(
					(@IDError_search_ is null)
					or
					(@IDError_search_ <= 0)
					or
					(@IDError_search_ = "IFError")
				)
				and
				(
					(@Stamp_begin_search_ is null)
					or
					(@Stamp_end_search_ is null)
					or
					(@Stamp_begin_search_ < CONVERT(DATETIME, '2010-01-01 00:00:00', 120))
					or
					(@Stamp_end_search_ < CONVERT(DATETIME, '2010-01-01 00:00:00', 120))
					or
					("Stamp" between @Stamp_begin_search_ and @Stamp_end_search_)
				)
				and
				(
					(@Read_search_ is null)
					or
					(
						(@Read_search_ = 1)
						and
						(not "IFUser__read" is null)
					)
					or
					(
						(@Read_search_ = 0)
						and
						("IFUser__read" is null)
					)
				)
GO

select *
from "fnc_LOG_Log_Record_open_generic"(
	-1, -- "IDType_search_" integer, 
	-1, -- "IDUser_search_" bigint, 
	-1, -- "IDError_search_" integer, 

	--date '1900-01-01', 
	--date '1900-01-01', 
	--null, 
	--null, 
	--date '2010-01-01', 
	--date '2010-01-01', 
	CONVERT(DATETIME, '2010-01-01 00:00:00', 120), 
	CONVERT(DATETIME, '2010-01-01 00:00:00', 120), 

	0, -- "Read_search_" boolean

	null -- @IFApplication_search_
);
