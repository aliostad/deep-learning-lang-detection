using System;
using System.Collections.Generic;
using LQT.Core.Domain;
using LQT.Core.DataAccess.Interface;
using NHibernate;
using LQT.Core.Util;

namespace LQT.Core.DataAccess.NHibernate
{
    public class NHInstrumentDao : NHibernateDao<Instrument>, IInstrumentDao
    {
        public Instrument GetInstrumentByName(string name)
        {
            string hql = "from Instrument i where i.InstrumentName = :iname";

            ISession session = NHibernateHelper.OpenSession();
            IQuery q = session.CreateQuery(hql);
            q.SetString("iname", name);

            IList<Instrument> result = q.List<Instrument>();

            if (result.Count > 0)
                return result[0];

            return null;
        }

        public Instrument GetInstrumentByNameAndTestingArea(string name, int testingAreaId)
        {
            string hql = "from Instrument i where i.InstrumentName = :iname and i.TestingArea.Id = :testingAreaId";

            ISession session = NHibernateHelper.OpenSession();
            IQuery q = session.CreateQuery(hql);
            q.SetString("iname", name);
            q.SetInt32("testingAreaId", testingAreaId);

            IList<Instrument> result = q.List<Instrument>();

            if (result.Count > 0)
                return result[0];

            return null;
        }

        public IList<Instrument> GetListOfInstrumentByTestingArea(int testingAreaId)
        {
            string hql = "from Instrument i where i.TestingArea.Id = :testingAreaId";

            ISession session = NHibernateHelper.OpenSession();
            IQuery q = session.CreateQuery(hql);
            q.SetInt32("testingAreaId", testingAreaId);

            return q.List<Instrument>();
        }

        public IList<Instrument> GetListOfInstrumentByTestingArea(string classofTest)
        {
            string hql = "from Instrument i where i.TestingArea.Category = :category";

            ISession session = NHibernateHelper.OpenSession();
            IQuery q = session.CreateQuery(hql);
            q.SetString("category", classofTest);

            return q.List<Instrument>();
        }
    }
}
