namespace VIPER.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class IdentityKey : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" }, "dbo.ProcessTime");
            DropPrimaryKey("dbo.ProcessTime");
            AlterColumn("dbo.ProcessTime", "ProcessTimeID", c => c.Int(nullable: false, identity: true));
            AddPrimaryKey("dbo.ProcessTime", new[] { "ProcessTimeID", "ProcessID", "RepairTypeID", "SizeID" });
            AddForeignKey("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" }, "dbo.ProcessTime", new[] { "ProcessTimeID", "ProcessID", "RepairTypeID", "SizeID" });
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" }, "dbo.ProcessTime");
            DropPrimaryKey("dbo.ProcessTime");
            AlterColumn("dbo.ProcessTime", "ProcessTimeID", c => c.Int(nullable: false));
            AddPrimaryKey("dbo.ProcessTime", new[] { "ProcessTimeID", "ProcessID", "RepairTypeID", "SizeID" });
            AddForeignKey("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" }, "dbo.ProcessTime", new[] { "ProcessTimeID", "ProcessID", "RepairTypeID", "SizeID" });
        }
    }
}
