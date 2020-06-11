--Create another table – Logs(LogID, AccountID, OldSum, NewSum).
--Add a trigger to the Accounts table that enters a
--new entry into the Logs table every time the sum on an account changes

USE TelerikAcademy
GO
CREATE TABLE Logs(
	LogID INT IDENTITY PRIMARY KEY,
	AccountID INT FOREIGN KEY REFERENCES Accounts(AccountID),
	OldSum MONEY,
	NewSum MONEY,
)
GO
CREATE TRIGGER LogTransaction
ON Accounts AFTER UPDATE 
AS
	INSERT INTO Logs(AccountID,OldSum,NewSum)
	SELECT old.AccountId,old.Balance,new.Balance
	FROM deleted old
		INNER JOIN inserted new
			ON old.AccountId=new.AccountId;
GO
