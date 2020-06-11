IF OBJECT_ID('[model].[deleteEvent]', 'P') IS NOT NULL
	DROP PROCEDURE [model].[deleteEvent]
GO

CREATE PROCEDURE [model].[deleteEvent]
	@eventID BIGINT
AS
declare @tbl varchar(255),@col varchar(255),@daysFrom int,@daysTo int
select @tbl=tbl,@col=col,@daysFrom=daysFrom,@daysTo=daysTo from model.Event where objID=@eventID
if @tbl is NULL 
	BEGIN
		RAISERROR('Òàêîãî ñîáûòèÿ íåò', 16, 1)
		RETURN
	END
if @daysFrom is not Null exec model.dropColumnUdp @tbl,@col,'daysFrom'
if @daysTo is not Null exec model.dropColumnUdp @tbl,@col,'daysTo'
exec model.dropColumnUdp @tbl,@col,'Message'