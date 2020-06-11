using BinaryOptions.DAL.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BinaryOption.DAL.Repositories
{
    public class InstrumentRateRepository
    {
        private readonly Dictionary<Guid, List<InstrumentRate>> m_cache;

        public InstrumentRateRepository()
        {
            m_cache = new Dictionary<Guid, List<InstrumentRate>>();
        }

        public void UpdateRate(InstrumentRate instrumentRate)
        {
            if (!m_cache.ContainsKey(instrumentRate.Id))
            {
                m_cache.Add(instrumentRate.Id, new List<InstrumentRate>());
            }
            m_cache[instrumentRate.Id].Add(instrumentRate);
        }

        public IList<InstrumentRate> GetInstrumentById(Guid instrumentId) 
        {
            return m_cache[instrumentId];
        }

    }

}
