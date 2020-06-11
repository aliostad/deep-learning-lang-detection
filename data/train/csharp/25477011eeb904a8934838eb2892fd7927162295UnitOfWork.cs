using TournamentWebApi.DAL.Entities;
using TournamentWebApi.DAL.Interfaces;

namespace TournamentWebApi.DAL.UnitsOfWorks
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly IRepositoryFactory _repositoryFactory;

        private IGenericRepository<Account> _accountRepository;
        private IGenericRepository<Match> _matchRepository;
        private IGenericRepository<Player> _playerRepository;
        private IGenericRepository<Role> _roleRepository;

        public UnitOfWork(IRepositoryFactory repositoryFactory)
        {
            _repositoryFactory = repositoryFactory;
        }

        public IGenericRepository<Account> AccountRepository
        {
            get { return _accountRepository ?? (_accountRepository = _repositoryFactory.GetRepository<Account>()); }
        }

        public IGenericRepository<Match> MatchRepository
        {
            get { return _matchRepository ?? (_matchRepository = _repositoryFactory.GetRepository<Match>()); }
        }

        public IGenericRepository<Player> PlayerRepository
        {
            get { return _playerRepository ?? (_playerRepository = _repositoryFactory.GetRepository<Player>()); }
        }

        public IGenericRepository<Role> RoleRepository
        {
            get { return _roleRepository ?? (_roleRepository = _repositoryFactory.GetRepository<Role>()); }
        }
    }
}