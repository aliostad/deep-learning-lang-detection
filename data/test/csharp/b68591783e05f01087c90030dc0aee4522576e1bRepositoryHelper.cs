namespace MVC5Course.Models
{
	public static class RepositoryHelper
	{
		public static IUnitOfWork GetUnitOfWork()
		{
			return new EFUnitOfWork();
		}		
		
		public static ClientRepository GetClientRepository()
		{
			var repository = new ClientRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static ClientRepository GetClientRepository(IUnitOfWork unitOfWork)
		{
			var repository = new ClientRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static OccupationRepository GetOccupationRepository()
		{
			var repository = new OccupationRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static OccupationRepository GetOccupationRepository(IUnitOfWork unitOfWork)
		{
			var repository = new OccupationRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static OrderRepository GetOrderRepository()
		{
			var repository = new OrderRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static OrderRepository GetOrderRepository(IUnitOfWork unitOfWork)
		{
			var repository = new OrderRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static OrderLineRepository GetOrderLineRepository()
		{
			var repository = new OrderLineRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static OrderLineRepository GetOrderLineRepository(IUnitOfWork unitOfWork)
		{
			var repository = new OrderLineRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static ProductRepository GetProductRepository()
		{
			var repository = new ProductRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static ProductRepository GetProductRepository(IUnitOfWork unitOfWork)
		{
			var repository = new ProductRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static vw_ClientContributionRepository Getvw_ClientContributionRepository()
		{
			var repository = new vw_ClientContributionRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static vw_ClientContributionRepository Getvw_ClientContributionRepository(IUnitOfWork unitOfWork)
		{
			var repository = new vw_ClientContributionRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		
	}
}