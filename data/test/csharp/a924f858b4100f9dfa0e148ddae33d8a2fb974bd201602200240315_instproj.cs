namespace Whapp.Migrations
{
    using System.Data.Entity.Migrations;

    public partial class instproj : DbMigration
    {
        public override void Up()
        {
            this.DropForeignKey("dbo.Instrument", "Project_ProjectID", "dbo.Project");
            this.DropIndex("dbo.Instrument", new[] { "Project_ProjectID" });
            this.CreateTable(
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
            
            this.DropColumn("dbo.Instrument", "Project_ProjectID");
        }
        
        public override void Down()
        {
            this.AddColumn("dbo.Instrument", "Project_ProjectID", c => c.Int());
            this.DropForeignKey("dbo.InstrumentProject", "Project_ProjectID", "dbo.Project");
            this.DropForeignKey("dbo.InstrumentProject", "Instrument_InstrumentID", "dbo.Instrument");
            this.DropIndex("dbo.InstrumentProject", new[] { "Project_ProjectID" });
            this.DropIndex("dbo.InstrumentProject", new[] { "Instrument_InstrumentID" });
            this.DropTable("dbo.InstrumentProject");
            this.CreateIndex("dbo.Instrument", "Project_ProjectID");
            this.AddForeignKey("dbo.Instrument", "Project_ProjectID", "dbo.Project", "ProjectID");
        }
    }
}
