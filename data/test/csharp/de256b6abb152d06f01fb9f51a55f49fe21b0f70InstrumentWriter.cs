using com.wer.sc.plugin.market;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace com.wer.sc.data.receiver
{
    public class InstrumentWriter
    {
        private string path;

        public InstrumentWriter(string path)
        {
            this.path = path;
        }

        public void Writer(List<InstrumentInfo> instruments)
        {
            //JsonUtils_Instrument.Save()
        }

        public List<InstrumentInfo> Load()
        {
            return null;
        }
    }
}
