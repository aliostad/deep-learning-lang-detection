USE Airline; -- çðîáèòè ÁÄ ïîòî÷íîþ

GO

CREATE TRIGGER insertReservation 
ON tblReservation 
AFTER INSERT
AS
BEGIN
	INSERT INTO tblLog ([Date], OperationId, NewOperationId, Seat, NewSeat, FlightId, NewFlightId,
	CustomerId, NewCustomerId, Cost, NewCost, [Status], NewStatus)
	SELECT GETDATE(), Null, Id, Null, Seat, Null, FlightId,
	Null, CustomerId, Null, Cost, Null, [Status]
	FROM inserted;	
END;

GO

CREATE TRIGGER updateReservation 
ON tblReservation 
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @id INT, @seat VARCHAR(10), @fid INT, @cid INT, @cost NUMERIC(18,4), @status INT;
	SELECT 
	@id = Id,
	@seat = Seat,
	@fid = FlightId,
	@cid = CustomerId,
	@cost = Cost,
	@status = [Status]	
	FROM inserted;

	INSERT INTO tblLog ([Date], OperationId, NewOperationId, Seat, NewSeat, FlightId, NewFlightId,
	CustomerId, NewCustomerId, Cost, NewCost, [Status], NewStatus)
	SELECT GETDATE(),Id, Null, Seat, Null, FlightId,
	Null, CustomerId, Null, Cost, Null, [Status], Null
	FROM tblReservation WHERE Id = @id;	

	 UPDATE tblReservation 
	 SET 
	 Seat = @seat, 
	 FlightId = @fid, 
	 CustomerId = @cid, 
	 Cost = @cost, 
	 [Status] = @status
	 WHERE Id = @id;

	 UPDATE  tblLog 
	 SET 
	 NewOperationId = @id, 
	 NewSeat = @seat, 
	 NewFlightId = @fid,
	 NewCustomerId = @cid, 
	 NewCost = @cost, 
	 NewStatus = @status	
	 WHERE OperationId = @id;
END;


GO

CREATE TRIGGER deleteReservation 
ON tblReservation 
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @id INT, @seat VARCHAR(10), @fid INT, @cid INT, @cost NUMERIC(18,4), @status INT;
	SELECT 
	@id = Id,
	@seat = Seat,
	@fid = FlightId,
	@cid = CustomerId,
	@cost = Cost,
	@status = [Status]	
	FROM deleted;

	INSERT INTO tblLog (
	[Date], 
	OperationId, 
	NewOperationId, 
	Seat, NewSeat, 
	FlightId, 
	NewFlightId,
	CustomerId, 
	NewCustomerId, 
	Cost, 
	NewCost, 
	[Status], 
	NewStatus)	
	SELECT 
	GETDATE(),
	Id, 
	Null, 
	Seat, 
	Null, 
	FlightId,
	Null, 
	CustomerId, 
	Null, 
	Cost, 
	Null, 
	[Status], 
	Null
	FROM tblReservation WHERE Id = @id;		

	DELETE FROM tblReservation WHERE Id = @id;
END;

