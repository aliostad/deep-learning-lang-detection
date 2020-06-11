using System;
using System.Xml.Serialization;

namespace GuitarStore.Models
{
    #region InstrumentType.cs
    [Serializable()]
    public class InstrumentType
    {
        [XmlElement("InstrumentTypeID")]
        public int InstrumentTypeID { get; set; }

        [XmlElement("InstrumentTypeName")]
        public string InstrumentTypeName { get; set; }
    }
    #endregion

    #region InstrumentTypeCollection.cs
    [Serializable()]
    [System.Xml.Serialization.XmlRoot("root")]
    public class InstrumentTypeCollection
    {
        [XmlArray("InstrumentTypes")]
        [XmlArrayItem("InstrumentType", typeof(InstrumentType))]
        public InstrumentType[] InstrumentTypes { get; set; }
    }
    #endregion
}