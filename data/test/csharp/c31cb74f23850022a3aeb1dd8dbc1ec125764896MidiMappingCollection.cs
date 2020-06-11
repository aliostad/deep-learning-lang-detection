using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODM_DataManagerLibrary.MidiMappings
{
    public class MidiMappingCollection
    {
        public string Name { get; set; }
        public List<MidiMappingInstrument> MidiInstruments;

        public MidiMappingCollection(string name)
        {
            Name = name;
            MidiInstruments = new List<MidiMappingInstrument>();
        }

        public void AddMidiMappingInstrument(string name, string pitch, string velocityLow, string velocityHigh, string channel, bool ignoreCollisions = false)
        {
            MidiMappingInstrument instrument = GetMidiMappingInstrument(name);

            if (ignoreCollisions)
            {
                if (instrument != null) { return; }
            }
            else
            {
                if (instrument != null)
                {
                    throw new Exception(string.Format("Midi Mapping Instrument '{0}' already exists"));
                }
            }
            MidiInstruments.Add(new MidiMappingInstrument(name, pitch, velocityLow, velocityHigh, channel));
        }

        public MidiMappingInstrument GetMidiMappingInstrument(string name)
        {
            IList<MidiMappingInstrument> match = MidiInstruments.Where(p => p.InstrumentName == name).ToList();
            if (match != null && match.Count == 1)
            {
                return match[0];
            }
            return null;
        }

    }
}
