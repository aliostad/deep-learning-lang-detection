using SevenDigital.Api.Wrapper;

namespace SevenDigital.Api.Schema.Integration.Tests.Infrastructure
{
	public class ApiConnection : IApi
	{
		private readonly ApiFactory _apiFactory;

		public ApiConnection() : this(new AppSettingsCredentials()) {}

		public ApiConnection(IOAuthCredentials appSettingsCredentials)
		{
			_apiFactory = new ApiFactory(new ApiUri(), appSettingsCredentials);
		}

		public IFluentApi<T> Create<T>() where T : class, new()
		{
			return _apiFactory.Create<T>();
		}
	}
}