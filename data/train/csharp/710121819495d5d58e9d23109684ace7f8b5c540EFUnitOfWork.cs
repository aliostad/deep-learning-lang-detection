namespace Cinema.Data.Infrastructure
{
    using System;
    using System.Data.Entity;
    using System.Data.Entity.Validation;

    using Context.Sources;
    using Domain;


    public class EFUnitOfWork : IUnitOfWork
    {
        public EFUnitOfWork() : this(new CinemaContext()) { }

        public EFUnitOfWork(CinemaContext context) 
        {
            Context = context;
        }

        public CinemaContext Context { get; private set; }

        
        #region IDisposable && Dispose(bool)

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);  // GarbageCollector, do not bother to check me!
        }


        private bool _disposed;

        private void Dispose(bool disposing)
        {
            if (Context != null && !_disposed && disposing)
            {
                Context.Dispose();
            }

            _disposed = true;
        }

        #endregion

        #region IUnitOfWork members EFGenericRepository<T>

        private EFGenericRepository<Booking> _bookingRepository;
        private EFGenericRepository<Hall> _hallRepository;
        private EFGenericRepository<LoginToken> _loginTokenRepository;
        private EFGenericRepository<MovieInfo> _movieInfoRepository;
        private EFGenericRepository<Movie> _movieRepository;
        private EFGenericRepository<ScreeningInfo> _screeningInfoRepository;
        private EFGenericRepository<Screening> _screeningRepository;
        private EFGenericRepository<Seat> _seatRepository;
        private EFGenericRepository<Ticket> _ticketRepository;
        private EFGenericRepository<TicketType> _ticketTypeRepository;
        private EFGenericRepository<User> _userRepository;

        public IGenericRepository<Booking> BookingRepository
        {
            get
            {
                _bookingRepository = _bookingRepository ?? new EFGenericRepository<Booking>(Context);
                return _bookingRepository;
            }
        }

        public IGenericRepository<Hall> HallRepository
        {
            get
            {
                _hallRepository = _hallRepository ?? new EFGenericRepository<Hall>(Context);
                return _hallRepository;
            }
        }

        public IGenericRepository<LoginToken> LoginTokenRepository
        {
            get
            {
                _loginTokenRepository = _loginTokenRepository ?? new EFGenericRepository<LoginToken>(Context);
                return _loginTokenRepository;
            }
        }

        public IGenericRepository<MovieInfo> MovieInfoRepository
        {
            get
            {
                _movieInfoRepository = _movieInfoRepository ?? new EFGenericRepository<MovieInfo>(Context);
                return _movieInfoRepository;
            }
        }

        public IGenericRepository<Movie> MovieRepository
        {
            get
            {
                _movieRepository = _movieRepository ?? new EFGenericRepository<Movie>(Context);
                return _movieRepository;
            }
        }

        public IGenericRepository<ScreeningInfo> ScreeningInfoRepository
        {
            get
            {
                _screeningInfoRepository = _screeningInfoRepository ?? new EFGenericRepository<ScreeningInfo>(Context);
                return _screeningInfoRepository;
            }
        }

        public IGenericRepository<Screening> ScreeningRepository
        {
            get
            {
                _screeningRepository = _screeningRepository ?? new EFGenericRepository<Screening>(Context);
                return _screeningRepository;
            }
        }

        public IGenericRepository<Seat> SeatRepository
        {
            get
            {
                _seatRepository = _seatRepository ?? new EFGenericRepository<Seat>(Context);
                return _seatRepository;
            }
        }

        public IGenericRepository<Ticket> TicketRepository
        {
            get
            {
                _ticketRepository = _ticketRepository ?? new EFGenericRepository<Ticket>(Context);
                return _ticketRepository;
            }
        }

        public IGenericRepository<TicketType> TicketTypeRepository
        {
            get
            {
                _ticketTypeRepository = _ticketTypeRepository ?? new EFGenericRepository<TicketType>(Context);
                return _ticketTypeRepository;
            }
        }

        public IGenericRepository<User> UserRepository
        {
            get
            {
                _userRepository = _userRepository ?? new EFGenericRepository<User>(Context);
                return _userRepository;
            }
        }

        #endregion

        public void Save()
        {
            Context.SaveChanges();  //try-catch if want to save errors in db/file  then throw so it can me catched by wcf
        }
    }
}
