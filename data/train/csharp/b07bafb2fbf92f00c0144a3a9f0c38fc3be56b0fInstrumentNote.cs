using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace TheGrid.Model.Instrument
{
    [Serializable]
    public class InstrumentNote : InstrumentBase
    {
        public float NoteKey { get; set; }
        public string NoteName { get; set; }

        public InstrumentNote()
        {
        }

        public InstrumentNote(float noteKey, string noteName)
        {
            NoteKey = noteKey;
            NoteName = noteName;
        }
    }
}
