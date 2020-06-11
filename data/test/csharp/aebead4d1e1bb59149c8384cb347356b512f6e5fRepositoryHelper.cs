namespace Ryde.DataAccess
{
	public static class RepositoryHelper
	{
		public static IUnitOfWork GetUnitOfWork()
		{
			return new EFUnitOfWork();
		}		
		
		public static JourneyRepository GetJourneyRepository()
		{
			var repository = new JourneyRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static JourneyRepository GetJourneyRepository(IUnitOfWork unitOfWork)
		{
			var repository = new JourneyRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static JourneyStatusRepository GetJourneyStatusRepository()
		{
			var repository = new JourneyStatusRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static JourneyStatusRepository GetJourneyStatusRepository(IUnitOfWork unitOfWork)
		{
			var repository = new JourneyStatusRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static LocationRepository GetLocationRepository()
		{
			var repository = new LocationRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static LocationRepository GetLocationRepository(IUnitOfWork unitOfWork)
		{
			var repository = new LocationRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static QueueRepository GetQueueRepository()
		{
			var repository = new QueueRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static QueueRepository GetQueueRepository(IUnitOfWork unitOfWork)
		{
			var repository = new QueueRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static RoleRepository GetRoleRepository()
		{
			var repository = new RoleRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static RoleRepository GetRoleRepository(IUnitOfWork unitOfWork)
		{
			var repository = new RoleRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static UserRepository GetUserRepository()
		{
			var repository = new UserRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static UserRepository GetUserRepository(IUnitOfWork unitOfWork)
		{
			var repository = new UserRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		
	}
}