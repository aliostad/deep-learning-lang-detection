
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 04/06/2017 20:45:57
-- Generated from EDMX file: C:\Users\lubimovru\Dropbox\PrintStat\Core\EF\Model.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [PrintStat];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[FK_PrinterModelPrinter]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[PrinterSet] DROP CONSTRAINT [FK_PrinterModelPrinter];
GO
IF OBJECT_ID(N'[dbo].[FK_PrinterSupplySlot]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[SupplySlotSet] DROP CONSTRAINT [FK_PrinterSupplySlot];
GO
IF OBJECT_ID(N'[dbo].[FK_SupplyModelSupply]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[SupplySet] DROP CONSTRAINT [FK_SupplyModelSupply];
GO
IF OBJECT_ID(N'[dbo].[FK_PrinterModelSupplyModel_PrinterModel]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[PrinterModelSupplyModel] DROP CONSTRAINT [FK_PrinterModelSupplyModel_PrinterModel];
GO
IF OBJECT_ID(N'[dbo].[FK_PrinterModelSupplyModel_SupplyModel]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[PrinterModelSupplyModel] DROP CONSTRAINT [FK_PrinterModelSupplyModel_SupplyModel];
GO
IF OBJECT_ID(N'[dbo].[FK_SupplySlotSupply]', 'F') IS NOT NULL
    ALTER TABLE [dbo].[SupplySlotSet] DROP CONSTRAINT [FK_SupplySlotSupply];
GO

-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[PrinterSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PrinterSet];
GO
IF OBJECT_ID(N'[dbo].[SupplyModelSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SupplyModelSet];
GO
IF OBJECT_ID(N'[dbo].[PrinterModelSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PrinterModelSet];
GO
IF OBJECT_ID(N'[dbo].[HistorySet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[HistorySet];
GO
IF OBJECT_ID(N'[dbo].[SupplySlotSet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SupplySlotSet];
GO
IF OBJECT_ID(N'[dbo].[SupplySet]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SupplySet];
GO
IF OBJECT_ID(N'[dbo].[PrinterModelSupplyModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[PrinterModelSupplyModel];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'PrinterSet'
CREATE TABLE [dbo].[PrinterSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ModelId] int  NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [Location] nvarchar(max)  NOT NULL,
    [Owner] nvarchar(max)  NOT NULL,
    [Comment] nvarchar(max)  NULL
);
GO

-- Creating table 'SupplyModelSet'
CREATE TABLE [dbo].[SupplyModelSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [PartNumber] nvarchar(max)  NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [Comment] nvarchar(max)  NULL
);
GO

-- Creating table 'PrinterModelSet'
CREATE TABLE [dbo].[PrinterModelSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [SuppliesCount] int  NOT NULL,
    [Comment] nvarchar(max)  NULL
);
GO

-- Creating table 'HistorySet'
CREATE TABLE [dbo].[HistorySet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Date] datetime  NOT NULL,
    [Action] int  NOT NULL,
    [PrinterId] int  NOT NULL,
    [PrinterModel] nvarchar(max)  NOT NULL,
    [PrinterName] nvarchar(max)  NOT NULL,
    [PrinterLocation] nvarchar(max)  NOT NULL,
    [PrinterOwner] nvarchar(max)  NOT NULL,
    [PrinterComment] nvarchar(max)  NULL,
    [SupplyId] int  NOT NULL,
    [SupplyPartNumber] nvarchar(max)  NOT NULL,
    [SupplyName] nvarchar(max)  NOT NULL,
    [SupplyComment] nvarchar(max)  NULL
);
GO

-- Creating table 'SupplySlotSet'
CREATE TABLE [dbo].[SupplySlotSet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [PrinterId] int  NOT NULL,
    [SupplyId] int  NULL
);
GO

-- Creating table 'SupplySet'
CREATE TABLE [dbo].[SupplySet] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ModelId] int  NOT NULL,
    [Comment] nvarchar(max)  NULL
);
GO

-- Creating table 'PrinterModelSupplyModel'
CREATE TABLE [dbo].[PrinterModelSupplyModel] (
    [PrinterModels_Id] int  NOT NULL,
    [SupplyModels_Id] int  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'PrinterSet'
ALTER TABLE [dbo].[PrinterSet]
ADD CONSTRAINT [PK_PrinterSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'SupplyModelSet'
ALTER TABLE [dbo].[SupplyModelSet]
ADD CONSTRAINT [PK_SupplyModelSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'PrinterModelSet'
ALTER TABLE [dbo].[PrinterModelSet]
ADD CONSTRAINT [PK_PrinterModelSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'HistorySet'
ALTER TABLE [dbo].[HistorySet]
ADD CONSTRAINT [PK_HistorySet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'SupplySlotSet'
ALTER TABLE [dbo].[SupplySlotSet]
ADD CONSTRAINT [PK_SupplySlotSet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'SupplySet'
ALTER TABLE [dbo].[SupplySet]
ADD CONSTRAINT [PK_SupplySet]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [PrinterModels_Id], [SupplyModels_Id] in table 'PrinterModelSupplyModel'
ALTER TABLE [dbo].[PrinterModelSupplyModel]
ADD CONSTRAINT [PK_PrinterModelSupplyModel]
    PRIMARY KEY CLUSTERED ([PrinterModels_Id], [SupplyModels_Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- Creating foreign key on [ModelId] in table 'PrinterSet'
ALTER TABLE [dbo].[PrinterSet]
ADD CONSTRAINT [FK_PrinterModelPrinter]
    FOREIGN KEY ([ModelId])
    REFERENCES [dbo].[PrinterModelSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PrinterModelPrinter'
CREATE INDEX [IX_FK_PrinterModelPrinter]
ON [dbo].[PrinterSet]
    ([ModelId]);
GO

-- Creating foreign key on [PrinterId] in table 'SupplySlotSet'
ALTER TABLE [dbo].[SupplySlotSet]
ADD CONSTRAINT [FK_PrinterSupplySlot]
    FOREIGN KEY ([PrinterId])
    REFERENCES [dbo].[PrinterSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PrinterSupplySlot'
CREATE INDEX [IX_FK_PrinterSupplySlot]
ON [dbo].[SupplySlotSet]
    ([PrinterId]);
GO

-- Creating foreign key on [ModelId] in table 'SupplySet'
ALTER TABLE [dbo].[SupplySet]
ADD CONSTRAINT [FK_SupplyModelSupply]
    FOREIGN KEY ([ModelId])
    REFERENCES [dbo].[SupplyModelSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_SupplyModelSupply'
CREATE INDEX [IX_FK_SupplyModelSupply]
ON [dbo].[SupplySet]
    ([ModelId]);
GO

-- Creating foreign key on [PrinterModels_Id] in table 'PrinterModelSupplyModel'
ALTER TABLE [dbo].[PrinterModelSupplyModel]
ADD CONSTRAINT [FK_PrinterModelSupplyModel_PrinterModel]
    FOREIGN KEY ([PrinterModels_Id])
    REFERENCES [dbo].[PrinterModelSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating foreign key on [SupplyModels_Id] in table 'PrinterModelSupplyModel'
ALTER TABLE [dbo].[PrinterModelSupplyModel]
ADD CONSTRAINT [FK_PrinterModelSupplyModel_SupplyModel]
    FOREIGN KEY ([SupplyModels_Id])
    REFERENCES [dbo].[SupplyModelSet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_PrinterModelSupplyModel_SupplyModel'
CREATE INDEX [IX_FK_PrinterModelSupplyModel_SupplyModel]
ON [dbo].[PrinterModelSupplyModel]
    ([SupplyModels_Id]);
GO

-- Creating foreign key on [SupplyId] in table 'SupplySlotSet'
ALTER TABLE [dbo].[SupplySlotSet]
ADD CONSTRAINT [FK_SupplySlotSupply]
    FOREIGN KEY ([SupplyId])
    REFERENCES [dbo].[SupplySet]
        ([Id])
    ON DELETE NO ACTION ON UPDATE NO ACTION;
GO

-- Creating non-clustered index for FOREIGN KEY 'FK_SupplySlotSupply'
CREATE INDEX [IX_FK_SupplySlotSupply]
ON [dbo].[SupplySlotSet]
    ([SupplyId]);
GO

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------