USE [DW_Work]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [temp].[FactBasicMeterRead](
	[AccountId] [int] NULL DEFAULT (NULL),
	[ServiceId] [int] NULL DEFAULT (NULL),
	[ProductId] [int] NULL DEFAULT (NULL),
	[MeterRegisterId] [int] NULL DEFAULT (NULL),
	[BasicMeterReadKey] [int] NULL DEFAULT (NULL),
	[ReadType] [nvarchar](100) NULL DEFAULT (NULL),
	[ReadSubtype] [nvarchar](100) NULL DEFAULT (NULL),
	[ReadValue] [decimal](18, 4) NULL DEFAULT (NULL),
	[ReadDateId] [int] NULL DEFAULT (NULL),
	[EstimatedRead] [nchar](3) NULL DEFAULT (NULL),
	[ReadPeriod] [int] NULL DEFAULT (NULL),
	[QualityMethod] [nvarchar](20) NULL DEFAULT (NULL),
	[AddFactor] [int] NULL DEFAULT (NULL)
) ON [DATA]

GO
