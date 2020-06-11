CREATE TABLE [cloudcoremodel].[FlowModel] (
    [FlowModelId]         INT              IDENTITY (1, 1) NOT NULL,
    [FlowGuid]            UNIQUEIDENTIFIER NOT NULL,
    [ProcessRevisionId]   INT              NOT NULL,
    [FromActivityModelId] INT              NOT NULL,
    [Outcome]             VARCHAR (50)     DEFAULT ('-') NOT NULL,
    [ToActivityModelId]   INT              NOT NULL,
    [OptimalFlow]         BIT              DEFAULT ((0)) NOT NULL,
    [NegativeFlow]        BIT              DEFAULT ((0)) NOT NULL,
    [Storyline]           VARCHAR (200)    NOT NULL,
    CONSTRAINT [PK_FlowModel] PRIMARY KEY CLUSTERED ([FlowModelId] ASC),
    CONSTRAINT [FK_FlowModel_ActivityModel_From] FOREIGN KEY ([FromActivityModelId]) REFERENCES [cloudcoremodel].[ActivityModel] ([ActivityModelId]),
    CONSTRAINT [FK_FlowModel_ActivityModel_To] FOREIGN KEY ([ToActivityModelId]) REFERENCES [cloudcoremodel].[ActivityModel] ([ActivityModelId]),
    CONSTRAINT [FK_FlowModel_ProcessModel] FOREIGN KEY ([ProcessRevisionId]) REFERENCES [cloudcoremodel].[ProcessRevision] ([ProcessRevisionId]),
    CONSTRAINT [UNQ_FlowModel_Flow] UNIQUE NONCLUSTERED ([FromActivityModelId] ASC, [Outcome] ASC)
);

