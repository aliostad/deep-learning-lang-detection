CREATE TABLE [dbo].[Exemplar] (
    [Signature] VARCHAR (255) NOT NULL,
    [ISBN]      BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([Signature] ASC),
    FOREIGN KEY ([ISBN]) REFERENCES [dbo].[Book] ([ISBN])
);


GO
CREATE TRIGGER [createSignature]
	ON [dbo].[Exemplar]
	INSTEAD OF INSERT
	AS
	BEGIN
		SET NOCOUNT ON;

		-- needed vars
		DECLARE @subject_short VARCHAR(5);
		DECLARE @author_first_char VARCHAR(1);
		DECLARE @Signature VARCHAR(255);
		DECLARE @ISBN BIGINT;

		-- set ISBN form canceld INSERT
		SET @ISBN = (SELECT ISBN FROM inserted);

		-- get first 5 chars from subject
		SET @subject_short = (
			SELECT SUBSTRING([Subject].name,1,4) 
			FROM Book 
			LEFT JOIN [Subject] ON Book.Subject_Id = [Subject].Subject_Id 
			WHERE Book.ISBN = @ISBN
		);

		-- delete whitespaces
		SET @subject_short = REPLACE(@subject_short,' ','');

		-- append '0's until we have still 5 chars
		WHILE(LEN(@subject_short) < 5)
		BEGIN
			SET @subject_short = CONCAT(@subject_short,'0');
		END

		-- get first chars form author
		SET @author_first_char = (
			SELECT TOP 1 SUBSTRING(Author.last_name,1,1)
			FROM Book
			LEFT JOIN Book_Author ON Book_Author.ISBN = Book.ISBN
			LEFT JOIN Author ON Book_Author.Author_Id = Author.Author_Id
			WHERE Book.ISBN = @ISBN
		);

		-- concat signature
		SET @Signature = CONCAT(@author_first_char,@subject_short);

		-- check if signature already exists
		WHILE (EXISTS(SELECT [Signature] FROM Exemplar WHERE [Signature] = @Signature))
		BEGIN			
			-- check if there is already a identity attached
			IF(LEN(@Signature) < 7)
			BEGIN
				-- attche 1 as identity for making this signature unique
				SET @Signature = CONCAT(@Signature,'1'); 
			END
			ELSE
				-- increment attached indentity making this signature unique 
				SET @Signature = CONCAT(SUBSTRING(@Signature,1,6),CAST(SUBSTRING(@Signature,6,LEN(@Signature)-5) AS INT) + 1); 
		END
		
		-- insert exemplar with ISBN and Signature
		INSERT INTO Exemplar (ISBN,[Signature]) VALUES (@ISBN, @Signature);
	END