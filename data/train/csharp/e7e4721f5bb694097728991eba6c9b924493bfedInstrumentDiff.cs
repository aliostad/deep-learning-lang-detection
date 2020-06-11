using System.Collections.Generic;

namespace Bd.Icm.Web.Dto
{
    public class InstrumentDiff
    {
        public IList<Part> DeletedParts { get; set; } 
        public IList<Part> AddedParts { get; set; }
        public IList<PartVersion> ModifiedParts { get; set; }
        public Instrument FromInstrument { get; set; }
        public Instrument ToInstrument { get; set; }

        public InstrumentCommit FromCommit { get; set; }
        public InstrumentCommit ToCommit { get; set; }

        public InstrumentDiff()
        {
            DeletedParts = new List<Part>();
            AddedParts = new List<Part>();
            ModifiedParts = new List<PartVersion>();
        }
    }
}
