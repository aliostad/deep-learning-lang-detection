CREATE TABLE WorkHours(
id int IDENTITY,
EmployeeId int NOT NULL,
ReportDate date NOT NULL,
Task nvarchar(255) NOT NULL,
ExecutionHours float NOT NULL,
Comments nvarchar(255) NOT NULL,
CONSTRAINT PK_WorkHours PRIMARY KEY(id),
CONSTRAINT FK_WorkHours_Employees FOREIGN KEY (EmployeeId) REFERENCES Employees(EmployeeId),
CONSTRAINT ExecutionHoursLength CHECK(DATALENGTH(ExecutionHours) >= 0)
)

insert into WorkHours
values(1,GETDATE(),'Check All Data', 3, 'urgent')
insert into WorkHours
values(1,GETDATE(),'Check All', 1, 'very urgent')
insert into WorkHours
values(2, GETDATE() - 3,'Check Market', 48, 'BG Market check')
insert into WorkHours
values(3, GETDATE() - 2,'Check All Stuff Reports', 8, 'confidential')

update WorkHours set ExecutionHours = 4
where EmployeeId = 3

delete from WorkHours
where EmployeeId = 1 and ExecutionHours = 1

CREATE TABLE WorkHoursLogs(
id int IDENTITY,
OldEmployeeId int NULL,
OldReportDate date NULL,
OldTask nvarchar(255) NULL,
OldExecutionHours float NULL,
OldComments nvarchar(255) NULL,
NewEmployeeId int NULL,
NewReportDate date NULL,
NewTask nvarchar(255) NULL,
NewExecutionHours float NULL,
NewComments nvarchar(255) NULL,
Command nvarchar(10) NULL,
CONSTRAINT PK_WorkHoursLogs PRIMARY KEY(id),
CONSTRAINT FK_WorkHoursLogs_OldEmployees FOREIGN KEY (OldEmployeeId) REFERENCES Employees(EmployeeId),
CONSTRAINT FK_WorkHoursLogs_NewEmployees FOREIGN KEY (NewEmployeeId) REFERENCES Employees(EmployeeId),
CONSTRAINT OldExecutionHoursLength CHECK(DATALENGTH(OldExecutionHours) >= 0),
CONSTRAINT NEwExecutionHoursLength CHECK(DATALENGTH(NewExecutionHours) >= 0)
)


IF OBJECT_ID ('WorkHoursAfterInsert','TR') IS NOT NULL
   DROP TRIGGER WorkHoursAfterInsert;
GO

CREATE TRIGGER WorkHoursAfterInsert ON dbo.WorkHours AFTER INSERT AS
	BEGIN
		DECLARE
			@NewEmployeeId int,
			@NewReportDate date,
			@NewTask nvarchar(255),
			@NewExecutionHours float,
			@NewComments nvarchar(255);
		SELECT
			@NewEmployeeId = inserted.EmployeeId,
			@NewReportDate = inserted.ReportDate,
			@NewTask = inserted.Task,
			@NewExecutionHours = inserted.ExecutionHours,
			@NewComments = inserted.Comments
		FROM inserted;

		INSERT INTO WorkHoursLogs(NewEmployeeId, NewReportDate, NewTask, NewExecutionHours, NewComments, Command)
		VALUES (@NewEmployeeId, @NewReportDate, @NewTask, @NewExecutionHours, @NewComments, 'INSERT');
	END
GO


IF OBJECT_ID ('WorkHoursAfterUpdate','TR') IS NOT NULL
   DROP TRIGGER WorkHoursAfterUpdate;
GO

CREATE TRIGGER WorkHoursAfterUpdate ON dbo.WorkHours AFTER UPDATE AS
	BEGIN
		DECLARE
			@NewEmployeeId int,
			@NewReportDate date,
			@NewTask nvarchar(255),
			@NewExecutionHours float,
			@NewComments nvarchar(255),
			@OldEmployeeId int,
			@OldReportDate date,
			@OldTask nvarchar(255),
			@OldExecutionHours float,
			@OldComments nvarchar(255);
		SELECT
			@NewEmployeeId = inserted.EmployeeId,
			@NewReportDate = inserted.ReportDate,
			@NewTask = inserted.Task,
			@NewExecutionHours = inserted.ExecutionHours,
			@NewComments = inserted.Comments
		FROM inserted;

		SELECT
			@OldEmployeeId = deleted.EmployeeId,
			@OldReportDate = deleted.ReportDate,
			@OldTask = deleted.Task,
			@OldExecutionHours = deleted.ExecutionHours,
			@OldComments = deleted.Comments
		FROM deleted;

		INSERT INTO WorkHoursLogs(OldEmployeeId, OldReportDate, OldTask, OldExecutionHours, OldComments, 
								  NewEmployeeId, NewReportDate, NewTask, NewExecutionHours, NewComments, Command)
		VALUES (@OldEmployeeId, @OldReportDate, @OldTask, @OldExecutionHours, @OldComments, 
				@NewEmployeeId, @NewReportDate, @NewTask, @NewExecutionHours, @NewComments, 'UPDATE');
	END
GO


IF OBJECT_ID ('WorkHoursAfterDelete','TR') IS NOT NULL
   DROP TRIGGER WorkHoursAfterDelete;
GO

CREATE TRIGGER WorkHoursAfterDelete ON dbo.WorkHours AFTER DELETE AS
	BEGIN
		DECLARE
			@NewEmployeeId int,
			@NewReportDate date,
			@NewTask nvarchar(255),
			@NewExecutionHours float,
			@NewComments nvarchar(255),
			@OldEmployeeId int,
			@OldReportDate date,
			@OldTask nvarchar(255),
			@OldExecutionHours float,
			@OldComments nvarchar(255);
		SELECT
			@NewEmployeeId = inserted.EmployeeId,
			@NewReportDate = inserted.ReportDate,
			@NewTask = inserted.Task,
			@NewExecutionHours = inserted.ExecutionHours,
			@NewComments = inserted.Comments
		FROM inserted;

		SELECT
			@OldEmployeeId = deleted.EmployeeId,
			@OldReportDate = deleted.ReportDate,
			@OldTask = deleted.Task,
			@OldExecutionHours = deleted.ExecutionHours,
			@OldComments = deleted.Comments
		FROM deleted;

		INSERT INTO WorkHoursLogs(OldEmployeeId, OldReportDate, OldTask, OldExecutionHours, OldComments, 
								  NewEmployeeId, NewReportDate, NewTask, NewExecutionHours, NewComments, Command)
		VALUES (@OldEmployeeId, @OldReportDate, @OldTask, @OldExecutionHours, @OldComments, 
				@NewEmployeeId, @NewReportDate, @NewTask, @NewExecutionHours, @NewComments, 'DELETE');
	END
GO
