CREATE TABLE [dbo].[TblFlash] (
  [FlashID] [int] IDENTITY,
  [FlashCategoryID] [int] NULL,
  [FlashName] [nvarchar](100) NULL,
  [FlashLocation] [nvarchar](255) NULL,
  [FlashDescription] [ntext] NULL,
  [FlashSize] [int] NULL,
  [FlashFileName] [nvarchar](255) NULL,
  CONSTRAINT [aaaaaTblFlash_PK] PRIMARY KEY NONCLUSTERED ([FlashID]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

CREATE INDEX [TblLibraryCategoryTblFlash]
  ON [dbo].[TblFlash] ([FlashCategoryID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[TblFlash] WITH NOCHECK
  ADD CONSTRAINT [TblFlash_FK00] FOREIGN KEY ([FlashCategoryID]) REFERENCES [dbo].[TblLibraryCategory] ([LibraryCategoryID])
GO