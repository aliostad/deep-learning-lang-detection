using VideoRentDAL.Core;
using VideoRentDAL.Core.Repositories;
using VideoRentDAL.Persistence.Repositories;

namespace VideoRentDAL.Persistence
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly VideoRentContext _context;

        private ICustomerRepository _customerRepository;

        private IGenreRepository _genreRepository;

        private IMembershipTypeRepository _membershipTypeRepository;

        private IMovieRepository _movieMovieRepository;

        private IRentalRepository _rentalRepository;


        public UnitOfWork(string connString)
        {
            _context = new VideoRentContext(connString);
            
        }

        public IMovieRepository MoviesRepository => _movieMovieRepository ??
                                                   (_movieMovieRepository = new MovieRepository(_context));

        public ICustomerRepository CustomersRepository => _customerRepository ??
                                                   (_customerRepository = new CustomerRepository(_context));

        public IMembershipTypeRepository MembershipTypeRepository => _membershipTypeRepository ??
                                                   (_membershipTypeRepository = new MembershipTypeRepository(_context));

        public IRentalRepository RentalRepository => _rentalRepository ??
                                                   (_rentalRepository = new RentalRepository(_context));

        public IGenreRepository GenreRepository => _genreRepository ??
                                                   (_genreRepository = new GenreRepository(_context));

        public int Complete()
        {
            return _context.SaveChanges();
        }
        
        public void Dispose()
        {
            _context.Dispose();
        }
    }
}