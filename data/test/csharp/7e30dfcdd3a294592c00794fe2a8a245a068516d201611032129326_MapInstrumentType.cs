namespace WebInstruments.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class MapInstrumentType : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Instrument", "InstrumentType_Id", "dbo.InstrumentType");
            DropIndex("dbo.Instrument", new[] { "InstrumentType_Id" });
            DropColumn("dbo.Instrument", "IdInstrumentType");
            RenameColumn(table: "dbo.Instrument", name: "InstrumentType_Id", newName: "IdInstrumentType");
            AlterColumn("dbo.Instrument", "IdInstrumentType", c => c.Int(nullable: false));
            CreateIndex("dbo.Instrument", "IdInstrumentType");
            AddForeignKey("dbo.Instrument", "IdInstrumentType", "dbo.InstrumentType", "Id", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.Instrument", "IdInstrumentType", "dbo.InstrumentType");
            DropIndex("dbo.Instrument", new[] { "IdInstrumentType" });
            AlterColumn("dbo.Instrument", "IdInstrumentType", c => c.Int());
            RenameColumn(table: "dbo.Instrument", name: "IdInstrumentType", newName: "InstrumentType_Id");
            AddColumn("dbo.Instrument", "IdInstrumentType", c => c.Int(nullable: false));
            CreateIndex("dbo.Instrument", "InstrumentType_Id");
            AddForeignKey("dbo.Instrument", "InstrumentType_Id", "dbo.InstrumentType", "Id");
        }
    }
}
