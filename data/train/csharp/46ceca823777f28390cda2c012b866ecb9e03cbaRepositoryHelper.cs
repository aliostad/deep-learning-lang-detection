namespace myMVC5Couse.Models
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

		public static vwClientSummaryRepository GetvwClientSummaryRepository()
		{
			var repository = new vwClientSummaryRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static vwClientSummaryRepository GetvwClientSummaryRepository(IUnitOfWork unitOfWork)
		{
			var repository = new vwClientSummaryRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		
	}
}