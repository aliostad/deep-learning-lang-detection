using System.Collections.Generic;
using System.Linq;
using DrxApi.Models;

namespace DrxApi.Services
{
    public class InstrumentService : IInstrumentService
    {
        private readonly DrxContext _dbContext;

        public InstrumentService(DrxContext dbContext)
        {
            _dbContext = dbContext;
        }

        public IEnumerable<Instrument> ListAll()
        {
            var instruments = _dbContext.Instruments.ToList();
            return instruments.AsEnumerable();
        }

        public Instrument GetById(long id)
        {
            var intstrument = _dbContext.Instruments.FirstOrDefault(x => x.Id == id);
            return intstrument;
        }

        public void Add(Instrument instrument)
        {
            _dbContext.Instruments.Add(instrument);
            _dbContext.SaveChanges();
        }

        public Instrument Update(Instrument instrument)
        {
            var instrument2Update = _dbContext.Instruments.FirstOrDefault(x => x.Id == instrument.Id);

            instrument2Update.Name = instrument.Name;
            
            _dbContext.Update(instrument2Update);
            _dbContext.SaveChanges();

            return instrument2Update;
        }

        public void AddOrUpdate(Instrument instrument)
        {
            var e = _dbContext.Instruments.FirstOrDefault(x => x.Id == instrument.Id);
            if (_dbContext.Instruments.Any(x => x.Id == instrument.Id))
            {
                Update(instrument);                
            }
            else
            {
                Add(instrument); 
            }
        }

        public void Remove(Instrument assay)
        {
            var item = _dbContext.Instruments.First(t => t.Id == assay.Id);
            _dbContext.Instruments.Remove(item);
            _dbContext.SaveChanges();
        }
    }
}