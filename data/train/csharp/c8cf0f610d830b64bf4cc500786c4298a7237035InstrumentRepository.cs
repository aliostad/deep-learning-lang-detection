using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;

using Fin.Data.Common.Repository;
using Fin.Data.Model;
using Fin.Business.Common.Model;

namespace Fin.Data.Repository
{
    public class InstrumentRepository: IInstrumentRepository
    {
        private FinContext _context;
        private DbSet<Instrument> _set;

        public InstrumentRepository(FinContext context)
        {
            _context = context;
            _set = _context.Set<Instrument>();
        }

        public IQueryable<IInstrument> GetAll()
        {
            return _set.AsQueryable();
        }

        public IInstrument GetById(int id)
        {
            return (IInstrument)_set.Find(id);
        }

        public void Insert(IInstrument instrument)
        {
            _set.Add((Instrument)instrument);
        }

        public void Update(IInstrument instrument)
        {
            _set.Attach((Instrument)instrument);
            _context.Entry(instrument).State = EntityState.Modified;
        }

        public void Delete(IInstrument instrument)
        {
            if (_context.Entry(instrument).State == EntityState.Detached)
                _set.Attach((Instrument)instrument);
            _set.Remove((Instrument)instrument);
        }

    }
}
