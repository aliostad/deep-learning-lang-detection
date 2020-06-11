using System.Linq;
using System.Data.Entity;
using Tandorosti.Domain.Entities;

namespace Tandorosti.Persistence.Repository
{
    public interface IInstrumentRepository
    {
        IQueryable<Instrument> GetAll();
        void Update(Instrument Instrument);
        void Create(Instrument Instrument);
        void Delete(Instrument Instrument);
      
    }


    public class InstrumentRepository : BaseRepository, IInstrumentRepository
    {
        public InstrumentRepository(IUnitOfWork unitOfWork) : base(unitOfWork)
        {
        }

        public IQueryable<Instrument> GetAll()
        {
            return  GetDbSet<Instrument>();                   
        }


        public void Update(Instrument Instrument)
        {
            SetCurrentValues(GetDbSet<Instrument>().FirstOrDefault(x => x.Id == Instrument.Id), Instrument);
            UnitOfWork.SaveChanges();
        }

        public void Create(Instrument Instrument)
        {
            GetDbSet<Instrument>().Add(Instrument);
            UnitOfWork.SaveChanges();
        }
        public void Delete(Instrument Instrument)
        {
            GetDbSet<Instrument>().Remove(Instrument);
            UnitOfWork.SaveChanges();
        }

       
    }
}