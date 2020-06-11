namespace Stock.DAL.Repositories
{
    public class RepositoryFactory
    {

        private static readonly IMarketRepository marketRepository;
        private static readonly ICurrencyRepository currencyRepository;
        private static readonly IAssetRepository assetRepository;
        private static readonly ITimeframeRepository timeframeRepository;
        private static readonly IQuotationRepository quotationRepository;
        private static readonly IPriceRepository priceRepository;
        private static readonly ISimulationRepository simulationRepository;
        private static readonly IAnalysisRepository analysisRepository;
        private static readonly ITrendlineRepository trendlineRepository;

        static RepositoryFactory()
        {
            marketRepository = new EFMarketRepository();
            currencyRepository = new EFCurrencyRepository();
            assetRepository = new EFAssetRepository();
            timeframeRepository = new EFTimeframeRepository();
            quotationRepository = new EFQuotationRepository();
            priceRepository = new EFPriceRepository();
            simulationRepository = new EFSimulationRepository();
            analysisRepository = new EFAnalysisRepository();
            trendlineRepository = new EFTrendlineRepository();
        }


        public static IMarketRepository GetMarketRepository()
        {
            return marketRepository;
        }

        public static ICurrencyRepository GetCurrencyRepository()
        {
            return currencyRepository;
        }

        public static IAssetRepository GetAssetRepository()
        {
            return assetRepository;
        }

        public static ITimeframeRepository GetTimeframeRepository()
        {
            return timeframeRepository;
        }

        public static IQuotationRepository GetQuotationRepository()
        {
            return quotationRepository;
        }

        public static IPriceRepository GetPriceRepository()
        {
            return priceRepository;
        }

        public static ISimulationRepository GetSimulationRepository()
        {
            return simulationRepository;
        }

        public static IAnalysisRepository GetAnalysisRepository()
        {
            return analysisRepository;
        }

        public static ITrendlineRepository GetTrendlineRepository()
        {
            return trendlineRepository;
        }

    }
}

