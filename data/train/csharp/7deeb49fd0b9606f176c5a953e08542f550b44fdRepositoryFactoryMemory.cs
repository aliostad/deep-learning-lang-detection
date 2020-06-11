using RecensysRepository.Repository.InMemoryImpl;
using RecensysRepository.Repository.Interfaces;

namespace RecensysRepository.Repository.Factory
{
    public class RepositoryFactoryMemory : IRepositoryFactory
    {

        private static UserRepositoryIm _userRepository;
        private static StudyRepositoryIm _studyRepository;
        private static StageRepositoryIm _stageRepository;
        private static FieldRepositoryIm _fieldRepository;
        private static FieldDataRepositoryIm _fieldDataRepository;
        private static TaskRepositoryIm _taskRepository;
        private static ArticleRepositoryIm _articleRepository;
        private static CredentialsRepositoryIm _credentialsRepository;
        private static UserStudyRelationRepositoryIm _userStudyRelationRepository;
        private static StudyRoleRepositoryIm _studyRoleRepository;
        private static StrategyRepositoryIm _strategyRepository;

        public IUserRepository GetUserRepo()
        {
            return _userRepository ?? (_userRepository = new UserRepositoryIm());
        }

        public IStudyRepository GetStudyRepo()
        {
            return _studyRepository ?? (_studyRepository = new StudyRepositoryIm());
        }

        public IStageRepository GetStageRepo()
        {
            return _stageRepository ?? (_stageRepository = new StageRepositoryIm());
        }

        public IFieldRepository GetFieldRepo()
        {
            return _fieldRepository ?? (_fieldRepository = new FieldRepositoryIm());
        }

        public IFieldDataRepository GetFieldDataRepo()
        {
            return _fieldDataRepository ?? (_fieldDataRepository = new FieldDataRepositoryIm());
        }

        public ITaskRepository GetTaskRepo()
        {
            return _taskRepository ?? (_taskRepository = new TaskRepositoryIm());
        }

        public IArticleRepository GetArticleRepo()
        {
            return _articleRepository ?? (_articleRepository = new ArticleRepositoryIm());
        }

        public ICredentialsRepository GetCredentialsRepo()
        {
            return _credentialsRepository ?? (_credentialsRepository = new CredentialsRepositoryIm());
        }

        public IUserStudyRelationRepository GetUserStudyRelationRepository()
        {
            return _userStudyRelationRepository ?? (_userStudyRelationRepository = new UserStudyRelationRepositoryIm());
        }

        public IStudyRoleRepository GetStudyRoleRepository()
        {
            return _studyRoleRepository ?? (_studyRoleRepository = new StudyRoleRepositoryIm());
        }

        public IStrategyRepository GetStrategyRepository()
        {
            return _strategyRepository ?? (_strategyRepository = new StrategyRepositoryIm());
        }
    }
}