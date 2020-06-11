using Finance.IRepositories;

namespace FinanceMvc.Repositories.Memory
{
    public class MemoryRepositoryFactory : IRepositoryFactory
    {
        protected static ICategoryRepository CategoryRepository;
        protected static IPropertyRepository PropertyRepository;
        protected static ITransactionRepository TransactionRepository;
        protected static IAccountRepository AccountRepository;
        protected static IUserRepository UserRepository;

        public ICategoryRepository GetCategoryRepository()
        {
            CategoryRepository = CategoryRepository ?? new CategoryRepository();
            return CategoryRepository;
        }

        public IPropertyRepository GetPropertyRepository()
        {
            PropertyRepository = PropertyRepository ?? new PropertyRepository();
            return PropertyRepository;
        }

        public ITransactionRepository GetTransactionRepository()
        {
            TransactionRepository = TransactionRepository ?? new TransactionRepository();
            return TransactionRepository;
        }

        public IAccountRepository GetAccountRepository()
        {
            AccountRepository = AccountRepository ?? new AccountRepository();
            return AccountRepository;
        }

        public IUserRepository GetUserRepository()
        {
            UserRepository = UserRepository ?? new UserRepository();
            return UserRepository;
        }
    }
}