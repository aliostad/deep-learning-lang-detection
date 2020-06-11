namespace DataAccess.Repository
{
    public class RepositoryFactory
    {
        public static UsersRepository GetUsersRepository()
        {
            return new UsersRepository();
        }

        public static ContactsRepository GetContactsRepository()
        {
            return new ContactsRepository();
        }

        public static PhonesRepository GetPhonesRepository()
        {
            return new PhonesRepository();
        }

        public static AccountRepository GetAccountRepository()
        {
            return new AccountRepository();
        }

        public static CardRepository GetCardRepository()
        {
            return new CardRepository();
        }

        public static BranchRepository GetBranchRepository()
        {
            return new BranchRepository();
        }

        public static TransactionRepository GetTransactionRepository()
        {
            return new TransactionRepository();
        }
    }
}
