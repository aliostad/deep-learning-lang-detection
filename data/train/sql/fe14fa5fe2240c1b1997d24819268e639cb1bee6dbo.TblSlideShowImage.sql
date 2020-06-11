CREATE TABLE [dbo].[TblSlideShowImage] (
  [SlideShowID] [int] NULL CONSTRAINT [DF__TblSlideS__Slide__025D5595] DEFAULT (0),
  [SlideShowImageID] [int] NULL CONSTRAINT [DF__TblSlideS__Slide__035179CE] DEFAULT (0),
  [SlideShowImageOrder] [int] NULL CONSTRAINT [DF__TblSlideS__Slide__04459E07] DEFAULT (0)
)
ON [PRIMARY]
GO

CREATE INDEX [TblSlideShowTblSlideShowImage]
  ON [dbo].[TblSlideShowImage] ([SlideShowID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [TourID]
  ON [dbo].[TblSlideShowImage] ([SlideShowID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

ALTER TABLE [dbo].[TblSlideShowImage] WITH NOCHECK
  ADD CONSTRAINT [TblSlideShowImage_FK00] FOREIGN KEY ([SlideShowID]) REFERENCES [dbo].[TblSlideShow] ([SlideShowID]) ON DELETE CASCADE
GO