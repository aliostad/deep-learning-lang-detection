using Stock.DAL.Repositories;

namespace Stock.DAL.Infrastructure
{
    public class RepositoryFactory
    {

        private static readonly IFxRepository FxRepository;
        private static readonly ICompanyRepository CompanyRepository;
        private static readonly IMarketRepository MarketRepository;
        private static readonly IDataRepository DataRepository;

        static RepositoryFactory()
        {
            CompanyRepository = new EFCompanyRepository();
            MarketRepository = new EFMarketRepository();
            DataRepository = new EFDataRepository();
            FxRepository = new EFFxRepository();
        }


        public static ICompanyRepository GetCompanyRepository()
        {
            return CompanyRepository;
        }

        public static IMarketRepository GetMarketRepository()
        {
            return MarketRepository;
        }

        public static IDataRepository GetDataRepository()
        {
            return DataRepository;
        }

        public static IFxRepository GetFxRepository()
        {
            return FxRepository;
        }


    }
}
