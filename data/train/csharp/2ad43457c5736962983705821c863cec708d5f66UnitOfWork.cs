using System;
using Samurai_CMS.Models;

namespace Samurai_CMS.DAL
{
    public class UnitOfWork : IDisposable
    {
        private readonly ApplicationDbContext _context = new ApplicationDbContext();

        private Repository<AuthorPaper> _paperRepository;
        private Repository<Conference> _conferenceRepository;
        private Repository<Edition> _editionRepository;
        private Repository<Enrollment> _enrollmentRepository;
        private Repository<ReviewAssignment> _paperReviewRepository;
        private Repository<Session> _sessionRepository;
        private Repository<User> _userRepository;
        private Repository<UserRole> _roleRepository;

        public Repository<AuthorPaper> PaperRepository => _paperRepository ?? (_paperRepository = new Repository<AuthorPaper>(_context));

        public Repository<Conference> ConferenceRepository => _conferenceRepository ?? (_conferenceRepository = new Repository<Conference>(_context));

        public Repository<Edition> EditionRepository => _editionRepository ?? (_editionRepository = new Repository<Edition>(_context));

        public Repository<Enrollment> EnrollmentRepository => _enrollmentRepository ?? (_enrollmentRepository = new Repository<Enrollment>(_context)); 

        public Repository<ReviewAssignment> PaperReviewRepository => _paperReviewRepository ?? (_paperReviewRepository = new Repository<ReviewAssignment>(_context)); 

        public Repository<Session> SessionRepository => _sessionRepository ?? (_sessionRepository = new Repository<Session>(_context));

        public Repository<User> UserRepository => _userRepository ?? (_userRepository = new Repository<User>(_context));

        public Repository<UserRole> RoleRepository => _roleRepository ?? (_roleRepository = new Repository<UserRole>(_context));

        public void Complete()
        {
            _context.SaveChanges();  
        }

        private bool _disposed ;

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