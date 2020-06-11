use SoftUni;
GO
/* TABLE CREATION */

CREATE TABLE WorkHoursLogs(
	Id INT NOT NULL IDENTITY,
	NewEmployeeID INT,
	NewDate DATETIME,
	NewHours FLOAT,
	NewTask NVARCHAR(512),
	NewComments NVARCHAR(512),
	OldEmployeeID INT,
	OldDate DATETIME,
	OldHours FLOAT,
	OldTask NVARCHAR(512),
	OldComments NVARCHAR(512),
	Command NVARCHAR(32),
	CONSTRAINT pk_WorkHoursLogsID PRIMARY KEY (Id),
	CONSTRAINT fk_OldEmployeeWorkHours FOREIGN KEY (OldEmployeeID)
	REFERENCES Employees(EmployeeID),
	CONSTRAINT fk_NewEmployeeWorkHours FOREIGN KEY (NewEmployeeID)
	REFERENCES Employees(EmployeeID)
)
GO

/* INSERT TRIGGER ON WorkHours TABLE */
CREATE TRIGGER tr_WorkHoursAfterInsert ON WorkHours 
FOR INSERT
AS
	INSERT INTO WorkHoursLogs
           (NewEmployeeID, NewDate, NewTask, NewHours, NewComments, Command) 
	SELECT EmployeeID, Date, Task, Hours, Comments, (SELECT 'INSERT' AS Command) FROM inserted;
GO

/* UPDATE TRIGGER ON WorkHours TABLE */
CREATE TRIGGER tr_WorkHoursAfterUpdate ON WorkHours 
FOR UPDATE
AS
	DECLARE @NewEmployeeID INT
	DECLARE @NewDate DATETIME
	DECLARE @NewHours FLOAT
	DECLARE @NewTask NVARCHAR(512)
	DECLARE @NewComments NVARCHAR(512)

	DECLARE @OldEmployeeID INT
	DECLARE @OldDate DATETIME
	DECLARE @OldHours FLOAT
	DECLARE @OldTask NVARCHAR(512)
	DECLARE @OldComments NVARCHAR(512)

	SELECT @NewEmployeeID = EmployeeID FROM inserted;	
	SELECT @NewDate = Date FROM inserted ;
	SELECT @NewHours = Hours FROM inserted;
	SELECT @NewTask = Task FROM inserted i;
	SELECT @NewComments = Comments FROM inserted;

	SELECT @OldEmployeeID = EmployeeID FROM deleted;	
	SELECT @OldDate = Date FROM deleted;
	SELECT @OldHours = Hours FROM deleted;
	SELECT @OldTask = Task FROM deleted;
	SELECT @OldComments = Comments FROM deleted;

	INSERT INTO WorkHoursLogs
           (NewEmployeeID, NewDate, NewHours, NewTask, NewComments,
		    OldEmployeeID, OldDate, OldHours, OldTask, OldComments, Command) 
	VALUES(@NewEmployeeID, @NewDate, @NewHours, @NewTask, @NewComments,
		    @OldEmployeeID, @OldDate, @OldHours, @OldTask, @OldComments, 'UPDATE')
GO

/* DELETE TRIGGER ON WorkHours TABLE */

CREATE TRIGGER tr_WorkHoursAfterDelete ON WorkHours 
FOR DELETE
AS
	INSERT INTO WorkHoursLogs
           (OldEmployeeID, OldDate, OldHours, OldTask, OldComments, Command) 
	SELECT EmployeeID, Date, Hours, Task, Comments, (SELECT 'DELETE' AS Command) FROM deleted;
GO