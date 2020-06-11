namespace moonstone.core.repositories
{
    public class RepositoryHub
    {
        public IBankAccountRepository BankAccountRepository { get; protected set; }
        public ICategoryRepository CategoryRepository { get; protected set; }
        public IGroupRepository GroupRepository { get; protected set; }
        public IGroupUserRepository GroupUserRepository { get; protected set; }
        public ITransactionRepository TransactionRepository { get; protected set; }
        public IUserRepository UserRepository { get; protected set; }

        public RepositoryHub(
            IUserRepository userRepository,
            IGroupRepository groupRepository,
            IGroupUserRepository groupUserRepository,
            ICategoryRepository categoryRepository,
            IBankAccountRepository bankAccountRepository,
            ITransactionRepository transactionRepository)
        {
            this.UserRepository = userRepository;
            this.GroupRepository = groupRepository;
            this.GroupUserRepository = groupUserRepository;
            this.CategoryRepository = categoryRepository;
            this.BankAccountRepository = bankAccountRepository;
            this.TransactionRepository = transactionRepository;
        }
    }
}