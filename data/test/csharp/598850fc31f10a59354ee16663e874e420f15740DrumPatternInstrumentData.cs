using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ODM_DataManagerLibrary.DrumPatterns
{
    public class DrumPatternInstrumentData
    {
        internal string Name { get; set; }
        internal bool[] InstrumentData;

        public DrumPatternInstrumentData(string instrumentName)
        {
            Name = instrumentName;
            InstrumentData = new bool[32];
        }

        internal void UpdateDataAtIndex(bool v, int i)
        {
            InstrumentData[i] = v;
        }
    }
}
