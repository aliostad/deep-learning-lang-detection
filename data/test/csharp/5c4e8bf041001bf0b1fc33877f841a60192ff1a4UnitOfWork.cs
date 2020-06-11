using StackOverflow.Domain.Entities;

namespace StackOverflow.Data
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly StackOverflowContext _context;
        private GenericRepository<Account> _accountRepository;
        private GenericRepository<Question> _questionRepository;
        private GenericRepository<Answer> _answerRepository;
        private GenericRepository<Comment> _commentRepository;
        private GenericRepository<Vote> _voteRepository;

        public UnitOfWork()
        {
            _context = new StackOverflowContext();
        }

        public void Commit()
        {
            _context.SaveChanges();
        }

        public void Rollback()
        {
            _context.Dispose();
        }

        public GenericRepository<Account> AccountRepository
        {
            get { return _accountRepository ?? (_accountRepository = new GenericRepository<Account>(_context)); }
        }

        public GenericRepository<Question> QuestionRepository
        {
            get { return _questionRepository ?? (_questionRepository = new GenericRepository<Question>(_context)); }
        }

        public GenericRepository<Answer> AnswerRepository
        {
            get { return _answerRepository ?? (_answerRepository = new GenericRepository<Answer>(_context)); }
        }

        public GenericRepository<Comment> CommentRepository
        {
            get { return _commentRepository ?? (_commentRepository = new GenericRepository<Comment>(_context)); }
        }

        public GenericRepository<Vote> VoteRepository
        {
            get { return _voteRepository ?? (_voteRepository = new GenericRepository<Vote>(_context)); }
        }
    }
}