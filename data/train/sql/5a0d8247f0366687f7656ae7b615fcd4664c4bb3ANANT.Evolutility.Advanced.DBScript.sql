
/****** Object:  Table [dbo].[EvolitityAdvedModelData]    Script Date: 9/2/2014 4:54:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EvolitityAdvedModelData](
	[ModuleID] [int] NOT NULL,
	[ModelData] [ntext] NULL,
 CONSTRAINT [PK_EvolitityAdvedModelData] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO


/****** Object:  StoredProcedure [dbo].[EvolitityAdved_GetModelData]    Script Date: 9/2/2014 4:54:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[EvolitityAdved_GetModelData]
	@ModuleID int
AS
BEGIN
	SELECT * FROM EvolitityAdvedModelData
		WHERE ModuleID = @ModuleID
END


GO

/****** Object:  StoredProcedure [dbo].[EvolitityAdved_UpdateModelData]    Script Date: 9/2/2014 4:55:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[EvolitityAdved_UpdateModelData]
	@ModuleID int,
	@ModelData ntext
AS
BEGIN
	IF EXISTS(SELECT * FROM EvolitityAdvedModelData WHERE ModuleID = @ModuleID)
	BEGIN
		UPDATE EvolitityAdvedModelData 
			SET ModelData = @ModelData 
		WHERE ModuleID = @ModuleID
	END
	ELSE
	BEGIN
		INSERT INTO EvolitityAdvedModelData 
			VALUES(@ModuleID, @ModelData);
	END
END
GO

/****** Object:  Table [dbo].[EvolutilityAdvedModelSettings]    Script Date: 9/8/2014 10:42:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EvolutilityAdvedModelSettings](
	[ModuleID] [int] NOT NULL,
	[ModelID] [nvarchar](100) NOT NULL,
	[ModelLabel] [nvarchar](100) NULL,
	[ModelEntity] [nvarchar](100) NULL,
	[ModelEntities] [nvarchar](100) NULL,
	[ModelLeadField] [nvarchar](800) NULL,
	[ModelElements] [ntext] NULL,
 CONSTRAINT [PK_EvolutilityAdvedModelSettings] PRIMARY KEY CLUSTERED 
(
	[ModuleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

/****** Object:  StoredProcedure [dbo].[EvolutilityAdv_GetModelSettings]    Script Date: 9/8/2014 10:44:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[EvolutilityAdv_GetModelSettings]
	@ModuleID int
AS
BEGIN
	SELECT * FROM [EvolutilityAdvedModelSettings]
		WHERE ModuleID = @ModuleID
END

GO

/****** Object:  StoredProcedure [dbo].[EvolutilityAdv_UpdateModelSettings]    Script Date: 9/8/2014 10:44:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[EvolutilityAdv_UpdateModelSettings]
	@ModuleID int,
	@ModelID nvarchar(100),
	@ModelLabel nvarchar(100),
	@ModelEntity nvarchar(100),
	@ModelEntities nvarchar(100),
	@ModelLeadField nvarchar(800),
	@ModelElements ntext
AS
BEGIN
	IF EXISTS(SELECT * FROM [EvolutilityAdvedModelSettings] WHERE ModuleID = @ModuleID)
	BEGIN
		UPDATE [dbo].[EvolutilityAdvedModelSettings] 
			SET ModelID = @ModelID, 
				ModelLabel = @ModelLabel,
				ModelEntity = @ModelEntity,
				ModelEntities = @ModelEntities,
				ModelLeadField = @ModelLeadField,
				ModelElements = @ModelElements 
			WHERE ModuleID = @ModuleID
	END
	ELSE
	BEGIN
		INSERT INTO [EvolutilityAdvedModelSettings] 
		
			VALUES(@ModuleID,@ModelID, @ModelLabel,@ModelEntity,@ModelEntities,@ModelLeadField,@ModelElements);
	END
END

GO


