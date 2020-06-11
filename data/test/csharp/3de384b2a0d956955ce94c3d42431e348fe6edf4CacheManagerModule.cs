using DCT.Monitor.Modules;
using Monitor.DAL;
using DCT.Unity;

namespace DCT.Monitor.Modules.Implementation.CacheManagerModule
{
	public class CacheManagerModule : ICacheManagerModule
	{
		ISiteRepository _siteRepository = ServiceLocator.Current.Resolve<ISiteRepository>();
		IProviderRepository _providerRepository = ServiceLocator.Current.Resolve<IProviderRepository>();

		public void Reset()
		{
			ResetRepository(_siteRepository);
			ResetRepository(_providerRepository);
		}

		private void ResetRepository<T, T1>(IBaseRepository<T, T1> repository)
		{
			var cachedRepository = repository as ICacheRepository<T, T1>;
			if (cachedRepository != null) cachedRepository.Reset();
		}
	}
}
