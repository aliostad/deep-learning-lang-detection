using System;
using SportLife.Core.Database;
using SportLife.Core.Interfaces;
using SportLife.Core.SportLifeRepositories;
using SportLife.Core.SportLifeRepositories.Interfaces;

namespace SportLife.Core.Generic {
    public class UnitOfWork : IUnitOfWork {

        private readonly SportLifeEntities _dbEntities = new SportLifeEntities();
        private bool _disposed;

        private IAbonementOrderRepository _abonementOrderRepository;
        private IAbonementRepository _abonementRepository;
        private IClientRepository _clientRepository;
        private ICoachRepository _coachRepository;
        private IDaysInWeekRepository _daysInWeekRepository;
        private IImageRepository _imageRepository;
        private IFileTypeRepository _fileTypeRepository;
        private IHallRepository _hallRepository;
        private IPriceRepository _priceRepository;
        private ISheduleRepository _sheduleRepository;
        private ISportGroupRepository _sportGroupRepository;
        private ISportCategoryRepository _categoryRepository;
        private ISportRepository _sportRepository;
        private IUserRepository _userRepository;
        private IVisitingRepository _visitingRepository;

        public IAbonementOrderRepository AbonementOrderRepository { get; }
        public IAbonementRepository AbonementRepository { get; }

        public IClientRepository ClientRepository
            => _clientRepository ?? (_clientRepository = new ClientRepository(_dbEntities));

        public ICoachRepository CoachRepository
            => _coachRepository ?? (_coachRepository = new CoachRepository(_dbEntities));

        public IDaysInWeekRepository DaysInWeekRepository
            => _daysInWeekRepository ?? (_daysInWeekRepository = new DayInWeekRepository(_dbEntities));

        public IImageRepository ImageRepository
            => _imageRepository ?? (_imageRepository = new ImageRepository(_dbEntities));

        public IFileTypeRepository FileTypeRepository
            => _fileTypeRepository ?? (_fileTypeRepository = new FileTypeRepository(_dbEntities));

        public IHallRepository HallRepository
            => _hallRepository ?? (_hallRepository = new HallRepository(_dbEntities));

        public IPriceRepository PriceRepository { get; }

        public ISheduleRepository SheduleRepository
            => _sheduleRepository ?? (_sheduleRepository = new SheduleRepository(_dbEntities));

        public ISportCategoryRepository SportCategoryRepository
            => _categoryRepository ?? (_categoryRepository = new SportCategoryRepository(_dbEntities));

        public ISportGroupRepository SportGroupRepository
            => _sportGroupRepository ?? (_sportGroupRepository = new SportGroupRepository(_dbEntities));

        public ISportRepository SportRepository
            => _sportRepository ?? (_sportRepository = new SportRepository(_dbEntities));

        public IUserRepository UserRepository
            => _userRepository ?? (_userRepository = new UserRepository(_dbEntities));

        public IVisitingRepository VisitingRepository { get; }

        public void Dispose () {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public void SaveChanges () {
            _dbEntities.SaveChanges();
        }

        protected virtual void Dispose ( bool disposing ) {
            if ( !_disposed ) {
                if ( disposing ) {
                    _dbEntities.Dispose();
                }
            }
            _disposed = true;
        }
    }
}
