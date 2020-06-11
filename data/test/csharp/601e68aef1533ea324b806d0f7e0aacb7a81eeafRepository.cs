using MageWarsWebSite.Domain.Abstract;

namespace MageWarsWebSite.Domain.Concrete
{
    public class Repository : IRepository
    {
        private IBaseRepository _repo;

        public Repository(IBaseRepository repo)
        {
            _repo = repo;

            DeskRepository = new DeskRepository(repo);
            CardRepository = new CardRepository(repo);
            SchoolRepository = new SchoolRepository(repo);
            CardTypeRepository = new CardTypeRepository(repo);
            SubTypeRepository = new SubTypeRepository(repo);

            GameRepository = new GameRepository(repo);
            UserRepository = new UserRepository(repo);
            MageRepository = new MageRepository(repo);
        }

        
        public ICardRepository CardRepository { get; }

        public ISchoolRepository SchoolRepository { get; }

        public ICardTypeRepository CardTypeRepository { get; }

        public ISubTypeRepository SubTypeRepository { get; }

        public IGameRepository GameRepository { get; }

        public IUserRepository UserRepository { get; }

        public IDeskRepository DeskRepository { get; }

        public IMageRepository MageRepository { get; }

    }
}

