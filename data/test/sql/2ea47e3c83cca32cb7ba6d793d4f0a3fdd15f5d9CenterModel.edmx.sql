
-- --------------------------------------------------
-- Entity Designer DDL Script for SQL Server 2005, 2008, 2012 and Azure
-- --------------------------------------------------
-- Date Created: 05/20/2015 21:27:50
-- Generated from EDMX file: E:\users\asus\documents\visual studio 2013\ControllerCenter\ControllerCenter\ControllerCenter.MVVM\ControllerCenter.Model\CenterModel.edmx
-- --------------------------------------------------

SET QUOTED_IDENTIFIER OFF;
GO
USE [ControllerCenterDB];
GO
IF SCHEMA_ID(N'dbo') IS NULL EXECUTE(N'CREATE SCHEMA [dbo]');
GO

-- --------------------------------------------------
-- Dropping existing FOREIGN KEY constraints
-- --------------------------------------------------


-- --------------------------------------------------
-- Dropping existing tables
-- --------------------------------------------------

IF OBJECT_ID(N'[dbo].[BaudRateModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[BaudRateModel];
GO
IF OBJECT_ID(N'[dbo].[CodedFormatModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CodedFormatModel];
GO
IF OBJECT_ID(N'[dbo].[CommPortModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CommPortModel];
GO
IF OBJECT_ID(N'[dbo].[CommunicationModeModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[CommunicationModeModel];
GO
IF OBJECT_ID(N'[dbo].[DataBitModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DataBitModel];
GO
IF OBJECT_ID(N'[dbo].[DeviceActionModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DeviceActionModel];
GO
IF OBJECT_ID(N'[dbo].[DeviceModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[DeviceModel];
GO
IF OBJECT_ID(N'[dbo].[InteractiveAreaModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[InteractiveAreaModel];
GO
IF OBJECT_ID(N'[dbo].[IpConfigModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[IpConfigModel];
GO
IF OBJECT_ID(N'[dbo].[IpModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[IpModel];
GO
IF OBJECT_ID(N'[dbo].[OperateConfigModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[OperateConfigModel];
GO
IF OBJECT_ID(N'[dbo].[ParityCheckBitModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[ParityCheckBitModel];
GO
IF OBJECT_ID(N'[dbo].[SerialPortConfigModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[SerialPortConfigModel];
GO
IF OBJECT_ID(N'[dbo].[StopBitModel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[StopBitModel];
GO

-- --------------------------------------------------
-- Creating all tables
-- --------------------------------------------------

-- Creating table 'BaudRateModel'
CREATE TABLE [dbo].[BaudRateModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [BaudRateName] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'CodedFormatModel'
CREATE TABLE [dbo].[CodedFormatModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CodedFormatName] nvarchar(max)  NOT NULL,
    [Status] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'CommPortModel'
CREATE TABLE [dbo].[CommPortModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CommPortName] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'CommunicationModeModel'
CREATE TABLE [dbo].[CommunicationModeModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CommunicationModeName] nvarchar(max)  NOT NULL,
    [Status] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'DataBitModel'
CREATE TABLE [dbo].[DataBitModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [DataBitName] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'DeviceActionModel'
CREATE TABLE [dbo].[DeviceActionModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [DeviceId] int  NOT NULL,
    [ActionDate] nvarchar(max)  NOT NULL,
    [Status] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'DeviceModel'
CREATE TABLE [dbo].[DeviceModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [DeviceName] nvarchar(max)  NOT NULL,
    [Status] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'InteractiveAreaModel'
CREATE TABLE [dbo].[InteractiveAreaModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [Name] nvarchar(max)  NOT NULL,
    [Status] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'IpConfigModel'
CREATE TABLE [dbo].[IpConfigModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [IpId] int  NOT NULL,
    [PortName] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'IpModel'
CREATE TABLE [dbo].[IpModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [IpName] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'OperateConfigModel'
CREATE TABLE [dbo].[OperateConfigModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [OperateName] nvarchar(max)  NOT NULL,
    [CommunicationModeId] int  NOT NULL,
    [CodedFormatId] int  NOT NULL,
    [CodeControl] nvarchar(max)  NOT NULL,
    [DelayTime] int  NOT NULL,
    [Status] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'ParityCheckBitModel'
CREATE TABLE [dbo].[ParityCheckBitModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [ParityCheckBitName] nvarchar(max)  NOT NULL
);
GO

-- Creating table 'SerialPortConfigModel'
CREATE TABLE [dbo].[SerialPortConfigModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [CommPortId] int  NOT NULL,
    [BaudRateId] int  NOT NULL,
    [DataBitId] int  NOT NULL,
    [StopBitId] int  NOT NULL,
    [ParityCheckBitId] int  NOT NULL
);
GO

-- Creating table 'StopBitModel'
CREATE TABLE [dbo].[StopBitModel] (
    [Id] int IDENTITY(1,1) NOT NULL,
    [StopBitName] nvarchar(max)  NOT NULL
);
GO

-- --------------------------------------------------
-- Creating all PRIMARY KEY constraints
-- --------------------------------------------------

-- Creating primary key on [Id] in table 'BaudRateModel'
ALTER TABLE [dbo].[BaudRateModel]
ADD CONSTRAINT [PK_BaudRateModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CodedFormatModel'
ALTER TABLE [dbo].[CodedFormatModel]
ADD CONSTRAINT [PK_CodedFormatModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CommPortModel'
ALTER TABLE [dbo].[CommPortModel]
ADD CONSTRAINT [PK_CommPortModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'CommunicationModeModel'
ALTER TABLE [dbo].[CommunicationModeModel]
ADD CONSTRAINT [PK_CommunicationModeModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'DataBitModel'
ALTER TABLE [dbo].[DataBitModel]
ADD CONSTRAINT [PK_DataBitModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'DeviceActionModel'
ALTER TABLE [dbo].[DeviceActionModel]
ADD CONSTRAINT [PK_DeviceActionModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'DeviceModel'
ALTER TABLE [dbo].[DeviceModel]
ADD CONSTRAINT [PK_DeviceModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'InteractiveAreaModel'
ALTER TABLE [dbo].[InteractiveAreaModel]
ADD CONSTRAINT [PK_InteractiveAreaModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'IpConfigModel'
ALTER TABLE [dbo].[IpConfigModel]
ADD CONSTRAINT [PK_IpConfigModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'IpModel'
ALTER TABLE [dbo].[IpModel]
ADD CONSTRAINT [PK_IpModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'OperateConfigModel'
ALTER TABLE [dbo].[OperateConfigModel]
ADD CONSTRAINT [PK_OperateConfigModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'ParityCheckBitModel'
ALTER TABLE [dbo].[ParityCheckBitModel]
ADD CONSTRAINT [PK_ParityCheckBitModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'SerialPortConfigModel'
ALTER TABLE [dbo].[SerialPortConfigModel]
ADD CONSTRAINT [PK_SerialPortConfigModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- Creating primary key on [Id] in table 'StopBitModel'
ALTER TABLE [dbo].[StopBitModel]
ADD CONSTRAINT [PK_StopBitModel]
    PRIMARY KEY CLUSTERED ([Id] ASC);
GO

-- --------------------------------------------------
-- Creating all FOREIGN KEY constraints
-- --------------------------------------------------

-- --------------------------------------------------
-- Script has ended
-- --------------------------------------------------