using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LgLcd13.Instruments
{
    public static class InstrumentBuilder
    {
        public static InstrumentPanel CreateInstrumentPanel(string scheme)
        {
            return new InstrumentPanel
            {
                InstrumentLines = GetInstrumentLines(scheme)
            };
        }

        public static List<InstrumentLine> GetInstrumentLines(string scheme)
        {
            var instrumentLines = new List<InstrumentLine>();
            var schemeLines = scheme.Split(';');

            foreach (var line in schemeLines)
            {
                instrumentLines.Add(new InstrumentLine
                {
                    LineNumber = instrumentLines.Count,
                    LineScheme = line,
                    Data = new List<int>
                    {
                        { 0 },
                        { 0 }
                    }
                });
            }

            return instrumentLines;
        } 
    }
}
