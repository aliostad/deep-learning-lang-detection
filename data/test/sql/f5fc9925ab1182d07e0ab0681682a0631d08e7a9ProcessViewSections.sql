CREATE TABLE [dbo].[ProcessViewSections] (
    [Id]                        INT            IDENTITY (1, 1) NOT NULL,
    [ProcessViewId]				INT            NOT NULL,
    [Guid]						UNIQUEIDENTIFIER  NULL,
	[TemplateSectionGuid]       UNIQUEIDENTIFIER  NULL,
    [Name]                      NVARCHAR (500) NULL
    CONSTRAINT [FK_ProcessViewSections_ProcesseViews] FOREIGN KEY ([ProcessViewId]) REFERENCES [dbo].[ProcessViews] ([Id]) ON DELETE CASCADE, 
    CONSTRAINT [PK_ProcessViewSections] PRIMARY KEY ([Id])
);


GO
CREATE NONCLUSTERED INDEX [NCI_ProcessViewSections_ProcessViewId]
    ON [dbo].[ProcessViewSections]([ProcessViewId] ASC);

