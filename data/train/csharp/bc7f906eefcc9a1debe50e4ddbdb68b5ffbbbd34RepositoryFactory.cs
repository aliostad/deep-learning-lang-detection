using Finance.IRepositories;
using FinanceMvc.Models;

namespace FinanceMvc.Repositories.Entity
{
    public class RepositoryFactory : IRepositoryFactory
    {
        protected readonly FinanceMvcContext Db;
        protected ICategoryRepository CategoryRepository;
        protected IPropertyRepository PropertyRepository;
        protected ITransactionRepository TransactionRepository;
        protected IAccountRepository AccountRepository;
        protected IUserRepository UserRepository;

        public RepositoryFactory()
        {
            Db = new FinanceMvcContext();
        }

        public ICategoryRepository GetCategoryRepository()
        {
            CategoryRepository = CategoryRepository ?? new CategoryRepository(Db);
            return CategoryRepository;
        }

        public IPropertyRepository GetPropertyRepository()
        {
            PropertyRepository = PropertyRepository ?? new PropertyRepository(Db);
            return PropertyRepository;
        }

        public ITransactionRepository GetTransactionRepository()
        {
            TransactionRepository = TransactionRepository ?? new TransactionRepository(Db);
            return TransactionRepository;
        }

        public IAccountRepository GetAccountRepository()
        {
            AccountRepository = AccountRepository ?? new AccountRepository(Db);
            return AccountRepository;
        }

        public IUserRepository GetUserRepository()
        {
            UserRepository = UserRepository ?? new UserRepository(Db);
            return UserRepository;
        }
    }
}