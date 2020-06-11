using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Labs.Model
{
    public class InstrumentService : IInstrumentService
    {
        public void GetModel(Action<Instrument, Exception> callback)
        {
            var item = new Instrument() { Title= "Instrument",
                 Instrument1=GetInstrumentDisplayInfo(),
                Instrument2 = GetInstrumentDisplayInfo(),
                Instrument3 = GetInstrumentDisplayInfo(),
                Instrument4 = GetInstrumentDisplayInfo()

            };
            callback(item, null);
        }


        private InstrumentDisplayInfo GetInstrumentDisplayInfo()
        {
            return new InstrumentDisplayInfo()
            {
                MethodName = string.Empty,
                FlaskPath = "laboratory - icon32.png",
                InstrmentPath=string.Empty,  
                DueDate = DateTime.Now.ToLongDateString(),
                Count = 0
            };
        }
    }
}
