
            
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Inventory_ProducerModelGetByPk    
    @ModelNo numeric(18, 0)
AS
BEGIN
    select *
    from Inventory_ProducerModel    
    where @ModelNo = ModelNo;
END
GO

            
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Inventory_ProducerModelGetByFk 
    @ItemID numeric(18, 0) = null,
    @ProducerID numeric(18, 0) = null,
    @ByCreatedOn bit  = null,
    @CreatedOnFrom datetime = null,
    @CreatedOnTo datetime = null,
    @ByModifiedOn bit  = null,
    @ModifiedOnFrom datetime = null,
    @ModifiedOnTo datetime = null
AS
BEGIN		
		select *
		from Inventory_ProducerModel RPT		
		where ( @ItemID is null or ItemID = @ItemID)
    and ( @ProducerID is null or ProducerID = @ProducerID)
    and ( @ByCreatedOn is null or dbo.DateOnly(CreatedOn) between dbo.DateOnly(@CreatedOnFrom) and dbo.DateOnly(@CreatedOnTo))
    and ( @ByModifiedOn is null or dbo.DateOnly(ModifiedOn) between dbo.DateOnly(@ModifiedOnFrom) and dbo.DateOnly(@ModifiedOnTo))
    		
END
GO

            
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Inventory_ProducerModelGetAll 
AS
BEGIN		
		select *
		from Inventory_ProducerModel		
END
GO

            
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Inventory_ProducerModelInsert
    @ModelNo numeric(18, 0) out,
    @ItemID numeric(18, 0) = null,
    @ProducerID numeric(18, 0) = null,
    @ModelName nvarchar(50) = null,
    @CreatedBy nvarchar(50) = null,
    @CreatedOn datetime = null,
    @ModifiedBy nvarchar(50) = null,
    @ModifiedOn datetime = null
AS
BEGIN
    insert into Inventory_ProducerModel
    (
        ItemID,
        ProducerID,
        ModelName,
        CreatedBy,
        CreatedOn,
        ModifiedBy,
        ModifiedOn
    )	
    values
    (
        @ItemID,
        @ProducerID,
        @ModelName,
        @CreatedBy,
        GETDATE(),
        @ModifiedBy,
        @ModifiedOn
    )
    set @ModelNo = SCOPE_IDENTITY()
end
GO
            
            

CREATE PROCEDURE Inventory_ProducerModelUpdateByPk
    @ModelNo numeric(18, 0) ,
    @ItemID numeric(18, 0) = null,
    @ProducerID numeric(18, 0) = null,
    @ModelName nvarchar(50) = null,
    @CreatedBy nvarchar(50) = null,
    @CreatedOn datetime = null,
    @ModifiedBy nvarchar(50) = null,
    @ModifiedOn datetime = null
AS
BEGIN
    update Inventory_ProducerModel
    set 
        ItemID = @ItemID,
        ProducerID = @ProducerID,
        ModelName = @ModelName,
        CreatedBy = @CreatedBy,
        CreatedOn = @CreatedOn,
        ModifiedBy = @ModifiedBy,
        ModifiedOn = GETDATE()
	where ModelNo = @ModelNo;
end
GO

            
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE Inventory_ProducerModelDeleteByPK    
    @ModelNo numeric(18, 0)
AS
BEGIN
	delete from Inventory_ProducerModel	
    where @ModelNo = ModelNo;
END
GO
