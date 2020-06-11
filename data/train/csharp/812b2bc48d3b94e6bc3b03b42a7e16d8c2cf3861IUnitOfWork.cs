using itechart.PerformanceReview.Data.Model;

namespace itechart.PerformanceReview.Data.Repository
{
    public interface IUnitOfWork
    {
        IUsersRepository UsersRepository { get; }
        IGenericRepository<UserProfile> UserProfilessRepository { get; }
        IDepartmentsRepository DepartmentsRepository { get; }
        IGenericRepository<EntitiesUpdateHistory> EntitiesUpdateHistoryRepository { get; }
        IGenericRepository<EntityType> EntityTypesRepository { get; }
        IApplicationSettingsRepository ApplicationSettingsRepository { get; }

        void Save();
    }
}