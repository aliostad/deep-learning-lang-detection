using System;
using System.Xml.Serialization;

namespace GuitarStore.Models
{
    #region Instrument.cs
    [Serializable()]
    public class Instrument
    {
        [XmlAttribute("id")]
        public int InstrumentId { get; set; }

        [XmlElement("brand")]
        public string Brand { get; set; }

        [XmlElement("model")]
        public string InstrumentModel { get; set; }

        [XmlElement("desc")]
        public string Description { get; set; }

        [XmlElement("price")]
        public double Price { get; set; }

        [XmlElement("InstrumentType")]
        public int InstrumentTypeID { get; set; }
    }
    #endregion

    #region InstrumentCollection.cs
    [Serializable()]
    [System.Xml.Serialization.XmlRoot("instruments")]
    public class InstrumentCollection
    {
        [XmlArray("guitarType")]
        [XmlArrayItem("item", typeof(Instrument))]
        public Instrument[] Instruments { get; set; }
    }
    #endregion
}