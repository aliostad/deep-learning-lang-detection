CREATE TABLE [Content].[ContainerViews] (
    [ContainerViewID]       INT IDENTITY (1, 1) NOT NULL,
    [ViewID]                INT NOT NULL,
    [ContainerID]           INT NOT NULL,
    [ParentContainerViewID] INT NULL,
    CONSTRAINT [PK_ContainerViews] PRIMARY KEY CLUSTERED ([ContainerViewID] ASC),
    CONSTRAINT [FK_ContainerViews_Container] FOREIGN KEY ([ContainerID]) REFERENCES [Content].[Container] ([ContainerID]),
    CONSTRAINT [FK_ContainerViews_ContainerView] FOREIGN KEY ([ViewID]) REFERENCES [Content].[ContainerView] ([ViewID]),
    CONSTRAINT [FK_ContainerViews_ContainerViews] FOREIGN KEY ([ParentContainerViewID]) REFERENCES [Content].[ContainerViews] ([ContainerViewID])
);

