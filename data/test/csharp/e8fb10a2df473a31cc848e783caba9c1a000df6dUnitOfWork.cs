using Runniac.Data.Repositories;
using Runniac.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Runniac.Data
{
    public class UnitOfWork : IDisposable, IUnitOfWork
    {
        private MyDatabaseContext _context = new MyDatabaseContext();
        private ICommentRepository _commentRepository;
        private IEventRepository _eventRepository;
        private IPhotoRepository _photoRepository;
        private IVoteRepository _voteRepository;
        private ITownRepository _townRepository;
        private IUserRepository _userRepository;

        public UnitOfWork(ICommentRepository commentRepository, IEventRepository eventRepository,
            IPhotoRepository photoRepository, IVoteRepository voteRepository, ITownRepository townRepository,
            IUserRepository userRepository)
        {
            _commentRepository = commentRepository;
            _eventRepository = eventRepository;
            _photoRepository = photoRepository;
            _voteRepository = voteRepository;
            _townRepository = townRepository;
            _userRepository = userRepository;
            SetRepositoriesContext();
        }

        private void SetRepositoriesContext()
        {
            _commentRepository.Context = _context;
            _eventRepository.Context = _context;
            _photoRepository.Context = _context;
            _voteRepository.Context = _context;
            _townRepository.Context = _context;
            _userRepository.Context = _context;
        }

        public ICommentRepository CommentRepository
        {
            get { return _commentRepository; }
        }

        public IPhotoRepository PhotoRepository
        {
            get { return _photoRepository; }
        }

        public IEventRepository EventRepository
        {
            get { return _eventRepository; }
        }

        public IVoteRepository VoteRepository
        {
            get { return _voteRepository; }
        }

        public ITownRepository TownRepository
        {
            get { return _townRepository; }
        }

        public IUserRepository UserRepository
        {
            get { return _userRepository; }
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
