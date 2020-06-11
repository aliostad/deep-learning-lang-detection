CREATE TABLE [PPM].[ExamModelItem] (
    [ExamModelItemID] INT IDENTITY (1, 1) NOT NULL,
    [ExamID]          INT NULL,
    [ExamModelID]     INT NULL,
    CONSTRAINT [PK_ExamModelItem] PRIMARY KEY CLUSTERED ([ExamModelItemID] ASC),
    CONSTRAINT [FK_ExamModelItem_Exam] FOREIGN KEY ([ExamID]) REFERENCES [PPM].[Exam] ([ExamID]) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT [FK_ExamModelItem_ExamModel] FOREIGN KEY ([ExamModelID]) REFERENCES [PPM].[ExamModel] ([ExamModelID]) ON DELETE CASCADE ON UPDATE CASCADE
);

