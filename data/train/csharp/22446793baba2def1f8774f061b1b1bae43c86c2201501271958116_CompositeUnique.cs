namespace VIPER.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class CompositeUnique : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" }, "dbo.ProcessTime");
            DropIndex("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" });
            DropIndex("dbo.ProcessTime", new[] { "ProcessID" });
            DropIndex("dbo.ProcessTime", new[] { "RepairTypeID" });
            DropIndex("dbo.ProcessTime", new[] { "SizeID" });
            DropColumn("dbo.JobProcess", "ProcessTimeID");
            RenameColumn(table: "dbo.JobProcess", name: "ProcessTime_ProcessTimeID", newName: "ProcessTimeID");
            DropPrimaryKey("dbo.ProcessTime");
            AlterColumn("dbo.JobProcess", "ProcessTimeID", c => c.Int(nullable: false));
            AddPrimaryKey("dbo.ProcessTime", "ProcessTimeID");
            CreateIndex("dbo.JobProcess", "ProcessTimeID");
            CreateIndex("dbo.ProcessTime", new[] { "ProcessID", "RepairTypeID", "SizeID" }, unique: true, name: "IX_ProcRepairSize");
            //AddForeignKey("dbo.JobProcess", "ProcessTimeID", "dbo.ProcessTime", "ProcessTimeID", cascadeDelete: false);
            DropColumn("dbo.JobProcess", "ProcessTime_ProcessID");
            DropColumn("dbo.JobProcess", "ProcessTime_RepairTypeID");
            DropColumn("dbo.JobProcess", "ProcessTime_SizeID");
        }
        
        public override void Down()
        {
            AddColumn("dbo.JobProcess", "ProcessTime_SizeID", c => c.Int());
            AddColumn("dbo.JobProcess", "ProcessTime_RepairTypeID", c => c.Int());
            AddColumn("dbo.JobProcess", "ProcessTime_ProcessID", c => c.Int());
            //DropForeignKey("dbo.JobProcess", "ProcessTimeID", "dbo.ProcessTime");
            DropIndex("dbo.ProcessTime", "IX_ProcRepairSize");
            DropIndex("dbo.JobProcess", new[] { "ProcessTimeID" });
            DropPrimaryKey("dbo.ProcessTime");
            AlterColumn("dbo.JobProcess", "ProcessTimeID", c => c.Int());
            AddPrimaryKey("dbo.ProcessTime", new[] { "ProcessTimeID", "ProcessID", "RepairTypeID", "SizeID" });
            RenameColumn(table: "dbo.JobProcess", name: "ProcessTimeID", newName: "ProcessTime_ProcessTimeID");
            AddColumn("dbo.JobProcess", "ProcessTimeID", c => c.Int(nullable: false));
            CreateIndex("dbo.ProcessTime", "SizeID");
            CreateIndex("dbo.ProcessTime", "RepairTypeID");
            CreateIndex("dbo.ProcessTime", "ProcessID");
            CreateIndex("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" });
            AddForeignKey("dbo.JobProcess", new[] { "ProcessTime_ProcessTimeID", "ProcessTime_ProcessID", "ProcessTime_RepairTypeID", "ProcessTime_SizeID" }, "dbo.ProcessTime", new[] { "ProcessTimeID", "ProcessID", "RepairTypeID", "SizeID" });
        }
    }
}
