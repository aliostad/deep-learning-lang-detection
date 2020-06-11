CREATE TABLE [dbo].[TblDocument_Flash] (
  [DocumentID] [int] NOT NULL CONSTRAINT [DF__TblDocume__Docum__278EDA44] DEFAULT (0),
  [FlashID] [int] NOT NULL CONSTRAINT [DF__TblDocume__Flash__2882FE7D] DEFAULT (0),
  CONSTRAINT [aaaaaTblDocument_Flash_PK] PRIMARY KEY NONCLUSTERED ([DocumentID], [FlashID]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO

CREATE INDEX [ASPFuncID]
  ON [dbo].[TblDocument_Flash] ([FlashID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [DocumentID]
  ON [dbo].[TblDocument_Flash] ([DocumentID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [TblDocumentTblDocument_Flash]
  ON [dbo].[TblDocument_Flash] ([DocumentID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [TblFlashTblDocument_Flash]
  ON [dbo].[TblDocument_Flash] ([FlashID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[TblDocument_Flash] WITH NOCHECK
  ADD CONSTRAINT [TblDocument_Flash_FK00] FOREIGN KEY ([DocumentID]) REFERENCES [dbo].[TblDocument] ([DocumentID]) ON DELETE CASCADE
GO

ALTER TABLE [dbo].[TblDocument_Flash] WITH NOCHECK
  ADD CONSTRAINT [TblDocument_Flash_FK01] FOREIGN KEY ([FlashID]) REFERENCES [dbo].[TblFlash] ([FlashID]) ON DELETE CASCADE
GO