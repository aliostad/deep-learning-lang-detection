using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Core.TransactionServer.Layout
{
    internal sealed class InstrumentMapping
    {
        private Dictionary<Guid, List<LayoutInstrument>> _mapping = new Dictionary<Guid, List<LayoutInstrument>>(20);

        public List<LayoutInstrument> Get(Guid instrumentId)
        {
            List<LayoutInstrument> result;
            _mapping.TryGetValue(instrumentId, out result);
            return result;
        }
    }
}
