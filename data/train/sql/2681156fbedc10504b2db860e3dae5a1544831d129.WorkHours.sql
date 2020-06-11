CREATE TABLE WorkHours (
        EmployeeID INT IDENTITY,
        OnDate DATETIME,
        Task NVARCHAR(50),
        HoursWorked INT,
        Comments text
        CONSTRAINT PK_EmployeeID PRIMARY KEY (EmployeeID)
        CONSTRAINT FK_EmployeeID FOREIGN KEY (EmployeeID)
                REFERENCES Employees(EmployeeID)
)
 
INSERT INTO WorkHours
SELECT
        GETDATE() AS OnDate,
        'sometask1' AS Task,
        6 AS HoursWorked,
        'no comment' AS Comments
 
UPDATE WorkHours
        SET Task = 'no current task'
        WHERE Task = 'sometask1'
 
CREATE TRIGGER tr_Update ON dbo.WorkHours FOR UPDATE
AS
        BEGIN
                INSERT INTO dbo.WorkHoursLogs
                SELECT  i.EmployeeID AS NewEmployeeID,
                        i.OnDate AS NewOnDate,
                        i.Task AS NewTask,
                        i.HoursWorked AS NewHoursWorked,
                        i.Comments AS NewComments,
                        'UPDATE' AS Command
                FROM inserted i
        END
GO
 
CREATE TRIGGER tr_Update ON dbo.WorkHours FOR INSERT
AS
        BEGIN
                INSERT INTO dbo.WorkHoursLogs
                SELECT  i.EmployeeID AS NewEmployeeID,
                        i.OnDate AS NewOnDate,
                        i.Task AS NewTask,
                        i.HoursWorked AS NewHoursWorked,
                        i.Comments AS NewComments,
                        'INSERT' AS Command
                FROM inserted i
        END
GO
 
CREATE TRIGGER tr_Update ON dbo.WorkHours FOR DELETE
AS
        BEGIN
                INSERT INTO dbo.WorkHoursLogs
                SELECT  i.EmployeeID AS NewEmployeeID,
                        i.OnDate AS NewOnDate,
                        i.Task AS NewTask,
                        i.HoursWorked AS NewHoursWorked,
                        i.Comments AS NewComments,
                        'DELETE' AS Command
                FROM deleted i
        END
GO