namespace Test.Web.Models
{
	public static class RepositoryHelper
	{
		public static IUnitOfWork GetUnitOfWork()
		{
			return new EFUnitOfWork();
		}		
		
		public static CategoryRepository GetCategoryRepository()
		{
			var repository = new CategoryRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static CategoryRepository GetCategoryRepository(IUnitOfWork unitOfWork)
		{
			var repository = new CategoryRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static MainPictureRepository GetMainPictureRepository()
		{
			var repository = new MainPictureRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static MainPictureRepository GetMainPictureRepository(IUnitOfWork unitOfWork)
		{
			var repository = new MainPictureRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static PictureRepository GetPictureRepository()
		{
			var repository = new PictureRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static PictureRepository GetPictureRepository(IUnitOfWork unitOfWork)
		{
			var repository = new PictureRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static ProjectRepository GetProjectRepository()
		{
			var repository = new ProjectRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static ProjectRepository GetProjectRepository(IUnitOfWork unitOfWork)
		{
			var repository = new ProjectRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static RecordRepository GetRecordRepository()
		{
			var repository = new RecordRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static RecordRepository GetRecordRepository(IUnitOfWork unitOfWork)
		{
			var repository = new RecordRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static sysdiagramsRepository GetsysdiagramsRepository()
		{
			var repository = new sysdiagramsRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static sysdiagramsRepository GetsysdiagramsRepository(IUnitOfWork unitOfWork)
		{
			var repository = new sysdiagramsRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		
	}
}