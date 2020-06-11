using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.Serialization;

namespace FastQuant
{
    [DataContract]
    public class Leg
    {
        private Framework framework;

        private Instrument instrument;

        public int InstrumentId { get; private set; }

        [DataMember]
        public double Weight { get; set; }

        internal Leg()
        {
        }

        internal Leg(Framework framework)
        {
            this.framework = framework;
        }

        public Leg(Instrument instrument, double weight = 1.0)
        {
            this.instrument = instrument;
            Weight = weight;
            InstrumentId = instrument.Id;
            this.framework = instrument.Framework;
        }

        internal void Init(Framework framework)
        {
            this.framework = framework;
            this.instrument = framework.InstrumentManager.GetById(InstrumentId);
            if (this.instrument == null)
                Console.WriteLine($"{nameof(Leg)}::{nameof(Init)} Can not find leg instrument in the framework instrument manager. Id = {InstrumentId}");
        }

        [Browsable(false)]
        public Instrument Instrument
        {
            get
            {
                return this.instrument;
            }
            set
            {
                this.instrument = value;
                InstrumentId = this.instrument.Id;
            }
        }

        public string Symbol
        {
            get
            {
                return this.instrument?.Symbol;
            }
            set
            {
                var instrument = this.framework.InstrumentManager[value];
                if (instrument == null)
                    Console.WriteLine($"Leg::Symbol Can not find instrument with such symbol in the framework instrument manager. Symbol = {InstrumentId}");

                this.instrument = instrument;
                InstrumentId = instrument.Id;
            }
        }

        #region Extra
        public static Leg FromReader(BinaryReader reader)
        {
            return new Leg
            {
                InstrumentId = reader.ReadInt32(),
                Weight = reader.ReadDouble()
            };
        }

        public void ToWriter(BinaryWriter writer)
        {
            writer.Write(InstrumentId);
            writer.Write(Weight);
        }

        #endregion
    }
}