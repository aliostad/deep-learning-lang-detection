using System;
using BookingSystem.DataAccess.Abstract;
using BookingSystem.Entities;

namespace BookingSystem.DataAccess.Concrete
{
    public class UnitOfWork : IUnitOfWork, IDisposable
    {
        #region Fields

        private readonly BookingSystemContext _context = new BookingSystemContext();

        private BusRepository _busRepository;
        private DriverRepository _driverRepository;
        private JourneyRepository _journeyRepository;
        private PassengerRepository _passengerRepository;
        private RoutePointRepository _routePointRepository;
        private RouteRepository _routeRepository;
        private TicketRepository _ticketRepository;
        private TrafficRepository _trafficRepository;
        private AdministratorRepository _administratorRepository;

        // used by Dispose() to avoid redundant method calls
        private bool _disposed;

        #endregion

        #region Properties

        public IBusRepository BusRepository => _busRepository ?? (_busRepository = new BusRepository(_context));

        public IDriverRepository DriverRepository => _driverRepository ??
                                                     (_driverRepository = new DriverRepository(_context));

        public IJourneyRepository JourneyRepository => _journeyRepository ??
                                                       (_journeyRepository = new JourneyRepository(_context));

        public IPassengerRepository PassengerRepository => _passengerRepository ??
                                                           (_passengerRepository = new PassengerRepository(_context));

        public IRoutePointRepository RoutePointRepository => _routePointRepository ??
                                                             (_routePointRepository = new RoutePointRepository(_context));

        public IRouteRepository RouteRepository => _routeRepository ??
                                                   (_routeRepository = new RouteRepository(_context));

        public ITicketRepository TicketRepository => _ticketRepository ??
                                                     (_ticketRepository = new TicketRepository(_context));

        public ITrafficRepository TrafficRepository => _trafficRepository ??
                                                       (_trafficRepository = new TrafficRepository(_context));

        public IAdministratorRepository AdministratorRepository => _administratorRepository ??
                                                                   (_administratorRepository = new AdministratorRepository(_context));

        #endregion

        #region Disposable Implementation

        protected virtual void Dispose(bool disposing)
        {
            if (_disposed)
                return;

            if (disposing)
            {
                _context.Dispose();
            }
            _disposed = true;
        }

        public virtual void Dispose()
        {
            Dispose(true);
        }

        #endregion
    }
}
