
namespace BSO.Archive.DTO
{
    public class InstrumentDTO
    {
        public string Instrument1 { get; set; }

        public InstrumentDTO(string instrument)
        {
            Instrument1 = instrument ?? "";
        }

        
        public InstrumentDTO(int? instrumentId)
        {
            if (!instrumentId.HasValue)
                Instrument1 = string.Empty;
            else
            {
                var instrument = Bso.Archive.BusObj.Instrument.GetInstrumentByID(instrumentId.Value);
                Instrument1 = instrument.Instrument1;
            }
        }
    }
}
