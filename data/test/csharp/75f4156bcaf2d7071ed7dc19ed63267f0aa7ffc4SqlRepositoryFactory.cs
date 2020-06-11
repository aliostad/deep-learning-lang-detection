
namespace AbstractFactory.Repositories
{
    class SqlRepositoryFactory : IRepositoryFactory
    {

        private readonly string _connectionString = @"Server = localhost; user = sa; password = 1; Database = Hotel;";

        public IPriorityRepository CreatePriorityRepository()
        {
            IPriorityRepository PriorityRepository = new SqlPriorityRepository(_connectionString);
            return PriorityRepository;
        }

        public ITaskRepository CreateTaskRepository()
        {
            ITaskRepository TaskRepository = new SqlTaskRepository(_connectionString);
            return TaskRepository;
        }
    }
}
