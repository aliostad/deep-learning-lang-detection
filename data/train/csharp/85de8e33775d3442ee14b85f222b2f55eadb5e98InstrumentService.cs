using LocationInstrument.Domain;
using LocationInstrument.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LocationInstrument.Service
{
    public class InstrumentService
    {
        private LocationInstrumentContext dbContext = new LocationInstrumentContext();

        public void AddInstrument(Instrument instrument)
        {
            dbContext.Instruments.Add(instrument);
            dbContext.SaveChanges();
        }

        public IEnumerable<Instrument> GetAllInstruments()
        {
            return dbContext.Instruments;
        }

        public Instrument GetInstrument(int? numSerie)
        {
            return dbContext.Instruments.Single(x => x.numSerie == numSerie);
        }

        public IEnumerable<Instrument> GetInstrumentLocationDemain()
        {
            return dbContext.Instruments.Where(x => x.locations.Any(y => y.dateLocation.DayOfYear == DateTime.Now.DayOfYear + 1));
        }

        public IEnumerable<Instrument> GetLocationForInstrument(int? numSerie)
        {
            return dbContext.Instruments.Where(x => x.numSerie == numSerie);
        }
    }
}
