using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Kite.Automation
{
    public class InstrumentInfo
    {
        public int InstrumentToken { get; set; }
        public string Name { get; set; }
        public string Exchange { get; set; }
        public string FormalName { get { return "[{2}]{0}:{1}".FormatEx(Exchange, Name, InstrumentToken); } }

        public InstrumentInfo()
        { }

        public InstrumentInfo(int instrumentToken, string name, string exchange)
        {
            this.InstrumentToken = instrumentToken;
            this.Name = name;
            this.Exchange = exchange;
        }

        public override string ToString()
        {
            return "[{2}]{0}:{1}".FormatEx(Exchange, Name, InstrumentToken);
        }

        public InstrumentInfo Clone()
        {
            return new InstrumentInfo(this.InstrumentToken, this.Name, this.Exchange);
        }
    }
}
