using System;
using System.Collections.Generic;
using System.Linq;
using NHibernate.Criterion;
using ThreeBytes.Core.Data.nHibernate.Concrete;
using ThreeBytes.Email.Dashboard.DispatchDaily.Data.Abstract;
using ThreeBytes.Email.Dashboard.DispatchDaily.Data.Abstract.Infrastructure;
using ThreeBytes.Email.Dashboard.DispatchDaily.Entities;

namespace ThreeBytes.Email.Dashboard.DispatchDaily.Data.Concrete
{
    public class DispatchDailyDashboardRepository : KeyedGenericRepository<DashboardDispatchDailyEmail>, IDispatchDailyDashboardRepository
    {
        public DispatchDailyDashboardRepository(IDispatchDailyDashboardDatabaseFactory databaseFactory, IDispatchDailyDashboardUnitOfWork unitOfWork)
            : base(databaseFactory, unitOfWork)
        {
        }

        public int GetTodaysDispatchCount(string applicationName)
        {
            return Session.QueryOver<DashboardDispatchDailyEmail>()
                .Where(x => x.DispatchDate == DateTime.Today)
                .And(x => x.ApplicationName == applicationName)
                .RowCount();
        }

        public int[] GetLastThirtyDaysDispatchCounts(string applicationName)
        {
            var counts = Session.QueryOver<DashboardDispatchDailyEmail>()
                .Select(
                    Projections.Group<DashboardDispatchDailyEmail>(x => x.DispatchDate),
                    Projections.Count<DashboardDispatchDailyEmail>(x => x.DispatchDate))
                .Where(x => x.DispatchDate >= DateTime.Today.AddDays(-30))
                .And(x => x.ApplicationName == applicationName)
                .OrderBy(x => x.DispatchDate).Desc
                .Take(30)
                .List<object[]>();

            var ret = new List<int>();

            if (counts.Count == 30)
                return counts.Select(x => (int)x[1]).ToArray();

            for (int i = 0; i < (30 - counts.Count); i++)
            {
                ret.Add(0);
            }

            ret.AddRange(counts.Select(x => (int)x[1]).ToList());

            return ret.ToArray();
        }
    }
}
