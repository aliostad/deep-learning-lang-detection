namespace Workload.Models
{
	public static class RepositoryHelper
	{
		public static IUnitOfWork GetUnitOfWork()
		{
			return new EFUnitOfWork();
		}		
		
		public static audit_editRepository Getaudit_editRepository()
		{
			var repository = new audit_editRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static audit_editRepository Getaudit_editRepository(IUnitOfWork unitOfWork)
		{
			var repository = new audit_editRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static budget_planRepository Getbudget_planRepository()
		{
			var repository = new budget_planRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static budget_planRepository Getbudget_planRepository(IUnitOfWork unitOfWork)
		{
			var repository = new budget_planRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static Login_authRepository GetLogin_authRepository()
		{
			var repository = new Login_authRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static Login_authRepository GetLogin_authRepository(IUnitOfWork unitOfWork)
		{
			var repository = new Login_authRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static MonthDataRepository GetMonthDataRepository()
		{
			var repository = new MonthDataRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static MonthDataRepository GetMonthDataRepository(IUnitOfWork unitOfWork)
		{
			var repository = new MonthDataRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static PrjDataRepository GetPrjDataRepository()
		{
			var repository = new PrjDataRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static PrjDataRepository GetPrjDataRepository(IUnitOfWork unitOfWork)
		{
			var repository = new PrjDataRepository();
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

		public static V_EmpdataRepository GetV_EmpdataRepository()
		{
			var repository = new V_EmpdataRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static V_EmpdataRepository GetV_EmpdataRepository(IUnitOfWork unitOfWork)
		{
			var repository = new V_EmpdataRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		

		public static WorksheetRepository GetWorksheetRepository()
		{
			var repository = new WorksheetRepository();
			repository.UnitOfWork = GetUnitOfWork();
			return repository;
		}

		public static WorksheetRepository GetWorksheetRepository(IUnitOfWork unitOfWork)
		{
			var repository = new WorksheetRepository();
			repository.UnitOfWork = unitOfWork;
			return repository;
		}		
	}
}