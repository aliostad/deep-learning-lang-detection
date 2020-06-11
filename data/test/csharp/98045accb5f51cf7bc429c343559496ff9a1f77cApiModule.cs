using Fabric.Api.Executors;

namespace Fabric.Api {

	/*================================================================================================*/
	public class ApiModule : BaseModule {


		////////////////////////////////////////////////////////////////////////////////////////////////
		/*--------------------------------------------------------------------------------------------*/
		public ApiModule() {
			SetupFromApiEntries(MenuExecutors.ApiEntries);
			SetupFromApiEntries(MetaExecutors.ApiEntries);
			SetupFromApiEntries(CreateExecutors.ApiEntries);
			SetupFromApiEntries(TraversalExecutors.ApiEntries);
			SetupFromApiEntries(OauthExecutors.ApiEntries);
			SetupFromApiEntries(InternalExecutors.ApiEntries);
		}

	}

}