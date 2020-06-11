namespace Bakery.Cqrs.Configuration
{
	using System;

	public class Configuration
		: IConfiguration
	{
		public Configuration(Boolean allowMultipleCommandDispatch, Boolean allowVoidCommandDispatch)
		{
			AllowMultipleCommandDispatch = allowMultipleCommandDispatch;
			AllowVoidCommandDispatch = allowVoidCommandDispatch;
		}

		public Configuration(Boolean allowMultipleCommandDispatch, Boolean allowVoidCommandDispatch, ICachingConfiguration cachingConfiguration)
		{
			AllowMultipleCommandDispatch = allowMultipleCommandDispatch;
			AllowVoidCommandDispatch = allowVoidCommandDispatch;
			CachingConfiguration = cachingConfiguration;
		}

		public Boolean AllowMultipleCommandDispatch { get; private set; }
		public Boolean AllowVoidCommandDispatch { get; private set; }
		public ICachingConfiguration CachingConfiguration { get; private set; }
	}
}
