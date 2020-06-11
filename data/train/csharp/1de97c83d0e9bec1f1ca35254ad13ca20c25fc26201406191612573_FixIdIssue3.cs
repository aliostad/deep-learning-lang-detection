namespace ApiFox.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class FixIdIssue3 : DbMigration
    {
        public override void Up()
        {
            DropForeignKey("dbo.ApiRequests", "Api_Id", "dbo.Apis");
            DropIndex("dbo.ApiRequests", new[] { "Api_Id" });
            RenameColumn(table: "dbo.ApiRequests", name: "Api_Id", newName: "ApiId");
            AlterColumn("dbo.ApiRequests", "ApiId", c => c.Int(nullable: false));
            CreateIndex("dbo.ApiRequests", "ApiId");
            AddForeignKey("dbo.ApiRequests", "ApiId", "dbo.Apis", "Id", cascadeDelete: true);
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.ApiRequests", "ApiId", "dbo.Apis");
            DropIndex("dbo.ApiRequests", new[] { "ApiId" });
            AlterColumn("dbo.ApiRequests", "ApiId", c => c.Int());
            RenameColumn(table: "dbo.ApiRequests", name: "ApiId", newName: "Api_Id");
            CreateIndex("dbo.ApiRequests", "Api_Id");
            AddForeignKey("dbo.ApiRequests", "Api_Id", "dbo.Apis", "Id");
        }
    }
}
