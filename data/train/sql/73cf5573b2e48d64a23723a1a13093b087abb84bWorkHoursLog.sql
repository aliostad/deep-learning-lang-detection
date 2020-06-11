CREATE TABLE WorkHoursLogs
(
ID int IDENTITY PRIMARY KEY,
WorkHoursOldId int,
Command varchar(20),
TimeOfChange smalldatetime,
OldEmployeeId int,
OldDate smalldatetime,
OldTask varchar(100),
OldHours float,
OldComments varchar(MAX),
WorkHoursNewId int,
NewEmployeeId int,
NewDate smalldatetime,
NewTask varchar(100),
NewHours float,
NewComments varchar(MAX)
CONSTRAINT FK_WorkHoursLogs_Employees_Old
	FOREIGN KEY(OldEmployeeId) REFERENCES Employees(EmployeeID),
	FOREIGN KEY(NewEmployeeId) REFERENCES Employees(EmployeeID)
)