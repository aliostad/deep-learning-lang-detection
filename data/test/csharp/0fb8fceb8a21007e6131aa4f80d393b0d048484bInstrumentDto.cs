using Newtonsoft.Json;

namespace SFH.IT.Hljodrit.Common.Dto
{
    /// <summary>
    /// A DTO class that represents an instrument. Contains various information and metadata on an instrument.
    /// </summary>
    public class InstrumentDto
    {
        public InstrumentDto() { }

        public InstrumentDto(string code, string instrumentEnglish, string instrumentIcelandic, string description)
        {
            IdCode = code;
            InstrumentNameEnglish = instrumentEnglish;
            InstrumentNameIcelandic = instrumentIcelandic;
            DescriptionInIcelandic = description;
        }

        /// <summary>
        /// The three letter identifying code for the relevant instrument. F.e 'ACC' for Accordion.
        /// </summary>
        [JsonProperty(PropertyName = "idCode")]
        public string IdCode { get; set; }

        /// <summary>
        /// The english name for the chosen instrument.
        /// </summary>
        [JsonProperty(PropertyName = "instrumentNameEnglish")]
        public string InstrumentNameEnglish { get; set; }

        /// <summary>
        /// The icelandic name for the chosen instrument.
        /// </summary>
        [JsonProperty(PropertyName = "instrumentNameIcelandic")]
        public string InstrumentNameIcelandic { get; set; }

        /// <summary>
        /// Description on the chosen instrument in icelandic.
        /// </summary>
        [JsonProperty(PropertyName = "descriptionInIcelandic")]
        public string DescriptionInIcelandic { get; set; }
    }
}
