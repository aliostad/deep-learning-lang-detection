if exists (
    select 1 
    from sysobjects 
    where type="P" 
    and name="TestDataDump" 
)
    drop procedure TestDataDump
go

/*
 * This procedure tests the behavior of Sybase with different kinds of
 * data types.
 */
create procedure TestDataDump (
    @chardata1 char(32),
    @chardata2 varchar(32),
    @chardata3 varchar(32),
    @chardata4 char(1),
    @tsdata1 timestamp,
    @numdata1 numeric,
    @numdata2 numeric,
    @numdata3 numeric,
    @chardata5 varchar(32),
    @chardata8 varchar(32),
    @tsdata2 timestamp,
    @numdata4 numeric,
    @chardata6 varchar(32) output,
    @intdata2 int output,
    @chardata7 varchar(32) output
) as
begin
    -- out params
    select @intdata2 = 0 -- id=15
    select @chardata6 = "1234567890" -- id=16
    select @chardata7 = "success" -- id=14
    -- resultset 1
    select @chardata6
    -- resultset 2
    select 4 as RequestTypeId
    return 0
end
go
