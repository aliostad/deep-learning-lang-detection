using GameStore.DAL.Models.GameStore;
using GameStore.DAL.Models.Northwind;
using GameStore.DAL.Repositories.GameStore;
using GameStore.DAL.Repositories.GameStore.Interfaces;
using GameStore.DAL.Repositories.Northwind;
using GameStore.DAL.Repositories.Northwind.Interfaces;
using GameStore.DAL.Repositories.Synchronized;

namespace GameStore.DAL.UnitOfWorks
{
    public class UnitOfWorks : IUnitOfWorks
    {
        private readonly EfGameStoreContext _context = new EfGameStoreContext();
        private readonly EfNorthwindContext _northwindContext = new EfNorthwindContext();
        private IBanRepository _banRepository;
        private IBasketDetailsRepository _basketDetailsRepository;
        private IBasketRepository _basketRepository;

        private ICommentRepository _commentRepository;
        private IGameRepository _gameRepository;
        private IGenreRepository _genreRepository;
        private IOrderDetailsRepository _orderDetailsRepository;
        private IOrderRepository _orderRepository;
        private IPlatformTypeRepository _platformRepository;
        private IPublisherRepository _publisherRepository;
        private IRoleRepository _roleRepository;
        private IShipperRepository _shipperRepository;
        private IStatisticRepository _statisticRepository;
        private IUserRepository _userRepository;

        public IGameRepository GameRepository
        {
            get
            {
                return _gameRepository ?? 
                    (_gameRepository = new GameSynchronizedRepository(_context,_northwindContext));
            }
        }

        public ICommentRepository CommentRepository
        {
            get { return _commentRepository ?? (_commentRepository = new CommentRepository(_context)); }
        }

        public IGenreRepository GenreRepository
        {
            get
            {
                return _genreRepository ??
                       (_genreRepository = new GenreSynchronizedRepository(_context, _northwindContext));
            }
        }

        public IPlatformTypeRepository PlatformTypeRepository
        {
            get { return _platformRepository ?? (_platformRepository = new PlatformTypeRepository(_context)); }
        }

        public IPublisherRepository PublisherRepository
        {
            get
            {
                return _publisherRepository ??
                       (_publisherRepository = new PublisherSynchronizedRepository(_context, _northwindContext));
            }
        }

        public IOrderRepository OrderRepository
        {
            get
            {
                return _orderRepository ??
                       (_orderRepository = new OrderSynchronizedRepository(_context, _northwindContext));
            }
        }

        public IOrderDetailsRepository OrderDetailsRepository
        {
            get { return _orderDetailsRepository ?? (_orderDetailsRepository = new OrderDetailsRepository(_context)); }
        }

        public IBasketRepository BasketRepository
        {
            get { return _basketRepository ?? (_basketRepository = new BasketRepository(_context)); }
        }

        public IBasketDetailsRepository BasketDetailsRepository
        {
            get
            {
                return _basketDetailsRepository ?? (_basketDetailsRepository = new BasketDetailsRepository(_context));
            }
        }

        public IUserRepository UserRepository
        {
            get { return _userRepository ?? (_userRepository = new UserRepository(_context)); }
        }

        public IRoleRepository RoleRepository
        {
            get { return _roleRepository ?? (_roleRepository = new RoleRepository(_context)); }
        }

        public IStatisticRepository StatisticRepository
        {
            get { return _statisticRepository ?? (_statisticRepository = new StatisticRepository(_context)); }
        }

        public IBanRepository BanRepository
        {
            get { return _banRepository ?? (_banRepository = new BanRepository(_context)); }
        }

        public IShipperRepository ShipperRepository
        {
            get { return _shipperRepository ?? (_shipperRepository = new ShipperRepository(_northwindContext)); }
        }

        public void Save()
        {
            _context.SaveChanges();
        }
    }
}