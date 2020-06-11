using System;
using Kondor.Domain;
using Kondor.Domain.Models;

namespace Kondor.Data.EF
{
    public class EFUnitOfWork : IUnitOfWork
    {
        private bool _disposed; // default value is false
        private readonly IDbContext _context;

        private IRepository<Notification> _notificationRepository;
        private IRepository<Language> _languageRepository;
        private IRepository<Medium> _mediumRepository;
        private IRepository<CardState> _cardStateRepository;
        private IRepository<Deck> _deckRepository;
        private IRepository<SubDeck> _subDeckRepository;
        private ICardRepository _cardRepository;
        private IExampleRepository _exampleRepository;
        private IExampleViewRepository _exampleViewRepository;
        private IResponseRepository _responseRepository;
        private ISettingRepository _settingRepository;
        private IUpdateRepository _updateRepository;
        private IUserRepository _userRepository;

        public EFUnitOfWork(IDbContext context)
        {
            _context = context;
        }

        public IRepository<Notification> NotificationRepository => _notificationRepository ?? (_notificationRepository = new EFRepository<Notification>(_context));
        public IRepository<Language> LanguageRepository => _languageRepository ?? (_languageRepository = new EFRepository<Language>(_context));
        public IRepository<Medium> MediumRepository => _mediumRepository ?? (_mediumRepository = new EFRepository<Medium>(_context));
        public IRepository<CardState> CardStateRepository => _cardStateRepository ?? (_cardStateRepository = new EFRepository<CardState>(_context));
        public IRepository<Deck> DeckRepository => _deckRepository ?? (_deckRepository = new EFRepository<Deck>(_context));
        public IRepository<SubDeck> SubDeckRepository => _subDeckRepository ?? (_subDeckRepository = new EFRepository<SubDeck>(_context));
        public ICardRepository CardRepository => _cardRepository ?? (_cardRepository = new EFCardRepository(_context));
        public IExampleRepository ExampleRepository => _exampleRepository ?? (_exampleRepository = new EFExampleRepository(_context));
        public IExampleViewRepository ExampleViewRepository => _exampleViewRepository ?? (_exampleViewRepository = new EFExampleViewRepository(_context));
        public IResponseRepository ResponseRepository => _responseRepository ?? (_responseRepository = new EFResponseRepository(_context));
        public ISettingRepository SettingRepository => _settingRepository ?? (_settingRepository = new EFSettingRepository(_context));
        public IUpdateRepository UpdateRepository => _updateRepository ?? (_updateRepository = new EFUpdateRepository(_context));
        public IUserRepository UserRepository => _userRepository ?? (_userRepository = new EFUserRepository(_context));

        public void Save()
        {
            _context.SaveChanges();
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!this._disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            this._disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
