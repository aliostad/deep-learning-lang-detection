using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using XmlBuilder.InstrumentModel;

namespace XmlBuilder.DataLoader
{
    public class InstrumentDataLoader
    {
        public InstrumentDataLoader() 
        {
        
        }

        internal List<Instrument> loadInstrument()
        {
            List<Instrument> instList = new List<Instrument>();

            for (int i = 0; i < 20; i++)
            {
                string name = "ELS_" + Convert.ToString(i);
                instList.Add(new Instrument(name));
            }

            return instList;
        }
    }
}
