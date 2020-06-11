namespace VIPER.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class DeleteColumnFromJobProcess : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.JobProcess", "ProcessTime_ProcessTimeID", "dbo.ProcessTime");
            DropIndex("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID" });
            DropColumn("dbo.JobProcess", "ProcessTime_ProcessTimeID");
        }
        
        public override void Down()
        {
            AddColumn("dbo.JobProcess", "ProcessTime_ProcessTimeID", c => c.Int());
            CreateIndex("dbo.JobProcess", "ProcessTime_ProcessTimeID");
            AddForeignKey("dbo.JobProcess", "ProcessTime_ProcessTimeID", "dbo.ProcessTime", "ProcessTimeID");
        }
    }
}
