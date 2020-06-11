using DataAccessLayer.Repository;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DataAccessLayer
{
    public class UnitOfWork
    {
        MyTicketContext _context;
        public UnitOfWork()
        {
            _context = new MyTicketContext();
        }

        private UserRepository _userRepository;
        public UserRepository UserRepository {

            get {
                if (_userRepository==null)
                {
                    _userRepository = new UserRepository(_context);
                }
                return _userRepository;
            }
        }
        private CustomerRepository _userProfileRepository;
        public CustomerRepository UserProfileRepository
        {

            get
            {
                if (_userProfileRepository == null)
                {
                    _userProfileRepository = new CustomerRepository(_context);
                }
                return _userProfileRepository;
            }
        }
        private BusRepository _busRepository;
        public BusRepository BusRepository
        {

            get
            {
                if (_busRepository == null)
                {
                    _busRepository = new BusRepository(_context);
                }
                return _busRepository;
            }
        }
        private CityRepository _cityRepository;
        public CityRepository CityRepository
        {

            get
            {
                if (_cityRepository == null)
                {
                    _cityRepository = new CityRepository(_context);
                }
                return _cityRepository;
            }
        }
        private RouteRepository _routeRepository;
        public RouteRepository RouteRepository
        {

            get
            {
                if (_routeRepository == null)
                {
                    _routeRepository = new RouteRepository(_context);
                }
                return _routeRepository;
            }
        }


        private ScheduleRepository _scheduleRepository;
        public ScheduleRepository ScheduleRepository
        {

            get
            {
                if (_scheduleRepository == null)
                {
                    _scheduleRepository = new ScheduleRepository(_context);
                }
                return _scheduleRepository;
            }
        }
        private ScheduleTimeRepository _scheduleTimeRepository;
        public ScheduleTimeRepository ScheduleTimeRepository
        {

            get
            {
                if (_scheduleTimeRepository == null)
                {
                    _scheduleTimeRepository = new ScheduleTimeRepository(_context);
                }
                return _scheduleTimeRepository;
            }
        }

        private TicketRepository _ticketRepository;
        public TicketRepository TicketRepository
        {

            get
            {
                if (_ticketRepository == null)
                {
                    _ticketRepository = new TicketRepository(_context);
                }
                return _ticketRepository;
            }
        }
        private TicketDetailsRepository _ticketDetailsRepository;
        public TicketDetailsRepository TicketDetailsRepository
        {

            get
            {
                if (_ticketDetailsRepository == null)
                {
                    _ticketDetailsRepository = new TicketDetailsRepository(_context);
                }
                return _ticketDetailsRepository;
            }
        }


        public bool ApplyChanges()
        {
            bool isSuccess = false;
            DbContextTransaction _tran;
            _tran = _context.Database.BeginTransaction(System.Data.IsolationLevel.ReadCommitted);
            try
            {
                _context.SaveChanges();
                _tran.Commit();
                isSuccess = true;
            }
            catch (Exception ex)
            {
                _tran.Rollback();
                isSuccess = false;
            }
            finally
            {
                _tran.Dispose();
            }
            return isSuccess;
        }






    }
}
