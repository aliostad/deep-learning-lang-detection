USE [Innova]
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GroupUserAccess]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[GroupUserAccess]
	(
		GroupID				INT NOT NULL,
		UserID				INT NOT NULL,
		IsReadOnly			BIT NOT NULL CONSTRAINT DF_GroupUserAccess_IsReadOnly DEFAULT 0,
		CONSTRAINT [PK_GroupUserAccess] PRIMARY KEY CLUSTERED( GroupID, UserID ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE [name] = N'IsReadOnly' AND [object_id] = OBJECT_ID(N'[dbo].[GroupUserAccess]'))
BEGIN
    ALTER TABLE [dbo].[GroupUserAccess] ADD [IsReadOnly] BIT NOT NULL CONSTRAINT DF_GroupUserAccess_IsReadOnly DEFAULT 0
END
