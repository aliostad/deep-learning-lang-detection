﻿using L2dotNET.Repositories.Contracts;

namespace L2dotNET.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        public UnitOfWork() { }

        public UnitOfWork(IPlayerRepository playerRepository, IAccountRepository accountRepository, IServerRepository serverRepository, ICheckRepository checkRepository, IItemRepository itemRepository, ISkillRepository skillRepository)
        {
            _playerRepository = playerRepository;
            _accountRepository = accountRepository;
            _serverRepository = serverRepository;
            _checkRepository = checkRepository;
            _itemRepository = itemRepository;
            _skillRepository = SkillRepository;
        }

        public void Commit() { }

        public void Dispose() { }

        #region REPOSITORIES

        private IPlayerRepository _playerRepository;

        public IPlayerRepository PlayerRepository => _playerRepository ?? (_playerRepository = new PlayerRepository());

        private IAccountRepository _accountRepository;

        public IAccountRepository AccountRepository => _accountRepository ?? (_accountRepository = new AccountRepository());

        private IServerRepository _serverRepository;

        public IServerRepository ServerRepository => _serverRepository ?? (_serverRepository = new ServerRepository());

        private ICheckRepository _checkRepository;

        public ICheckRepository CheckRepository => _checkRepository ?? (_checkRepository = new CheckRepository());

        private IItemRepository _itemRepository;

        public IItemRepository ItemRepository => _itemRepository ?? (_itemRepository = new ItemRepository());

        private ISkillRepository _skillRepository;

        public ISkillRepository SkillRepository => _skillRepository ?? (_skillRepository = new SkillRepository());

        #endregion
    }
}