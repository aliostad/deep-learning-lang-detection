using System;

namespace CI.DAL
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly CIContext _context = new CIContext();
        private AuthorRepository _authorRepository;
        private GenreRepository _genreRepository;
        private AudiofileRepository _audiofileRepository;
        private RatingRepository _ratingRepository;
        private UserRepository _userRepository;

        public AuthorRepository AuthorRepository
        {
            get { return _authorRepository ?? (_authorRepository = new AuthorRepository(_context)); }
        }

        public GenreRepository GenreRepository
        {
            get { return _genreRepository ?? (_genreRepository = new GenreRepository(_context)); }
        }

        public AudiofileRepository AudiofileRepository
        {
            get { return _audiofileRepository ?? (_audiofileRepository = new AudiofileRepository(_context)); }
        }

        public RatingRepository RatingRepository
        {
            get { return _ratingRepository ?? (_ratingRepository = new RatingRepository(_context)); }
        }

        public UserRepository UserRepository
        {
            get { return _userRepository ?? (_userRepository = new UserRepository(_context)); }
        }

        public void Save()
        {
            _context.SaveChanges();
        }

        private bool disposed = false;

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}