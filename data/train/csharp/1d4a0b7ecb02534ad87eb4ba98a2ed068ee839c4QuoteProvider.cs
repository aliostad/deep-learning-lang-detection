using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Linq;

namespace Core.TransactionServer.Agent.PriceAlert
{
    internal sealed class QuoteProvider : IQuotePolicySetterProvider, IQuotationSetterProvider
    {
        internal static readonly QuoteProvider Default = new QuoteProvider();

        static QuoteProvider() { }
        private QuoteProvider() { }

        IQuotePolicySetter IQuotePolicySetterProvider.Get(Guid customerId)
        {
            return Settings.Setting.Default.GetCustomer(customerId);
        }

        IQuotationSetter IQuotationSetterProvider.Get(Guid instrumentId)
        {
            return Settings.Setting.Default.GetInstrument(instrumentId);
        }
    }


    //internal sealed class AlertInstrumentPool
    //{
    //    private object _mutex = new object();
    //    private Queue<AlertInstrument> _queue = new Queue<AlertInstrument>(50);

    //    internal static readonly AlertInstrumentPool Default = new AlertInstrumentPool();

    //    static AlertInstrumentPool() { }
    //    private AlertInstrumentPool() { }

    //    internal void Push(AlertInstrument instrument)
    //    {
    //        lock (_mutex)
    //        {
    //            _queue.Enqueue(instrument);
    //        }
    //    }

    //    internal AlertInstrument Pop()
    //    {
    //        lock (_mutex)
    //        {
    //            if (_queue.Count == 0) return null;
    //            return _queue.Dequeue();
    //        }
    //    }

    //}


}
