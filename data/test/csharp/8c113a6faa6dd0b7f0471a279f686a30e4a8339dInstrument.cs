using ScalesOnGuitar;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ScalesOnGuitar
{
    enum InstrumentType
    {
        Guitar,
        Bass
    }

    class Instrument
    {
        public InstrumentType InstrumentType;
        public int NumberOfStrings;
        public TuningType Tuning;

        public List<String> StringsOfInstrument = new List<String>();

        public Instrument(InstrumentType type, int numberOfStrings, TuningType tuning)
        {
            InstrumentType = type;
            NumberOfStrings = numberOfStrings;
            Tuning = tuning;

            switch (InstrumentType)
            {
                case InstrumentType.Guitar:
                    switch (NumberOfStrings)
                    {
                        case 6:
                            StringsOfInstrument.Add(new String(AllBaseNotes.E));
                            StringsOfInstrument.Add(new String(AllBaseNotes.A));
                            StringsOfInstrument.Add(new String(AllBaseNotes.D));
                            StringsOfInstrument.Add(new String(AllBaseNotes.G));
                            StringsOfInstrument.Add(new String(AllBaseNotes.H));
                            StringsOfInstrument.Add(new String(AllBaseNotes.E));
                            break;
                        case 7:
                            StringsOfInstrument.Add(new String(AllBaseNotes.H));
                            goto case 6;
                    }
                    break;
                case InstrumentType.Bass:
                    switch (NumberOfStrings)
                    {
                        case 4:
                            StringsOfInstrument.Add(new String(AllBaseNotes.E));
                            StringsOfInstrument.Add(new String(AllBaseNotes.A));
                            StringsOfInstrument.Add(new String(AllBaseNotes.D));
                            StringsOfInstrument.Add(new String(AllBaseNotes.G));
                            break;
                        case 5:
                            StringsOfInstrument.Add(new String(AllBaseNotes.H));
                            goto case 4;
                        case 6:
                            StringsOfInstrument.Add(new String(AllBaseNotes.H));
                            StringsOfInstrument.Add(new String(AllBaseNotes.E));
                            StringsOfInstrument.Add(new String(AllBaseNotes.A));
                            StringsOfInstrument.Add(new String(AllBaseNotes.D));
                            StringsOfInstrument.Add(new String(AllBaseNotes.G));
                            StringsOfInstrument.Add(new String(AllBaseNotes.C));
                            break;
                    }
                    break;
            }

            switch (tuning)
            {
                    case TuningType.DropD:
                        StringsOfInstrument[0] = new String(AllBaseNotes.D);
                        break;
                    case TuningType.Standard:
                        break;
            }

        }

        public Instrument(InstrumentType type, int numberOfStrings)
        {
            InstrumentType = type;
            NumberOfStrings = numberOfStrings;
        }
    }
}
