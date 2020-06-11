namespace LiteDispatch.DbContext.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class Pascal : DbMigration
    {
        public override void Up()
        {
            AlterColumn("dbo.Haulier", "Name", c => c.String());
            AlterColumn("dbo.DispatchNote", "TruckReg", c => c.String());
            AlterColumn("dbo.DispatchNote", "DispatchReference", c => c.String());
            AlterColumn("dbo.DispatchNote", "User", c => c.String());
            AlterColumn("dbo.DispatchLine", "ProductType", c => c.String());
            AlterColumn("dbo.DispatchLine", "Product", c => c.String());
            AlterColumn("dbo.DispatchLine", "Metric", c => c.String());
            AlterColumn("dbo.DispatchLine", "ShopLetter", c => c.String());
            AlterColumn("dbo.DispatchLine", "Client", c => c.String());
        }
        
        public override void Down()
        {
            AlterColumn("dbo.DispatchLine", "Client", c => c.String(maxLength: 4000));
            AlterColumn("dbo.DispatchLine", "ShopLetter", c => c.String(maxLength: 4000));
            AlterColumn("dbo.DispatchLine", "Metric", c => c.String(maxLength: 4000));
            AlterColumn("dbo.DispatchLine", "Product", c => c.String(maxLength: 4000));
            AlterColumn("dbo.DispatchLine", "ProductType", c => c.String(maxLength: 4000));
            AlterColumn("dbo.DispatchNote", "User", c => c.String(maxLength: 4000));
            AlterColumn("dbo.DispatchNote", "DispatchReference", c => c.String(maxLength: 4000));
            AlterColumn("dbo.DispatchNote", "TruckReg", c => c.String(maxLength: 4000));
            AlterColumn("dbo.Haulier", "Name", c => c.String(maxLength: 4000));
        }
    }
}
