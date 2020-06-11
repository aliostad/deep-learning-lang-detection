namespace services.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class instrumenttyperestored : DbMigration
    {
        public override void Up()
        {
            AddColumn("dbo.Instruments", "InstrumentTypeId", c => c.Int(nullable: false));
            AddForeignKey("dbo.Instruments", "InstrumentTypeId", "dbo.InstrumentTypes", "Id");
            CreateIndex("dbo.Instruments", "InstrumentTypeId");
        }
        
        public override void Down()
        {
            DropIndex("dbo.Instruments", new[] { "InstrumentTypeId" });
            DropForeignKey("dbo.Instruments", "InstrumentTypeId", "dbo.InstrumentTypes");
            DropColumn("dbo.Instruments", "InstrumentTypeId");
        }
    }
}
