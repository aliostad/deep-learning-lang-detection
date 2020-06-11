using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PictureManager
{
    public class UserRepositoryFactory
    {
        public static Func<IUserRepository> RepositoryBuilder =
        CreateDefaultRepositoryBuilder;
        private static IUserRepository CreateDefaultRepositoryBuilder()
        {
            throw new Exception("No repository builder specified.");
        }
        public IUserRepository BuildRepository()
        {
            IUserRepository repository = RepositoryBuilder();
            return repository;
        }
    }
}
