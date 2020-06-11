using System;

namespace Nautilus.Data
{
    public partial class Instrument_Alias_ : NautilusEntity
    {
        public const string TableName = "Instrument_Alias";

        /// <summary>
        /// Gets or sets Instrument_Id, NUMBER(16) (not null)
        /// </summary>
        public decimal Instrument_Id { get; set; }

        /// <summary>
        /// Gets or sets Instrument_Alias, VARCHAR2(255) (not null)
        /// </summary>
        public string Instrument_Alias { get; set; }

        /// <summary>
        /// Gets or sets Instrument_Unit_Id, NUMBER(16) (null)
        /// </summary>
        public decimal? Instrument_Unit_Id { get; set; }

    }
}
