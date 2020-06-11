IF OBJECT_ID('dbo.new_sequence') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.new_sequence
    IF OBJECT_ID('dbo.new_sequence') IS NOT NULL
        PRINT '<<< FAILED DROPPING PROCEDURE dbo.new_sequence >>>'
    ELSE
        PRINT '<<< DROPPED PROCEDURE dbo.new_sequence >>>'
END
go
create procedure new_sequence @SequenceName varchar(24)
as

declare @Direction smallint

begin transaction
    SELECT @Direction = 1

    if (@SequenceName = 'profile') SELECT @Direction = -1

    UPDATE sequence SET last_sequence = last_sequence + @Direction 
    WHERE sequence_name = @SequenceName
    if @@rowcount=1
    begin
        declare @NextSequence integer
        SELECT max(last_sequence) FROM sequence 
        WHERE sequence_name = @SequenceName
    end
commit transaction
 
go
GRANT EXECUTE ON dbo.new_sequence TO web
go
IF OBJECT_ID('dbo.new_sequence') IS NOT NULL
   PRINT '<<< CREATED PROCEDURE dbo.new_sequence >>>'
ELSE
   PRINT '<<< FAILED CREATING PROCEDURE dbo.new_sequence >>>'
go
EXEC sp_procxmode 'dbo.new_sequence','unchained'
go
