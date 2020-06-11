using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MidiEditorPlayerCs
{
    public class InstrumentMidiEvent : MidiEvent
    {
        public InstrumentMidiEvent()
        {
        }
        public InstrumentMidiEvent(int Delt, int CellXPos ,sbyte MidiChannel, byte InstrumentNumber)
        {
            CellPosition = CellXPos;
            Delta = Delt;
            EventType = 0x0C;
            Channel = MidiChannel;
            Paramater1 = InstrumentNumber;
        }

        //accessor methods
    }
}
