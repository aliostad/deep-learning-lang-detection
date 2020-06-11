CREATE TABLE [dbo].[Files] (
    [Id]          INT             IDENTITY (1, 1) NOT NULL,
    [Filename]    VARCHAR (200)   NOT NULL,
    [ContentType] VARCHAR (200)   NOT NULL,
    [IsImage]     BIT             NOT NULL,
    [Append]      BIT             NOT NULL,
    [Contents]    VARBINARY (MAX) NOT NULL,
    [Title]       VARCHAR (100)   NULL,
    [Caption]     VARCHAR (200)   NULL,
    [ProjectId]   INT             NOT NULL,
    [DateCreated] DATETIME        NOT NULL,
    [LastUpdate]  DATETIME        NOT NULL
);







