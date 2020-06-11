using System;
using Csla;

namespace Bd.Icm.Criteria
{
    [Serializable]
    public class InstrumentPartChangesCriteria : CriteriaBase<InstrumentPartChangesCriteria>
    {
        public int InstrumentId { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }

        public InstrumentPartChangesCriteria(int instrumentId, DateTime? startDate, DateTime? endDate)
        {
            InstrumentId = instrumentId;
            StartDate = startDate;
            EndDate = endDate;
        }
    }
}
