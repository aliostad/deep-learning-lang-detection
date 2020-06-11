CREATE TABLE [processRegions].[regionNew]
(
[regionNewId] [dbo].[primaryKey] NOT NULL IDENTITY(1, 1),
[region] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[latitude] [decimal] (9, 7) NOT NULL,
[longitude] [decimal] (10, 7) NOT NULL
) ON [PRIMARY]
CREATE CLUSTERED INDEX [ix_regionNew] ON [processRegions].[regionNew] ([region], [latitude], [longitude]) ON [PRIMARY]

GO
ALTER TABLE [processRegions].[regionNew] ADD CONSTRAINT [pk_regionNew] PRIMARY KEY NONCLUSTERED  ([regionNewId]) ON [PRIMARY]
GO
