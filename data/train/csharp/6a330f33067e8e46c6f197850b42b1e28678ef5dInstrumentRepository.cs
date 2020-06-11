using Exchange.Core.Models;
using Exchange.Core.Utils;
using NHibernate;
using NHibernate.Criterion;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Exchange.Core.Dao
{

    public interface IInstrumentRepository
    {
        List<InstrumentHistory> FindInstrumentHistoriesBy(Guid instrumentId, DateTime startDate, DateTime endDate, ScopeKind scope);

        List<InstrumentHistory> FindInstrumentHistoriesBy(DateTime startDate, DateTime endDate, ScopeKind scope);
    }

    public class InstrumentRepository : IInstrumentRepository
    {
        private IGenericDAO<Instrument> _instrumetnDAO;
        private IGenericDAO<InstrumentHistory> _instrumetnHistoryDAO;

        public InstrumentRepository()
        {
        }

        public InstrumentRepository(IGenericDAO<Instrument> instrumetnDAO, IGenericDAO<InstrumentHistory> instrumetnHistoryDAO)
        {
            _instrumetnDAO = instrumetnDAO;
            _instrumetnHistoryDAO = instrumetnHistoryDAO;
        }




        public List<InstrumentHistory> FindInstrumentHistoriesBy(Guid instrumentId, DateTime startDate, DateTime endDate, ScopeKind scope)
        {           
            using (var session = NHibernateHelper.OpenSession())
            {
                return (List<InstrumentHistory>) session
                        .CreateCriteria(typeof(InstrumentHistory))
                        .CreateAlias("Instrument",  "Instrument")                        
                        .Add(Restrictions.Between("DateStamp", startDate, endDate))
                        .Add(Restrictions.Eq("Scope", scope))
                        .Add(Restrictions.Eq("Instrument.Id", instrumentId))
                        .List<InstrumentHistory>();
            }
        }



        public List<InstrumentHistory> FindInstrumentHistoriesBy(DateTime startDate, DateTime endDate, ScopeKind scope)
        {
            using (var session = NHibernateHelper.OpenSession())
            {
                return (List<InstrumentHistory>)session
                        .CreateCriteria(typeof(InstrumentHistory))
                        .Add(Restrictions.Between("DateStamp", startDate, endDate))
                        .Add(Restrictions.Eq("Scope", scope))
                        .SetFetchMode("Instrument", FetchMode.Eager)
                        .List<InstrumentHistory>();
            }
        }
    }
}
