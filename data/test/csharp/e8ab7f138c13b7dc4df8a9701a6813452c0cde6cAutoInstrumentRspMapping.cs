using ProfiCraftsman.Contracts.Entities;
using System.ComponentModel.DataAnnotations.Schema;
using System.Data.Entity.ModelConfiguration;

namespace ProfiCraftsman.Lib.Data
{
    /// <summary>
    ///     Mappping table dbo.Auto_Instrument_Rsp to entity <see cref="AutoInstrumentRsp"/>
    /// </summary>
    internal sealed class AutoInstrumentRspMapping: EntityTypeConfiguration<AutoInstrumentRsp>
    {
        
        public static readonly AutoInstrumentRspMapping Instance = new AutoInstrumentRspMapping();
        
        /// <summary>
        ///     Initializes a new instance of the <see cref="AutoInstrumentRspMapping" /> class.
        /// </summary>
        private AutoInstrumentRspMapping()
        {

            ToTable("Auto_Instrument_Rsp", "dbo");
            // Primary Key
            HasKey(t => t.Id);

            //Properties
            Property(t => t.Id)
                .HasColumnName(AutoInstrumentRsp.Fields.Id)
                .HasDatabaseGeneratedOption(DatabaseGeneratedOption.Identity)
                .IsRequired();

            Property(t => t.AutoId)
                .HasColumnName(AutoInstrumentRsp.Fields.AutoId)
                .IsRequired();

            Property(t => t.InstrumentId)
                .HasColumnName(AutoInstrumentRsp.Fields.InstrumentId)
                .IsRequired();

            Property(t => t.Amount)
                .HasColumnName(AutoInstrumentRsp.Fields.Amount)
                .IsRequired();

            Property(t => t.CreateDate)
                .HasColumnName(AutoInstrumentRsp.Fields.CreateDate)
                .IsRequired();

            Property(t => t.ChangeDate)
                .HasColumnName(AutoInstrumentRsp.Fields.ChangeDate)
                .IsRequired();

            Property(t => t.DeleteDate)
                .HasColumnName(AutoInstrumentRsp.Fields.DeleteDate);


            //Relationships
            HasRequired(a => a.Instruments)
                .WithMany(i => i.AutoInstrumentRsps)
                .HasForeignKey(t => t.InstrumentId);
            HasRequired(a => a.Autos)
                .WithMany(a => a.AutoInstrumentRsps)
                .HasForeignKey(t => t.AutoId);
        }
    }
}
