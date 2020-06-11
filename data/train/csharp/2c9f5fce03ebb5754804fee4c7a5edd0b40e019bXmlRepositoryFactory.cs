
namespace AbstractFactory.Repositories
{
    class XmlRepositoryFactory : IRepositoryFactory
    {

        private readonly string _connectionString = @"D:\System c#\AbstractFactory\DataSource\MyTasks.xml";

        public IPriorityRepository CreatePriorityRepository()
        {
            IPriorityRepository PriorityRepository = new XmlPriorityRepository(_connectionString);
            return PriorityRepository;
        }

        public ITaskRepository CreateTaskRepository()
        {
            ITaskRepository TaskRepository = new XmlTaskRepository(_connectionString);
            return TaskRepository;
        }

    }
}
