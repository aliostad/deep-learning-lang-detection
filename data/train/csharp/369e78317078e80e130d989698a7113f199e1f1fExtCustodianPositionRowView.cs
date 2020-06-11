using System;
using System.Collections.Generic;
using System.Text;
using B4F.TotalGiro.Instruments;

namespace B4F.TotalGiro.ApplicationLayer.DataMaintenance
{
    public class ExtCustodianPositionRowView
    {
        private int instrumentId;
        private string isin;
        private string instrumentName;
        private decimal size;

        public ExtCustodianPositionRowView(ITradeableInstrument instrument, decimal size)
        {
            this.instrumentId = instrument.Key;
            this.isin = instrument.Isin;
            this.instrumentName = instrument.Name;
            this.size = size;
        }

        public int Key { get { return this.instrumentId; } }
        public string Isin { get { return this.isin; } }
        public string InstrumentName { get { return this.instrumentName; } }
        public decimal Size
        {
            get { return this.size; } 
            set { this.size = value; } 
        }

    }
}
