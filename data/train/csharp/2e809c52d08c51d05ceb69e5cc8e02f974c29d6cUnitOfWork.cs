using System;
using Domain.Models;

namespace Domain.Repository
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly LibraryDbContext _context = new LibraryDbContext();

        private Repository<User> _userRepository;
        private Repository<Author> _authorRepository;
        private Repository<Book> _bookRepository;
        private Repository<BorrowInfo> _borrowInfoRepository;
        private Repository<Genre> _genreRepository;
        private Repository<Language> _languageRepository;
        private Repository<Publisher> _publisherRepository;
        private Repository<Reader> _readerRepository;


        public Repository<User> UserRepository 
            => _userRepository ?? (_userRepository = new Repository<User>(_context));

        public Repository<Author> AuthorRepository
            => _authorRepository ?? (_authorRepository = new Repository<Author>(_context));

        public Repository<Book> BookRepository
            => _bookRepository ?? (_bookRepository = new Repository<Book>(_context));

        public Repository<BorrowInfo> BorrowInfoRepository
            => _borrowInfoRepository ?? (_borrowInfoRepository = new Repository<BorrowInfo>(_context));

        public Repository<Genre> GenreRepository
            => _genreRepository ?? (_genreRepository = new Repository<Genre>(_context));

        public Repository<Language> LanguageRepository
            => _languageRepository ?? (_languageRepository = new Repository<Language>(_context));

        public Repository<Publisher> PublisherRepository
            => _publisherRepository ?? (_publisherRepository = new Repository<Publisher>(_context));

        public Repository<Reader> ReaderRepository
            => _readerRepository ?? (_readerRepository = new Repository<Reader>(_context));

        public void Save()
        {
            _context.SaveChanges();
        }

        private bool _disposed;

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            _disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
