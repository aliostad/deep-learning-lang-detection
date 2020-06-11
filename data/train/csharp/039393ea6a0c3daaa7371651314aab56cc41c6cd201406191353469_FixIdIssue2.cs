namespace ApiFox.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FixIdIssue2 : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.ApiRequests", "ApiId", "dbo.Apis");
            DropIndex("dbo.ApiRequests", new[] { "ApiId" });
            RenameColumn(table: "dbo.ApiRequests", name: "ApiId", newName: "Api_Id");
            AlterColumn("dbo.ApiRequests", "Api_Id", c => c.Int());
            CreateIndex("dbo.ApiRequests", "Api_Id");
            AddForeignKey("dbo.ApiRequests", "Api_Id", "dbo.Apis", "Id");
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.ApiRequests", "Api_Id", "dbo.Apis");
            DropIndex("dbo.ApiRequests", new[] { "Api_Id" });
            AlterColumn("dbo.ApiRequests", "Api_Id", c => c.Int(nullable: false));
            RenameColumn(table: "dbo.ApiRequests", name: "Api_Id", newName: "ApiId");
            CreateIndex("dbo.ApiRequests", "ApiId");
            AddForeignKey("dbo.ApiRequests", "ApiId", "dbo.Apis", "Id", cascadeDelete: true);
        }
    }
}
