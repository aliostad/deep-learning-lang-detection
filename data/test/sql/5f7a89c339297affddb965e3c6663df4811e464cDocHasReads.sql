print 'DocHasReads'
GO 

CREATE TABLE DocHasReads
(
    DocHasReadId				INT IDENTITY (1, 1) NOT NULL,
	DocId						INT NOT NULL,
	UnitId						INT NOT NULL,
	HasRead						BIT,
    ModifyDate					DATETIME NOT NULL,
	ModifyUserId				INT NOT NULL,
    Version						ROWVERSION     NOT NULL,
    CONSTRAINT PK_DocHasReads PRIMARY KEY CLUSTERED (DocHasReadId),
	CONSTRAINT [FK_DocHasReads_Docs] FOREIGN KEY ([DocId]) REFERENCES [dbo].[Docs] ([DocId]),
	CONSTRAINT [FK_DocHasReads_Units] FOREIGN KEY ([UnitId]) REFERENCES [dbo].[Units] ([UnitId]),
	CONSTRAINT [FK_DocHasReads_Users] FOREIGN KEY ([ModifyUserId]) REFERENCES [dbo].[Users] ([UserId]),
)
GO 

exec spDescTable  N'DocHasReads', N'Отбелязване на документи като прочетени'
exec spDescColumn N'DocHasReads', N'DocHasReadId', N'Уникален системно генериран идентификатор.'