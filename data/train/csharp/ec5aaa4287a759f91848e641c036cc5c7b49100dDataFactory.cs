using Radvill.DataFactory.Internal.Services;
using Radvill.Services.DataFactory;
using Radvill.Services.DataFactory.Repositories;

namespace Radvill.DataFactory.Public
{
    public class DataFactory : IDataFactory
    {
        private readonly IRadvillContext _context;

        public DataFactory(
            IRadvillContext context, 
            IUserRepository userRepository, 
            ICategoryRepository categoryRepository, 
            IQuestionRepository questionRepository, 
            IAnswerRepository answerRepository, 
            IPendingQuestionRepository pendingQuestionRepository,
            IAdvisorProfileRepository advisorProfileRepository)
        {
            _context = context;
            UserRepository = userRepository;
            CategoryRepository = categoryRepository;
            QuestionRepository = questionRepository;
            AnswerRepository = answerRepository;
            PendingQuestionRepository = pendingQuestionRepository;
            AdvisorProfileRepository = advisorProfileRepository;
        }
        
        public IUserRepository UserRepository { get; set; }
        public ICategoryRepository CategoryRepository { get; set; }
        public IQuestionRepository QuestionRepository { get; set; }
        public IAnswerRepository AnswerRepository { get; set; }
        public IPendingQuestionRepository PendingQuestionRepository { get; set; }
        public IAdvisorProfileRepository AdvisorProfileRepository { get; set; }


        public void Dispose()
        {
            _context.Dispose();
        }

        public void Commit()
        {
            _context.SaveChanges();
        }
    }
}