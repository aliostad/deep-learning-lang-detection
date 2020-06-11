using System.Threading;

namespace ProductStore.Users_WCFService.Repository
{
    public class UserRepositoryFactory
    {
        private static IUserRepository _userRepository;

        private UserRepositoryFactory() { }

        public static IUserRepository GetUserRepository()
        {
            if (_userRepository != null)
                return _userRepository;

            var tmpUserRepository = new UserRepository();

            Interlocked.CompareExchange(ref _userRepository, tmpUserRepository, null);
            return tmpUserRepository;
        }

    }
}
