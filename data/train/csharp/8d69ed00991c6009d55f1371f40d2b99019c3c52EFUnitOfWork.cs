using APRST.DAL.EF;
using APRST.DAL.Interfaces;
using System;
using System.Threading.Tasks;

namespace APRST.DAL.Repositories
{
    public class EFUnitOfWork : IUnitOfWork
    {
        private readonly AprstContext _db;
        private ITestRepository _testRepository;
        private ITestCategoryRepository _testCategoryRepository;
        private ITestQuestionRepository _testQuestionRepository;
        private ITestAnswerRepository _testAnswerRepository;
        private ITestResultRepository _testResultRepository;
        private IUserProfileRepository _userProfileRepository;
        private IRoleRepository _roleRepository;
        private IQuestionnaireCategoryRepository _questionnaireCategoryRepository;
        private IQuestionnaireQuestionRepository _questionnaireQuestionRepository;
        private IQuestionnaireRepository _questionnaireRepository;
        private IQuestionnaireTypeRepository _questionnaireTypeRepository;
        private IQuestionnaireResultRepository _questionnaireResultRepository;
        private ILogRepository _logRepository;

        public EFUnitOfWork(string connectionString)
        {
            _db = new AprstContext(connectionString);
        }
        public ITestRepository TestRepository => _testRepository ?? (_testRepository = new TestRepository(_db));

        public ITestCategoryRepository TestCategoryRepository => _testCategoryRepository ?? (_testCategoryRepository = new TestCategoryRepository(_db));

        public ITestQuestionRepository TestQuestionRepository => _testQuestionRepository ?? (_testQuestionRepository = new TestQuestionRepository(_db));

        public ITestAnswerRepository TestAnswerRepository => _testAnswerRepository ?? (_testAnswerRepository = new TestAnswerRepository(_db));

        public ITestResultRepository TestResultRepository => _testResultRepository ?? (_testResultRepository = new TestResultRepository(_db));

        public IUserProfileRepository UserProfileRepository => _userProfileRepository ?? (_userProfileRepository = new UserProfileRepository(_db));

        public IRoleRepository RoleRepository => _roleRepository ?? (_roleRepository = new RoleRepository(_db));

        public IQuestionnaireCategoryRepository QuestionnaireCategoryRepository => _questionnaireCategoryRepository ?? (_questionnaireCategoryRepository = new QuestionnaireCategoryRepository(_db));

        public IQuestionnaireQuestionRepository QuestionnaireQuestionRepository => _questionnaireQuestionRepository ?? (_questionnaireQuestionRepository = new QuestionnaireQuestionRepository(_db));

        public IQuestionnaireRepository QuestionnaireRepository => _questionnaireRepository ?? (_questionnaireRepository = new QuestionnaireRepository(_db));

        public IQuestionnaireTypeRepository QuestionnaireTypeRepository => _questionnaireTypeRepository ?? (_questionnaireTypeRepository = new QuestionnaireTypeRepository(_db));

        public IQuestionnaireResultRepository QuestionnaireResultRepository => _questionnaireResultRepository ?? (_questionnaireResultRepository = new QuestionnaireResultRepository(_db));

        public ILogRepository LogRepository => _logRepository ?? (_logRepository = new LogRepository(_db));

        public void Save()
        {
            _db.SaveChanges();
        }

        private bool _disposed = false;

        public virtual void Dispose(bool disposing)
        {
            if (!this._disposed)
            {
                if (disposing)
                {
                    _db.Dispose();
                }
                this._disposed = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
        
        public Task SaveAsync()
        {
            return _db.SaveChangesAsync();
        }
    }
}
