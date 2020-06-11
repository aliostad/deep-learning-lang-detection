using Entities;

namespace DataAccess
{
    public class Repository
    {
        private HeroesContext _context;
        private UserRepository _userRepository;
        private CreaturesRepository _creatureRepository;
        private HeroesRepository _heroesRepository;

        public Repository()
        {
            _context = new HeroesContext();
            _context.Configuration.LazyLoadingEnabled = false;
        }

        public UserRepository Users
        {
            get { return _userRepository = _userRepository ?? new UserRepository(_context); }
        }

        public CreaturesRepository Creatures
        {
            get { return _creatureRepository = _creatureRepository ?? new CreaturesRepository(_context); }
        }

        public HeroesRepository Heroes
        {
            get { return _heroesRepository = _heroesRepository ?? new HeroesRepository(_context); }
        }

    }
}
