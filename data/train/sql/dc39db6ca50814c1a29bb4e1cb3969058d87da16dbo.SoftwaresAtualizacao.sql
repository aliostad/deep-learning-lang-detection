USE [MarteUpdates]
GO

/****** Object:  Table [dbo].[SoftwaresAtualizacao]    Script Date: 07/01/2014 21:03:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SoftwaresAtualizacao](
	[IDSoftwareAtualizacao] [int] IDENTITY(1,1) NOT NULL,
	[Nome] [varchar](50) NOT NULL,
	[Descricao] [varchar](100) NULL,
 CONSTRAINT [PK_AtualizacoesEquipamentos] PRIMARY KEY CLUSTERED 
(
	[IDSoftwareAtualizacao] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Guardará as atualizacoes que poderão ser feitos no equipamentos. Valores Default: NavData e ChartView' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SoftwaresAtualizacao', @level2type=N'COLUMN',@level2name=N'IDSoftwareAtualizacao'
GO

