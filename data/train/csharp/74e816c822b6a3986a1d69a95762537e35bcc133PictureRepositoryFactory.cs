using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PictureManager
{
    public class PictureRepositoryFactory
    {
        public static Func<IPictureRepository> RepositoryBuilder =
        CreateDefaultRepositoryBuilder;
        private static IPictureRepository CreateDefaultRepositoryBuilder()
        {
            throw new Exception("No repository builder specified.");
        }
        public IPictureRepository BuildRepository()
        {
            IPictureRepository repository = RepositoryBuilder();
            return repository;
        }
    }
}
