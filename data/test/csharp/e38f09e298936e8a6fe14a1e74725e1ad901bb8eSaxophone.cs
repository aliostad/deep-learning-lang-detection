using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MidiSheetMusic;
namespace Assets.A.Scripts.Instruments
{
    public class Saxophone :  AbstractInstrument
    {
        public override void OnNoteOn(MidiNote[] note,float duration)
        {

        }

        public override void PickUpInstrumentSuccess(float time)
        {
            base.PickUpInstrumentSuccess(time);
          
        }

        public override void RemoveInstrumentSuccess()
        {
            base.RemoveInstrumentSuccess();
        }
    }
}
