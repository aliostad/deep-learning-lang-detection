
namespace GenerateData.Repositories
{
	public class RepositoryModule : Ninject.Modules.NinjectModule
	{
		public override void Load()
		{
			Bind<IAccountRepository>().To<AccountRepository>();
			Bind<ICityRepository>().To<CityRepository>();
			Bind<IConfigurationRepository>().To<ConfigurationRepository>();
			Bind<ICountryRepository>().To<CountryRepository>();
			Bind<IRegionRepository>().To<RegionRepository>();
			Bind<ISessionRepository>().To<SessionRepository>();
			Bind<ISettingRepository>().To<SettingRepository>();
		}
	}
}
