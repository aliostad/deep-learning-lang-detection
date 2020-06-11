using StorageControl.DataAccess.Builders;
using StorageControl.DataAccess.Repositories.Abstractions;
using StorageControl.Domain.Contracts.Interfaces;
using StorageControl.Domain.Model.Entities;
using System.Collections.Generic;

namespace StorageControl.DataAccess.Repositories
{
    public class InstrumentTypesRepository : Repository, IInstrumentTypesRepository
    {
        public int Create(InstrumentType instrumentType)
        {
            return base.Create("create_instrument_type",
                instrumentType.ToParameterizedObject(true));
        }

        public int Delete(int id)
        {
            return base.Delete("delete_instrument_type",
                new { @id = id });
        }

        public InstrumentType Get(int id)
        {
            return base.Get<InstrumentType>("get_instrument_type", new { @id = id });
        }

        public IEnumerable<InstrumentType> List()
        {
            return base.List<InstrumentType>("list_instrument_types");
        }

        public int Update(InstrumentType instrumentType)
        {
            return base.Update("update_instrument_type",
                instrumentType.ToParameterizedObject(false));
        }
    }
}
