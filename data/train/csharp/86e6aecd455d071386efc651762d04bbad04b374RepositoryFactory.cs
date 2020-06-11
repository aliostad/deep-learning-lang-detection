using GiftShop.Repository.Accounts;
using GiftShop.Repository.Products;

namespace GiftShop.Repository
{
    public class RepositoryFactory
    {
        private readonly static RepositoryFactory _instance = new RepositoryFactory();

        private RepositoryFactory()
        {
        }

        public  ProductsRepository ProductsRepository{
            get
            {
                return new ProductsRepository();
            }
        }

        public  AccountsRepository AccountsRepository
        {
            get
            {
                return new AccountsRepository();
            }
        }

        public CategoriesRepository CategoriesRepository
        {
            get
            {
                return new CategoriesRepository();
            }
        }

        public static RepositoryFactory Instance
        {
            get
            {
                return _instance;
            }
        }
    }
}
