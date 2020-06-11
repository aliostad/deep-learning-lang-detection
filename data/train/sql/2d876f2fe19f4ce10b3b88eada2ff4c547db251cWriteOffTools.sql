CREATE TABLE [dbo].[WriteOffTools] (
    [WriteOffToolID] INT      IDENTITY (1, 1) NOT NULL,
    [ToolID]         INT      NOT NULL,
    [WorkerID]       INT      NOT NULL,
    [Count]    INT      DEFAULT ((1)) NOT NULL,
    [WriteOffTime]   DATETIME DEFAULT (getdate()) NOT NULL,
    CONSTRAINT [PK_WriteOff] PRIMARY KEY CLUSTERED ([WriteOffToolID] ASC),
    CONSTRAINT [FK_WriteOffTools_Tools] FOREIGN KEY ([ToolID]) REFERENCES [dbo].[Tools] ([ToolID]),
    CONSTRAINT [FK_WriteOffTools_Workers] FOREIGN KEY ([WorkerID]) REFERENCES [dbo].[Workers] ([WorkerID])
);

