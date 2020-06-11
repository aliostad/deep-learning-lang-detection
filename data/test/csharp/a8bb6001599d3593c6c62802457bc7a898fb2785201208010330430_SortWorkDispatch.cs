namespace THOK.Wms.Repository.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class SortWorkDispatch : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.wms_sort_work_dispatch",
                c => new
                    {
                        id = c.Guid(nullable: false),
                        order_date = c.String(nullable: false, maxLength: 14),
                        sorting_line_code = c.String(nullable: false, maxLength: 20),
                        dispatch_batch = c.String(nullable: false, maxLength: 2),
                        out_bill_no = c.String(nullable: false, maxLength: 20),
                        move_bill_no = c.String(nullable: false, maxLength: 20),
                        dispatch_status = c.String(nullable: false, maxLength: 1, fixedLength: true),
                        is_active = c.String(nullable: false, maxLength: 1, fixedLength: true),
                        update_time = c.DateTime(nullable: false),
                    })
                .PrimaryKey(t => t.id);
            
            AddColumn("dbo.wms_sort_order_dispatch", "sort_work_dispatch_id", c => c.Guid());
            AddColumn("dbo.wms_sort_order_dispatch", "work_status", c => c.String(nullable: false, maxLength: 1, fixedLength: true));
            AddForeignKey("dbo.wms_sort_order_dispatch", "sort_work_dispatch_id", "dbo.wms_sort_work_dispatch", "id");
            CreateIndex("dbo.wms_sort_order_dispatch", "sort_work_dispatch_id");
        }
        
        public override void Down()
        {
            DropIndex("dbo.wms_sort_order_dispatch", new[] { "sort_work_dispatch_id" });
            DropForeignKey("dbo.wms_sort_order_dispatch", "sort_work_dispatch_id", "dbo.wms_sort_work_dispatch");
            DropColumn("dbo.wms_sort_order_dispatch", "work_status");
            DropColumn("dbo.wms_sort_order_dispatch", "sort_work_dispatch_id");
            DropTable("dbo.wms_sort_work_dispatch");
        }
    }
}
