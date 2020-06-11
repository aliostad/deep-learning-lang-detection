using RecensysRepository.InMemoryImpl;
using RecensysRepository.Interfaces;

namespace RecensysRepository.Factory
{
    public class RepositoryFactoryMemory : IRepositoryFactory
    {

        private UserRepositoryIm _userRepository;
        private StudyRepositoryIm _studyRepository;
        private StageRepositoryIm _stageRepository;
        private FieldRepositoryIm _fieldRepository;
        private DataRepositoryIm _fieldDataRepository;
        private TaskRepositoryIm _taskRepository;
        private ArticleRepositoryIm _articleRepository;
        private CredentialsRepositoryIm _credentialsRepository;
        private UserStudyRelationRepositoryIm _userStudyRelationRepository;
        private StudyRoleRepositoryIm _studyRoleRepository;
        private StrategyRepositoryIm _strategyRepository;
        private DataTypeRepositoryIm _dataTypeRepository;

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

        public IDataRepository GetDataRepo()
        {
            return _fieldDataRepository ?? (_fieldDataRepository = new DataRepositoryIm());
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

        public IUserStudyRelationRepository GetUserStudyRelationRepo()
        {
            return _userStudyRelationRepository ?? (_userStudyRelationRepository = new UserStudyRelationRepositoryIm());
        }

        public IStudyRoleRepository GetStudyRoleRepo()
        {
            return _studyRoleRepository ?? (_studyRoleRepository = new StudyRoleRepositoryIm());
        }

        public IStrategyRepository GetStrategyRepo()
        {
            return _strategyRepository ?? (_strategyRepository = new StrategyRepositoryIm());
        }

        public IDataTypeRepository GetDataTypeRepo()
        {
            return _dataTypeRepository ?? (_dataTypeRepository = new DataTypeRepositoryIm());
        }
    }
}