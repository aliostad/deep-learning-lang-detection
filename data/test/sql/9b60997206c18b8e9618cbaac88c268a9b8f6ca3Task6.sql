IF OBJECT_ID ('LogChangeSumOnAccount','TR') IS NOT NULL
   DROP TRIGGER LogChangeSumOnAccount;
GO

CREATE TRIGGER LogChangeSumOnAccount ON dbo.Accounts AFTER UPDATE AS 
	BEGIN
		DECLARE
			@NewPersonId int,
			@OldPersonId int,
			@NewBalance float,
			@OldBalance float;
		SELECT
			@NewPersonId = inserted.Person_Id,
			@NewBalance = inserted.Balance
		FROM inserted;

		SELECT
			@OldPersonId = deleted.Person_Id,
			@OldBalance = deleted.Balance
		FROM deleted;

		INSERT INTO Logs(Account_id, OldSum, NewSum)
		VALUES (@NewPersonId, @OldBalance, @NewBalance);
	END
GO


update Accounts set Balance = 50 where Person_id = 3