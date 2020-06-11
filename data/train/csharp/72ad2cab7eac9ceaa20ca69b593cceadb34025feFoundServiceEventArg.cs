using System;
using System.Collections.Generic;
using System.Text;

namespace UV.Lib.MarketHubs
{
    public class FoundServiceEventArg : EventArgs
    {
        //
        // ****                 Members                     ****
        //
        public List<Products.Product> FoundProducts;
        public List<Products.InstrumentName> FoundInstruments;
        public List<Products.InstrumentName> FoundInstrumentMarkets;
        public List<Products.InstrumentName> FoundInstrumentBooks;

    }//end class
}
