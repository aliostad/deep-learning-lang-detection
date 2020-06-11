namespace ManyToMany.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class instproj : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.Instrument", "Project_ProjectID", "dbo.Project");
            DropIndex("dbo.Instrument", new[] { "Project_ProjectID" });
            CreateTable(
                "dbo.InstrumentProject",
                c => new
                    {
                        Instrument_InstrumentID = c.Int(nullable: false),
                        Project_ProjectID = c.Int(nullable: false),
                    })
                .PrimaryKey(t => new { t.Instrument_InstrumentID, t.Project_ProjectID })
                .ForeignKey("dbo.Instrument", t => t.Instrument_InstrumentID, cascadeDelete: true)
                .ForeignKey("dbo.Project", t => t.Project_ProjectID, cascadeDelete: true)
                .Index(t => t.Instrument_InstrumentID)
                .Index(t => t.Project_ProjectID);
            
            DropColumn("dbo.Instrument", "Project_ProjectID");
        }
        
        public override void Down()
        {
            AddColumn("dbo.Instrument", "Project_ProjectID", c => c.Int());
            DropForeignKey("dbo.InstrumentProject", "Project_ProjectID", "dbo.Project");
            DropForeignKey("dbo.InstrumentProject", "Instrument_InstrumentID", "dbo.Instrument");
            DropIndex("dbo.InstrumentProject", new[] { "Project_ProjectID" });
            DropIndex("dbo.InstrumentProject", new[] { "Instrument_InstrumentID" });
            DropTable("dbo.InstrumentProject");
            CreateIndex("dbo.Instrument", "Project_ProjectID");
            AddForeignKey("dbo.Instrument", "Project_ProjectID", "dbo.Project", "ProjectID");
        }
    }
}
