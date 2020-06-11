CREATE TABLE [dbo].[ProcessViewSectionSteps]
(
	[Id] INT IDENTITY (1, 1) NOT NULL,
    [SectionId] INT NOT NULL, 
    [StepName] NVARCHAR(100) NOT NULL, 
    [Order] INT NOT NULL
    CONSTRAINT [FK_ProcessViewSectionSteps_ProcessViewSections] FOREIGN KEY ([SectionId]) REFERENCES [dbo].[ProcessViewSections] ([Id]) ON DELETE CASCADE, 
    CONSTRAINT [PK_ProcessViewSectionSteps] PRIMARY KEY ([Id])
)

GO
CREATE NONCLUSTERED INDEX [NCI_ProcessViewSectionSteps_ProcessViewSections]
    ON [dbo].[ProcessViewSectionSteps]([SectionId] ASC);