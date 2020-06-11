using RecensysRepository.Repository.Interfaces;

namespace RecensysRepository.Repository.Factory
{
    public interface IRepositoryFactory
    {
        IUserRepository GetUserRepo();
        IStudyRepository GetStudyRepo();
        IStageRepository GetStageRepo();
        IFieldRepository GetFieldRepo();
        IFieldDataRepository GetFieldDataRepo();
        ITaskRepository GetTaskRepo();
        IArticleRepository GetArticleRepo();
        ICredentialsRepository GetCredentialsRepo();
        IUserStudyRelationRepository GetUserStudyRelationRepository();
        IStudyRoleRepository GetStudyRoleRepository();
        IStrategyRepository GetStrategyRepository();
    }
}
