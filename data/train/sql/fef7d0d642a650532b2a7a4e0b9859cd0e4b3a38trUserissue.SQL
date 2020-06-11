USE [ITInventory]
GO
/****** Object:  Trigger [dbo].[trUserissue]    Script Date: 12/01/2013 12:16:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
ALTER TRIGGER [dbo].[trUserissue]
   ON  [ITInventory].[dbo].[INV_Userissue] 
   FOR  INSERT,DELETE,UPDATE
AS 
DECLARE  @ModelID AS uniqueidentifier;
DECLARE  @LocID   AS uniqueidentifier;

select @ModelID=i.ModelID from inserted i;	
select @LocID=i.LocID from inserted i;	

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for trigger here
    IF (NOT EXISTS(SELECT * FROM dbo.INV_Factorystock WHERE ModelID=@ModelID and LocID=@LocID and FSDate=(SELECT MAX(UIssueDate) FROM dbo.INV_Userissue) ))
    INSERT INTO dbo.INV_Factorystock( ItemID, ModelID, FSDate, TFSRQty, TFSIQty, LocID, FSBalanceQty )
     SELECT ItemID as ItemID, 
            ModelID AS ModelID, 
            FSDate=convert(date,GETDATE(),103),            
            (SELECT sum(IssueQty) FROM dbo.INV_ItemIssue WHERE ModelID=@ModelID and LocID=@LocID) as TFSRQty, 
            (SELECT sum(UIssueQty) FROM dbo.INV_Userissue WHERE ModelID=@ModelID and LocID=@LocID) as TFSIQty, 
            LocID=LocID,           
            ((SELECT sum(IssueQty) FROM dbo.INV_ItemIssue WHERE ModelID=@ModelID and LocID=@LocID)-(SELECT sum(UIssueQty) FROM dbo.INV_Userissue WHERE ModelID=@ModelID and LocID=@LocID)) as FSBalanceQty  
        FROM
        dbo.INV_ItemIssue
        WHERE ModelID=@ModelID and LocID=@LocID
        GROUP BY ItemID, ModelID, LocID 
        
        UPDATE dbo.INV_Factorystock SET 
        TFSRQty=(SELECT sum(IssueQty) FROM dbo.INV_ItemIssue WHERE ModelID=@ModelID and LocID=@LocID) , 
        TFSIQty=(SELECT sum(UIssueQty) FROM dbo.INV_Userissue WHERE ModelID=@ModelID and LocID=@LocID),
        FSBalanceQty=((SELECT sum(IssueQty) FROM dbo.INV_ItemIssue WHERE ModelID=@ModelID and LocID=@LocID)-(SELECT sum(UIssueQty) FROM dbo.INV_Userissue WHERE ModelID=@ModelID and LocID=@LocID))
        WHERE ModelID=@ModelID and LocID=@LocID and FSDate=(SELECT MAX(UIssueDate) FROM dbo.INV_Userissue)

END
