using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Locker.Infrastructure.Repositories.Interface
{
    public interface ILockerUnitOfWork
    {
        ICustomerRepository CustomerRepository { get; }

        ICustomerActivityRepository CustomerActivityRepository { get; }
        
        ILockerRepository LockerRepository { get; }

        ILockerBlockRepository LockerBlockRepository { get; }

        IUserRepository UserRepository { get; }

        ISectorRepository SectorRepository { get; }

        ISectorLocationRepository SectorLocationRepository { get; }

        ITraderRepository TraderRepository { get; }

        ILockerReportRepository ReportRepository { get; }

        void Dispose();

        void Commit();
    }
}
