using System;
using DAL.Entities;
using DAL.Repositories.Implementations;

namespace DAL.UoW
{
    /// <summary>
    /// Implementation of the unit of work pattern.
    /// </summary>
    public sealed class UnitOfWork : IDisposable
    {
        private readonly ApplicationContext _context;

        private bool _disposed;
        private CompanyRepository _companyRepository;
        private UserRepository _userRepository;
        private CompanyCommentRepository _companyCommentRepository;
        private CompanyRecallRepository _companyRecallRepository;
        private VacancyRepository _vacancyRepository;
        private AddressRepository _addressRepository;
        private CityRepository _cityRepository;
        private RegionRepository _regionRepository;
        private EventRepository _eventRepository;
        private PublicationRepository _publicationRepository;

        public UnitOfWork()
        {
            _context = new ApplicationContext();
        }

        /// <summary>
        /// Gets a Event repository.
        /// </summary>
        public PublicationRepository Publications => _publicationRepository ?? (_publicationRepository = new PublicationRepository(_context));

        /// <summary>
        /// Gets a Event repository.
        /// </summary>
        public EventRepository Events => _eventRepository ?? (_eventRepository = new EventRepository(_context));

        /// <summary>
        /// Gets a Region repository.
        /// </summary>
        public RegionRepository Regions => _regionRepository ?? (_regionRepository = new RegionRepository(_context));

        /// <summary>
        /// Gets a City repository.
        /// </summary>
        public CityRepository Cities => _cityRepository ?? (_cityRepository = new CityRepository(_context));

        /// <summary>
        /// Gets an Address repository.
        /// </summary>
        public AddressRepository Addresses => _addressRepository ?? (_addressRepository = new AddressRepository(_context));

        /// <summary>
        /// Gets a Vacancies repository.
        /// </summary>
        public VacancyRepository Vacancies => _vacancyRepository ?? (_vacancyRepository = new VacancyRepository(_context));

        /// <summary>
        /// Gets a Company Recall's repository.
        /// </summary>
        public CompanyRecallRepository CompanyRecalls => _companyRecallRepository ?? (_companyRecallRepository = new CompanyRecallRepository(_context));

        /// <summary>
        /// Gets a Company Comment's repository.
        /// </summary>
        public CompanyCommentRepository CompanyComments => _companyCommentRepository ?? (_companyCommentRepository = new CompanyCommentRepository(_context));

        /// <summary>
        /// Gets company's repository.
        /// </summary>
        public CompanyRepository Companies => _companyRepository ?? (_companyRepository = new CompanyRepository(_context));

        /// <summary>
        /// Gets user's repository.
        /// </summary>
        public UserRepository Users => _userRepository ?? (_userRepository = new UserRepository(_context));

        public void SaveChanges()
        {
            _context.SaveChanges();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        private void Dispose(bool disposing)
        {
            if (!_disposed && disposing)
            {
                _context.Dispose();
            }

            _disposed = true;
        }
    }
}