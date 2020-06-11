using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using TheGrid.Model.Instrument;
using System.Xml.Serialization;

namespace TheGrid.Model
{
    [Serializable, XmlInclude(typeof(InstrumentStart)), XmlInclude(typeof(InstrumentStop)), XmlInclude(typeof(InstrumentEffect)), XmlInclude(typeof(InstrumentSample)), XmlInclude(typeof(InstrumentNote)), XmlInclude(typeof(InstrumentCapture))]
    public class Clip
    {
        public InstrumentBase Instrument { get; set; }
        public bool[] Directions { get; set; }
        public int? Repeater { get; set; }
        public int? Speed { get; set; }
        public float Duration { get; set; }

        public Clip()
        {
            Directions = new bool[6];
            Duration = 1f;
        }
    }
}
