using Data.Models.Repositories;
using Data.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.Infrastructure
{
    public interface IUnitOfWork : IDisposable
    {
        IRepositoryBaseAsync<T> getRepository<T>() where T : class;

        IPlaneRepository PlaneRepository { get; }

        IFlightRepository FlightRepository { get; }

        IAirlineRepository AirlineRepository { get; }
        IEmpAirlineRepository EmpAirlineRepository { get; }
        IReservationRepository ReservationRepository { get; }
        IEmployeeRepository EmployeeRepository { get; }

        IDealRepository DealRepository { get; }



        /* IDirectionRepository DirectionRepository { get; }

         IInvoiceRepository InvoiceRepository { get; }

         IShareRepository ShareRepository { get; }
         IBrokerRepository BrokerRepository { get; }*/
        void CommitAsync();
        void Commit();
    }
}
