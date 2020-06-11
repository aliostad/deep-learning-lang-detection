using System;
using Csla;

namespace Bd.Icm.Criteria
{
    [Serializable]
    public class InstrumentPartSearchCriteria : CriteriaBase<InstrumentPartSearchCriteria>
    {
        public int InstrumentId { get; set; }
        public string SearchKey { get; set; }
        public int Version { get; set; }

        public InstrumentPartSearchCriteria(int instrumentId, int version, string searchKey)
        {
            InstrumentId = instrumentId;
            Version = version;
            SearchKey = searchKey;
        }
    }
}
