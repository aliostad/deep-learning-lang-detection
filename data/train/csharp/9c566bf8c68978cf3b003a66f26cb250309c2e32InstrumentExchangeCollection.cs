using System;
using B4F.TotalGiro.Collections.Persistence;

namespace B4F.TotalGiro.Instruments
{
    /// <summary>
    /// This class holds collection of exchanges for one instrument
    /// The data is retrieved from the database using an instance of the Data Access Library <see cref="T:B4F.TotalGiro.DAL.NHSession">NHSession</see> class.
    /// </summary>
    public class InstrumentExchangeCollection : TransientDomainCollection<IInstrumentExchange>, IInstrumentExchangeCollection
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="T:B4F.TotalGiro.Instruments.InstrumentExchangeCollection">InstrumentExchangeCollection</see> class.
        /// </summary>
        public InstrumentExchangeCollection()
            : base() { }

        public InstrumentExchangeCollection(ITradeableInstrument parent)
            : base()
        {
            Parent = parent;
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="T:B4F.TotalGiro.Instruments.InstrumentExchangeCollection">InstrumentExchangeCollection</see> class.
        /// </summary>
        internal InstrumentExchangeCollection(IExchange exchange, ITradeableInstrument parent)
            : base()
        {
            IInstrumentExchange ie = new InstrumentExchange(parent, exchange, Convert.ToByte(parent.DecimalPlaces));
            Add(ie);
            this.Parent = parent;
        }

        public ITradeableInstrument Parent { get; set; }


        /// <summary>
        /// Get InstrumentExchange by ID
        /// </summary>
        /// <param name="exchangeID">Identifier</param>
        /// <returns>InstrumentExchange object</returns>
        public IInstrumentExchange GetItemByExchange(int exchangeID)
        {
            foreach (IInstrumentExchange instrumentExchange in this)
            {
                if (exchangeID == instrumentExchange.Exchange.Key)
                    return instrumentExchange;
            }
            return null;
        }

        /// <summary>
        /// Get the default InstrumentExchange (by default exchange)
        /// </summary>
        /// <returns>InstrumentExchange object</returns>
        public IInstrumentExchange GetDefault()
        {
            if (this.Parent != null && this.Parent.DefaultExchange != null)
            {
                foreach (IInstrumentExchange instrumentExchange in this)
                {
                    if (instrumentExchange.Exchange.Equals(this.Parent.DefaultExchange))
                        return instrumentExchange;
                }
            }
            return null;
        }
    }
}
