using FluentMigrator;

namespace Bd.Icm.Migrations.Scripts
{
    [Migration(201603241032)]
    public class CreateTableInstrumentCommit : Migration
    {
        public override void Up()
        {
            Create.Table(DbSchema.Tables.InstrumentCommit)
                .WithColumn("Id").AsInt32().NotNullable().Identity().PrimaryKey()
                .WithColumn("InstrumentId").AsInt32().NotNullable()
                .ForeignKey("FK_InstrumentCommit_InstrumentVersion", DbSchema.Tables.InstrumentVersion, "InstrumentId")
                .WithColumn("Notes").AsString().Nullable()
                .WithAuditFields()
                .WithRowVersionTimestamp();

            this.CreateUserForeignKeys(DbSchema.Tables.InstrumentCommit);
        }

        public override void Down()
        {
            this.DeleteUserForeignKeys(DbSchema.Tables.InstrumentCommit);
            Delete.Table(DbSchema.Tables.InstrumentCommit);
        }
    }
}
