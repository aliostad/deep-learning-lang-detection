using System.Collections.Generic;
using DomainModel.Model;
using Repositories.Repositories;

namespace FakeRepositories
{
    public class FakeInstrumentRepository : IInstrumetRepository

    {
        public List<Instrument> GetAll()
        {
            List<Instrument> instruments = new List<Instrument>();

            instruments.Add(new Instrument
            {
                InstrumentID = "125365",
                Symbol = "ALK1234",
                Isin = "DK0006332168",
                Name = "DLR 2012 2% 01/10/17",
                QuotedIn = Instrument.QuotedInEnum.Price
            });
            instruments.Add(new Instrument
            {
                InstrumentID = "125365",
                Symbol = "DHL1234",
                Isin = "DK1006332169",
                Name = "DHL 2012 2% 01/10/17",
                QuotedIn = Instrument.QuotedInEnum.Price
            });
            instruments.Add(new Instrument
            {
                InstrumentID = "125365",
                Symbol = "MGA1234",
                Isin = "DK2006332174",
                Name = "MGA 2012 2% 01/10/17",
                QuotedIn = Instrument.QuotedInEnum.Yield
            });

            return instruments;
        }
    }
}
