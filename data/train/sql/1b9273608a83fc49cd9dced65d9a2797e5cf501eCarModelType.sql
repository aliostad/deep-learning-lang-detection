CREATE TABLE [app].[CarModelType] (
    [carModelTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [carMakeTypeId]  INT            NULL,
    [name]           NVARCHAR (50)  NULL,
    [description]    NVARCHAR (MAX) NULL,
    [created]        DATETIME       CONSTRAINT [DF__ModelType__creat__13F1F5EB] DEFAULT (getdate()) NOT NULL,
    [modified]       DATETIME       CONSTRAINT [DF__ModelType__modif__14E61A24] DEFAULT (getdate()) NOT NULL,
    [createdBy]      INT            NULL,
    [modifiedBy]     INT            NULL,
    [isActive]       BIT            CONSTRAINT [DF__ModelType__isAct__15DA3E5D] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK__ModelTyp__9244B3E7C827E8F9] PRIMARY KEY CLUSTERED ([carModelTypeId] ASC),
    CONSTRAINT [FK_ModelType_MakeType] FOREIGN KEY ([carMakeTypeId]) REFERENCES [app].[CarMakeType] ([carMakeTypeId]) ON DELETE CASCADE ON UPDATE CASCADE
);



