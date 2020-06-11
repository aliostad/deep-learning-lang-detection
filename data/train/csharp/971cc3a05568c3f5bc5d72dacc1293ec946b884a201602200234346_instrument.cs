namespace Whapp.Migrations
{
    using System.Data.Entity.Migrations;

    public partial class instrument : DbMigration
    {
        public override void Up()
        {
            this.CreateTable(
                "dbo.Instrument",
                c => new
                    {
                        InstrumentID = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                        Project_ProjectID = c.Int(),
                    })
                .PrimaryKey(t => t.InstrumentID)
                .ForeignKey("dbo.Project", t => t.Project_ProjectID)
                .Index(t => t.Project_ProjectID);
            
        }
        
        public override void Down()
        {
            this.DropForeignKey("dbo.Instrument", "Project_ProjectID", "dbo.Project");
            this.DropIndex("dbo.Instrument", new[] { "Project_ProjectID" });
            this.DropTable("dbo.Instrument");
        }
    }
}
