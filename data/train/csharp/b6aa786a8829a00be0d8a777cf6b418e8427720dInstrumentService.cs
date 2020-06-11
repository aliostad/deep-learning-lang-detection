using System;
using System.Collections.Generic;
using System.Linq;
using Tandorosti.Domain.Entities;
using Tandorosti.Domain.Entities.AspNetIdentity;
using Tandorosti.Domain.Enumeration;
using Tandorosti.Persistence.Repository;

namespace Tandorosti.DomainService.CoreServices
{

    public interface IInstrumentService
    {       
        IQueryable<Instrument> GetAll();
        void Update(Instrument Instrument);
        void Create(Instrument Instrument);
        void Delete(Instrument Instrument);
    }

    public class InstrumentService : IInstrumentService
    {
        private readonly IInstrumentRepository _InstrumentRepository;
       
        public InstrumentService(IInstrumentRepository InstrumentRepository)
        {
            _InstrumentRepository = InstrumentRepository;
          
        }


        public IQueryable<Instrument> GetAll()
        {
            return _InstrumentRepository.GetAll();
        }


        public void Update(Instrument Instrument)
        {
            //var item = _InstrumentRepository.GetAll().FirstOrDefault(x => x.Id == Instrument.Id);
            _InstrumentRepository.Update(Instrument);
        }

        public void Create(Instrument Instrument)
        {
            _InstrumentRepository.Create(Instrument);

        }
        public void Delete(Instrument Instrument)
        {
            _InstrumentRepository.Delete(Instrument);
        }

    }
}