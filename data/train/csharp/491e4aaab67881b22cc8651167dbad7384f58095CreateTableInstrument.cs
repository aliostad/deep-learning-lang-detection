using FluentMigrator;

namespace Bd.Icm.Migrations.Scripts
{
    [Migration(201603110005)]
    public class CreateTableInstrument : Migration
    {
        public override void Up()
        {
            Create.Table("Instrument")
                .WithColumn("Id").AsInt32().NotNullable().PrimaryKey()
                .WithRowVersionIdentity()
                .WithColumn("Type").AsString(150).NotNullable()
                .WithColumn("NickName").AsString(150).Nullable()
                .WithColumn("SerialNumber").AsString(100).NotNullable()
                .WithAuditFields()
                .WithVersioningFields();

            this.CreateUserForeignKeys("Instrument");
            
            Create.ForeignKey("FK_Instrument_InstrumentVersion")
                .FromTable("Instrument").InSchema("dbo").ForeignColumn("Id")
                .ToTable("InstrumentVersion").InSchema("dbo").PrimaryColumn("InstrumentId");
        }

        public override void Down()
        {
            this.DeleteUserForeignKeys("Instrument");
            Delete.DefaultConstraint().OnTable("Instrument").InSchema("dbo").OnColumn("EffectiveTo");
            Delete.ForeignKey("FK_Instrument_InstrumentVersion").OnTable("Instrument");
            Delete.Table("Instrument");
        }
    }
}
