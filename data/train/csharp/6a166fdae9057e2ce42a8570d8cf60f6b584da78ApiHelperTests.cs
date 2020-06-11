using Info.Blockchain.API.Client;
using Xunit;

namespace Info.Blockchain.API.Tests.UnitTests
{
	public class ApiHelperTests
	{
		[Fact]
		public void CreateHelper_Valid()
		{
			const string apiCode = "5";
			using (BlockchainApiHelper apiHelper = new BlockchainApiHelper(apiCode, new FakeHttpClient()))
			{
				Assert.NotNull(apiHelper);
				Assert.NotNull(apiHelper.statisticsExplorer);
				Assert.NotNull(apiHelper.blockExplorer);
				Assert.NotNull(apiHelper.exchangeRateExplorer);
				Assert.NotNull(apiHelper.transactionBroadcaster);
				Assert.Null(apiHelper.walletCreator);
		}
	}

        [Fact]
        public void CreateHelperWithService_Valid()
        {
            const string apiCode = "5";
            using (BlockchainApiHelper apiHelper = new BlockchainApiHelper(apiCode, new FakeHttpClient(), "http://localhost:3000"))
            {
                Assert.NotNull(apiHelper);
                Assert.NotNull(apiHelper.statisticsExplorer);
               Assert.NotNull(apiHelper.blockExplorer);
              Assert.NotNull(apiHelper.exchangeRateExplorer);
              Assert.NotNull(apiHelper.transactionBroadcaster);
              Assert.NotNull(apiHelper.walletCreator);
          }
       }
    }
}
